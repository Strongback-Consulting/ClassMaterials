# Class repository helper for the IDz on VS Code Git track.
#
# The normal path for a student is NOT this script: it is cloning the class
# repository your instructor gives you (see CLASS-REPO-SETUP.md). Use this
# only in the two cases below.
#
#   .\git-bootstrap.ps1
#       No repository here yet, and no class repository to clone (no network,
#       no fork). Creates a local repository from this folder with the same
#       starting history a clone would have given you.
#
#   .\git-bootstrap.ps1 -SeedExisting
#       Instructor use, inside a fresh clone of the class repository. Adds the
#       teaching history the labs read - an as-delivered tag and two
#       maintenance commits - if it is not already there. Push afterwards so
#       every student's clone carries it.
#
# If PowerShell refuses to run the script, allow it for this session only:
#   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
#
# Safe to re-run: it never touches a repository that already has the history.
#
# macOS and Linux: use git-bootstrap.sh instead.

[CmdletBinding()]
param([switch]$SeedExisting)

$ErrorActionPreference = 'Stop'

function Die($msg) { Write-Error "ERROR: $msg"; exit 1 }

# --- Guards ---------------------------------------------------------------

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Die "git is not on your PATH. Install Git for Windows, reopen PowerShell, and try again."
}

if (-not (Test-Path 'ClassMaterials.code-workspace')) {
    Die "run this from inside the ClassMaterials folder (the one holding ClassMaterials.code-workspace)."
}

$here = (Get-Location).Path
$top  = & git rev-parse --show-toplevel 2>$null
if ($LASTEXITCODE -ne 0) { $top = $null }

if ($top) {
    $topFull = (Resolve-Path $top).Path
    if ($topFull -ne $here) {
        Die "this folder sits inside the git repository at:`n       $topFull`n     Copy ClassMaterials somewhere outside it, then work there."
    }
}

$haveRepo = [bool]$top

if (-not $haveRepo -and $SeedExisting) {
    Die "-SeedExisting expects an existing clone of the class repository here."
}

if ($haveRepo -and -not $SeedExisting) {
    Write-Host "This folder is already a git repository - nothing to do."
    Write-Host ""
    Write-Host "If you cloned the class repository, you are ready: open"
    Write-Host "ClassMaterials.code-workspace in VS Code and start the git-repositories lab."
    Write-Host ""
    Write-Host "Instructors preparing a fork can add the teaching history with:"
    Write-Host "    .\git-bootstrap.ps1 -SeedExisting"
    exit 0
}

# --- Create the repository, when there is nothing to clone ----------------

if (-not $haveRepo) {
    Write-Host "No class repository to clone, so creating one here instead."
    Write-Host "Creating a git repository in $here ..."
    & git init -q -b main 2>$null
    if ($LASTEXITCODE -ne 0) {
        & git init -q
        & git symbolic-ref HEAD refs/heads/main
    }
}

# Identity: only set one if the student has none, so we never overwrite a
# developer's real name. git-repositories teaches them to set their own.
$existingEmail = & git config user.email 2>$null
if ([string]::IsNullOrWhiteSpace($existingEmail)) {
    & git config user.name  "Class Student"
    & git config user.email "student@example.invalid"
    $identityPlaceholder = $true
} else {
    $identityPlaceholder = $false
}

# --- The as-delivered commit ----------------------------------------------

if (-not $haveRepo) {
    # Many delivered samples arrived with Windows line endings; .gitattributes
    # normalises them to LF on the way in. That conversion is intended and
    # one-time, so silence git's per-file warning for this bulk import only -
    # the student's own edits still get the default warnings.
    & git -c core.safecrlf=false add -A
    & git commit -q -m @"
Class materials, as delivered

The COBOL, JCL, REXX and copybook samples the labs work on, plus the
workspace, ZAPP and connection templates. This is the pristine starting
point; the class-start tag marks it.
"@ --author="Strongback Consulting <training@example.invalid>"
    Write-Host "  commit 1/3  class materials imported"
}

& git rev-parse -q --verify refs/tags/class-start 2>$null | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Host "  tag class-start already present"
} else {
    & git tag class-start
    Write-Host "  tagged class-start"
}

# --- Seeded history so blame, log and revert have something to show --------
# Two later maintenance edits by two different people, in the style of a real
# shop's change log. git-history-recovery reads these.

$log = & git log --oneline 2>$null
if ($log -and ($log -match 'tighten ward code validation')) {
    Write-Host ""
    Write-Host "The teaching history is already here - nothing further to do."
    exit 0
}

function Insert-After($File, $Anchor, $Lines) {
    $out = New-Object System.Collections.Generic.List[string]
    $done = $false
    foreach ($line in (Get-Content -LiteralPath $File)) {
        $out.Add($line)
        if (-not $done -and $line.Contains($Anchor)) {
            foreach ($new in $Lines) { $out.Add($new) }
            $done = $true
        }
    }
    Set-Content -LiteralPath $File -Value $out
}

$sandbox = 'src/cobol/SANDBOX.cbl'
if (-not (Test-Path $sandbox)) {
    Die "$sandbox is missing - is this a complete ClassMaterials folder?"
}

Insert-After $sandbox '*REMARKS.' @(
    '      *',
    '      *  MAINTENANCE LOG',
    '      *  2026-02-11  A.RIVERA   Ward code validation tightened (RFC 4471)'
)
& git -c core.safecrlf=false add $sandbox
& git commit -q -m @"
SANDBOX: tighten ward code validation

Ward codes coming off the daily patient file were accepted without a
range check, so a mistyped ward silently reported under ward 0.
Raised by the night shift as RFC 4471.
"@ --author="A. Rivera <a.rivera@example.invalid>"
Write-Host "  commit 2/3  ward code validation note (A. Rivera)"

Insert-After $sandbox 'MAINTENANCE LOG' @(
    '      *  2026-05-03  M.OKAFOR   Bed-count rounding corrected (INC 55219)'
)
& git -c core.safecrlf=false add $sandbox
& git commit -q -m @"
SANDBOX: correct bed-count rounding

Occupancy percentages rounded down at every control break, so a full
ward could report 99%. Reported as INC 55219.
"@ --author="M. Okafor <m.okafor@example.invalid>"
Write-Host "  commit 3/3  bed-count rounding note (M. Okafor)"

# --- Report ---------------------------------------------------------------

Write-Host ""
Write-Host "Done. The class repository history now reads:"
Write-Host ""
& git --no-pager log --oneline --decorate -5
Write-Host ""
if ($SeedExisting) {
    Write-Host "Instructor: push this so every student's clone carries it, e.g."
    Write-Host "    git push origin main --tags"
    Write-Host ""
}
if ($identityPlaceholder) {
    Write-Host "Your commits will be signed 'Class Student' until you set your own name."
    Write-Host "The git-repositories lab shows you how:"
    Write-Host '    git config user.name  "Your Name"'
    Write-Host '    git config user.email "you@your-company.com"'
    Write-Host ""
}
Write-Host "Next: open ClassMaterials.code-workspace in VS Code and look at the"
Write-Host "Source Control view - it now shows this repository."
