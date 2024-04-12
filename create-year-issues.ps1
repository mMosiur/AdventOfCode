$aocYear = 2023
$firstDayIssue = 1
$lastDayIssue = 25

$milestone = "Advent of Code $aocYear"
$assignee = "@me"
$projectName = "Advent of Code solving"
$repository = "mMosiur/AdventOfCode$aocYear"

# Print the script config
Write-Host "Creating issues for Advent of Code $aocYear"
Write-Host "Repository: $repository"
Write-Host "In scope: days from $firstDayIssue to $lastDayIssue"
Write-Host "Assigning to: $assignee"
Write-Host "Adding to project: $projectName"
Write-Host "Adding to milestone: $milestone"

# Ask user for confirmation, default to yes
$confirmation = Read-Host "Do you want to continue? (Y/n)"
if ($confirmation -ne "Y" -and $confirmation -ne "") {
    Write-Host "Aborted."
    exit
}


for ($i = $firstDayIssue; $i -le $lastDayIssue; $i++) {
    $issueTitle = "Solve day $i"

    # Check if issue with the same title already exists
    $issueExists = gh issue list --repo "$repository" --state "all" --search "$issueTitle" --json "title" | ConvertFrom-Json
    if ($issueExists) {
        Write-Host "Issue '$issueTitle' already exists, skipping"
        continue
    }

    Write-Host "Creating issue: $issueTitle"
    $issueBody = "Solve both parts of [day $i of Advent of Code $aocYear](https://adventofcode.com/$aocYear/day/$i)"
    gh issue create --title "$issueTitle" --body "$issueBody" --project "$projectName" --milestone "$milestone" --assignee "$assignee" --repo "$repository"
}
