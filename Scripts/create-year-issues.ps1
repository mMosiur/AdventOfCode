[CmdletBinding()]
param (
    [Parameter()]
    [int]$Year = (Get-Date).Year,
    [Parameter()]
    [int]$FirstDay = 1,
    [Parameter()]
    [int]$LastDay = 25,
    [Parameter()]
    [string]$Milestone = "Advent of Code $Year",
    [Parameter()]
    [string]$Assignee = "@me",
    [Parameter()]
    [string]$ProjectName = "Advent of Code solving"
)

$repository = "mMosiur/AdventOfCode$Year"

# Check if GitHub CLI is installed
if (-not (gh --version)) {
    Write-Error "GitHub CLI is not installed."
    exit 1
}

# Check if the repository exists
$repositoryExists = gh repo view $repository --json "name" | ConvertFrom-Json
if (-not $repositoryExists) {
    Write-Error "Repository '$repository' does not exist."
    exit 1
}

# Print the script config
Write-Host "Creating issues for Advent of Code $Year"
Write-Host "Repository: $repository"
Write-Host "In scope: days from $FirstDay to $LastDay"
Write-Host "Assigning to: $Assignee"
Write-Host "Adding to project: $ProjectName"
Write-Host "Adding to milestone: $Milestone"

# Ask user for confirmation, default to no
$confirmation = Read-Host "Do you want to continue? (y/N)"
if ($confirmation -notmatch "^(y|ye|yes)$") {
    Write-Host "Aborted."
    exit 1
}

for ($i = $FirstDay; $i -le $LastDay; $i++) {
    $issueTitle = "Solve day $i"

    # Check if issue with the same title already exists
    $issueExists = gh issue list --repo "$repository" --state "all" --search "$issueTitle" --json "title" | ConvertFrom-Json
    if ($issueExists) {
        Write-Host "Issue '$issueTitle' already exists, skipping"
        continue
    }

    Write-Host "Creating issue: $issueTitle"
    $issueBody = "Solve both parts of [day $i of Advent of Code $Year](https://adventofcode.com/$Year/day/$i)"
    gh issue create --title "$issueTitle" --body "$issueBody" --project "$ProjectName" --milestone "$Milestone" --assignee "$Assignee" --repo "$repository"
}
