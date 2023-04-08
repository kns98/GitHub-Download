# Set the username of the GitHub user whose repositories you want to download
$username = "<user>"

# Set the access token with the "repo" scope from your GitHub account
$accessToken = "<token>"

# Construct the API endpoint URL to get the list of the user's repositories
$url = "https://api.github.com/users/$username/repos"

# Set the headers for the API request
$headers = @{
    "Authorization" = "Bearer $accessToken"
    "Accept" = "application/vnd.github.v3+json"
}

# Send the API request and parse the JSON response
$repos = Invoke-RestMethod -Uri $url -Headers $headers

# Loop through the repositories and clone them to the current directory
foreach ($repo in $repos) {
    $cloneUrl = $repo.clone_url
    Write-Output "Cloning $cloneUrl"
    git clone $cloneUrl
}
