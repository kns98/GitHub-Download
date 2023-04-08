# Set the username of the GitHub user whose repositories you want to download
$username = "<user>"
Write-Host "Username set to $username"

# Set the access token with the "repo" scope from your GitHub account
$accessToken = "<token>"
Write-Host "Access token set"

# Set the headers for the API request
$headers = @{
    "Authorization" = "Bearer $accessToken"
    "Accept" = "application/vnd.github.v3+json"
}
Write-Host "Headers set"

# Set the initial API endpoint URL to get the first page of the user's repositories
$url = "https://api.github.com/users/$username/repos"
Write-Host "API endpoint URL set to $url"

# Set the page number to 1
$page = 1
Write-Host "Page number set to $page"

# Set the per_page parameter to limit the number of repositories per page to 30
$per_page = 30
Write-Host "Repositories per page set to $per_page"

# Initialize a variable to hold all the repositories
$all_repos = @()
Write-Host "Variable for all repositories initialized"

# Loop through all pages of the user's repositories
do {
    # Add the page and per_page parameters to the API endpoint URL
    $paged_url = "https://api.github.com/users/$username/repos?page=$page&per_page=$per_page"
    Write-Host "Fetching repositories from $paged_url"

    # Send the API request and parse the JSON response
    $repos = Invoke-RestMethod -Uri $paged_url -Headers $headers
    Write-Output "Fetched $($repos.Count) repositories from page $page"

    # Add the current page of repositories to the list of all repositories
    $all_repos += $repos
    Write-Output "Added $($repos.Count) repositories to the list of all repositories"

    # Increment the page number for the next iteration
    $page++
    Write-Host "Moving on to page $page"

    # Wait for 1 second to avoid hitting the GitHub API rate limit
    Start-Sleep -Seconds 1

} while ($repos.Count -gt 0)

# Loop through all repositories and clone them to the current directory
foreach ($repo in $all_repos) {
    $cloneUrl = $repo.clone_url
    Write-Output "Cloning $cloneUrl"
    git clone $cloneUrl
}
Write-Host "All repositories cloned successfully"
