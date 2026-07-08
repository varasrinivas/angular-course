# validate-course.ps1 — Angular Mastery course validator
# Usage:
#   pwsh scripts/validate-course.ps1              # validate whole course
#   pwsh scripts/validate-course.ps1 -Module 3.2  # validate one module
param(
    [string]$Module = "",
    [string]$PlayerPath = "player/index.html"
)

$ErrorActionPreference = "Stop"
$script:failCount = 0
$script:passCount = 0

function Check([bool]$ok, [string]$label) {
    if ($ok) { $script:passCount++; Write-Host "  PASS  $label" -ForegroundColor Green }
    else     { $script:failCount++; Write-Host "  FAIL  $label" -ForegroundColor Red }
}

if (-not (Test-Path $PlayerPath)) {
    Write-Host "FATAL: $PlayerPath not found. Run from the kit root." -ForegroundColor Red
    exit 1
}
$html = Get-Content $PlayerPath -Raw

# ---------------------------------------------------------------- course-level
$expectedPerTrack = @{ 1 = 7; 2 = 8; 3 = 9; 4 = 6; 5 = 6; 6 = 6 }
$domainTerms = @("AuthRequest", "Member", "Provider", "ClinicalCriteria", "AUTO_APPROVE_THRESHOLD", "0.85")

$markerRegex = [regex]'/\*\s*[-─—\s]*MOD\s+(\d+\.\d+)\s*[-─—\s]*\*/'
$markers = $markerRegex.Matches($html)

if ($markers.Count -eq 0) {
    Write-Host "FATAL: no '/* -- MOD X.Y -- */' markers found in MODS array." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Angular Mastery validator - $($markers.Count) module block(s) found" -ForegroundColor Cyan
Write-Host ("-" * 60)

# Build (id, startIndex, endIndex) blocks
$blocks = @()
for ($i = 0; $i -lt $markers.Count; $i++) {
    $start = $markers[$i].Index
    $end = if ($i + 1 -lt $markers.Count) { $markers[$i + 1].Index } else {
        # end of MODS array: last '];' before the ENGINE banner (module code
        # samples may themselves contain '];', so a forward search truncates)
        $engineIdx = $html.IndexOf("ENGINE")
        $tail = if ($engineIdx -gt $start) { $html.LastIndexOf("];", $engineIdx) } else { $html.IndexOf("];", $start) }
        if ($tail -lt $start) { $html.Length } else { $tail }
    }
    $blocks += [pscustomobject]@{
        Id   = $markers[$i].Groups[1].Value
        Body = $html.Substring($start, $end - $start)
    }
}

# Duplicates + ordering
$ids = $blocks | ForEach-Object { $_.Id }
$dupes = $ids | Group-Object | Where-Object { $_.Count -gt 1 }
Check ($dupes.Count -eq 0) "no duplicate module ids"
$sorted = $ids | Sort-Object { [double]($_ -replace '\.', '.0') } # crude but ok: compare below properly
$ordered = $true
for ($i = 1; $i -lt $ids.Count; $i++) {
    $a = $ids[$i - 1].Split('.'); $b = $ids[$i].Split('.')
    if ([int]$b[0] -lt [int]$a[0] -or ([int]$b[0] -eq [int]$a[0] -and [int]$b[1] -le [int]$a[1])) { $ordered = $false }
}
Check $ordered "modules are in id order"

# Track counts (report-only until course complete; fail if over)
foreach ($t in 1..6) {
    $built = ($ids | Where-Object { $_.StartsWith("$t.") }).Count
    $exp = $expectedPerTrack[$t]
    if ($built -gt $exp) { Check $false "track ${t}: $built modules exceeds spec of $exp" }
    else { Write-Host "  INFO  track ${t}: $built / $exp modules built" -ForegroundColor DarkGray }
}

# ---------------------------------------------------------------- module-level
$targets = if ($Module) { $blocks | Where-Object { $_.Id -eq $Module } } else { $blocks }
if ($Module -and $targets.Count -eq 0) {
    Write-Host "FATAL: module $Module not found in MODS." -ForegroundColor Red
    exit 1
}

foreach ($b in $targets) {
    Write-Host ""
    Write-Host "MOD $($b.Id)" -ForegroundColor Cyan
    $body = $b.Body

    # id/track consistency
    $trackFromId = [int]$b.Id.Split('.')[0]
    Check ($body -match "id:\s*[`"']$([regex]::Escape($b.Id))[`"']") "id field matches marker"
    Check ($body -match "track:\s*$trackFromId\b") "track matches id prefix ($trackFromId)"

    # required fields
    foreach ($field in @("title:", "duration:", "objectives:", "sections:", "lab:", "quiz:")) {
        Check ($body -match [regex]::Escape($field)) "has $($field.TrimEnd(':'))"
    }

    # sections: at least 3 headings, final one is the domain section
    $headings = [regex]::Matches($body, "heading:\s*[`"'](.*?)[`"']")
    Check ($headings.Count -ge 3) "at least 3 sections ($($headings.Count) found)"
    if ($headings.Count -gt 0) {
        $last = $headings[$headings.Count - 1].Groups[1].Value
        Check ($last -eq "In the Prior Auth Portal") "final section is 'In the Prior Auth Portal' (got '$last')"
    }

    # dual-path lab
    Check ($body -match "scenario:")        "lab has scenario"
    Check ($body -match "understandIt:")    "lab has Understand It path"
    Check ($body -match "buildItWithAI:")   "lab has Build It with AI path"
    Check ($body -match "prompts:")         "Build It path has prompts"
    Check ($body -match "acceptance:")      "Build It path has acceptance criteria"
    $steps = [regex]::Matches(($body -split "understandIt:")[-1], "[`"'].{10,}?[`"']")
    # (step count is informational; deep-counting JS arrays via regex is unreliable)

    # quiz: exactly 4 questions, answers in range
    $qCount = ([regex]::Matches($body, "\bq:\s*[`"']")).Count
    Check ($qCount -eq 4) "quiz has exactly 4 questions ($qCount found)"
    $answers = [regex]::Matches($body, "answer:\s*(\d+)")
    $answersOk = $true
    foreach ($a in $answers) { if ([int]$a.Groups[1].Value -gt 3) { $answersOk = $false } }
    Check ($answersOk -and $answers.Count -eq $qCount) "quiz answers present and 0-3"
    $explains = ([regex]::Matches($body, "explain:\s*[`"']")).Count
    Check ($explains -eq $qCount) "every question has an explain"

    # domain anchoring
    $found = @($domainTerms | Where-Object { $body -match [regex]::Escape($_) })
    Check ($found.Count -ge 1) "domain-anchored (found: $($found -join ', '))"

    # Angular 20 hygiene (legacy syntax allowed only in 1.4's comparison)
    if ($b.Id -ne "1.4") {
        $legacy = [regex]::Matches($body, '\*ngIf|\*ngFor|NgModule\(')
        Check ($legacy.Count -eq 0) "no legacy *ngIf/*ngFor/NgModule teaching ($($legacy.Count) found)"
    }
}

# ---------------------------------------------------------------- summary
Write-Host ""
Write-Host ("-" * 60)
Write-Host "RESULT: $script:passCount passed, $script:failCount failed" -ForegroundColor $(if ($script:failCount -eq 0) { "Green" } else { "Red" })
exit $(if ($script:failCount -eq 0) { 0 } else { 1 })
