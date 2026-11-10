# Publish the allowlisted refs of the private source repository to the public
# ClassMaterials repository. Strongback maintainers only - see README.md here.
# Windows counterpart of publish.sh; the two must keep the same allowlist and gate.
#
#   .\maintainer\publish.ps1            publish (and restore - it is the same thing)
#   .\maintainer\publish.ps1 -DryRun    show what would be pushed and deleted

param([switch]$DryRun)

$ErrorActionPreference = 'Stop'

$Public   = if ($env:CLASSMATERIALS_PUBLIC) { $env:CLASSMATERIALS_PUBLIC } else { 'git@github.com:Strongback-Consulting/ClassMaterials.git' }
$Branches = @('main', 'develop', 'release')
$Tags     = @('class-start')

function Die($msg) { Write-Host "publish: $msg" -ForegroundColor Red; exit 1 }
function Git { & git @args; if ($LASTEXITCODE -ne 0) { Die "git $($args -join ' ') failed." } }

$top = (& git rev-parse --show-toplevel 2>$null)
if (-not $top) { Die 'not inside a git repository.' }
Set-Location $top
if (-not (Test-Path ClassMaterials.code-workspace)) { Die 'this is not a ClassMaterials repository.' }

$origin = (& git remote get-url origin 2>$null)
if (-not $origin) { Die "no 'origin' remote." }
if ($origin -match 'Strongback-Consulting/ClassMaterials') {
    Die 'origin is the PUBLIC repository. Run this from a clone of the private source repository.'
}

# --- Every published ref must exist locally and match the private repository
Git fetch -q --tags origin

$refs = @()
foreach ($b in $Branches) {
    $l = (& git rev-parse -q --verify "refs/heads/$b")
    if (-not $l) { Die "local branch '$b' is missing." }
    $r = (& git rev-parse -q --verify "refs/remotes/origin/$b")
    if ($l -ne $r) { Die "local '$b' does not match origin/$b - push or pull first, so only reviewed work is published." }
    $refs += "refs/heads/$b"
}
foreach ($t in $Tags) {
    $l = (& git rev-parse -q --verify "refs/tags/$t^{commit}")
    if (-not $l) { Die "tag '$t' is missing." }
    $r = ((& git ls-remote origin "refs/tags/$t") -split "`t")[0]
    if (-not $r) { Die "tag '$t' has not been pushed to origin." }
    if ((& git rev-parse "$r^{commit}") -ne $l) { Die "local tag '$t' differs from origin's." }
    $refs += "refs/tags/$t"
}

# --- The gate: nothing in the published history may be private -------------
Write-Host "Checking the history of: $($refs -join ' ')"
$fail = $false

$badPaths = & git log --format= --name-only @refs | Where-Object { $_ -match '(^|/)\.DS_Store$|^\.github/workflows/' } | Sort-Object -Unique
if ($badPaths) { Write-Host '  REFUSED: these paths appear in the published history:'; $badPaths | ForEach-Object { "    $_" }; $fail = $true }

$secret = 'ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|glpat-[A-Za-z0-9_-]{10,}|-----BEGIN [A-Z ]*PRIVATE KEY-----|strongback\.us|ssh -p [0-9]+ '
if (& git log -p --format=%B @refs | Select-String -Pattern $secret -Quiet) {
    Write-Host '  REFUSED: the history contains a token, a private key or an internal host name.'
    $fail = $true
}

$badMail = & git log --format='%ae%n%ce' @refs | Sort-Object -Unique |
    Where-Object { $_ -and $_ -notmatch '@example\.invalid$|@users\.noreply\.github\.com$' }
if ($badMail) {
    Write-Host '  REFUSED: commits carry personal email addresses:'; $badMail | ForEach-Object { "    $_" }
    Write-Host '  Commit with a role identity - see maintainer/README.md.'
    $fail = $true
}

if ($fail) { Die 'nothing was published.' }
Write-Host '  clean.'

# --- Push the allowlist, then remove anything else from the public copy ----
$dry   = if ($DryRun) { @('--dry-run') } else { @() }
$specs = $refs | ForEach-Object { "+${_}:$_" }

Write-Host ''
Write-Host "Publishing to $Public$(if ($DryRun) { ' (dry run)' })"
Git push @dry --atomic $Public @specs

$extra = & git ls-remote --heads --tags $Public | ForEach-Object { ($_ -split "`t")[1] } |
    Where-Object { $_ -notmatch '\^\{\}$' -and $refs -notcontains $_ }
if ($extra) {
    Write-Host ''
    Write-Host 'Removing refs that are not on the allowlist:'
    $extra | ForEach-Object { "  $_" }
    Git push @dry $Public --delete @extra
}

Write-Host ''
if ($DryRun) { Write-Host 'Dry run only - nothing was changed.' }
else { Write-Host 'Done. Confirm with: maintainer/check-public.sh' }
