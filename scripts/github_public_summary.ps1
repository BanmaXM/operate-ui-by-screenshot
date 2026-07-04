param(
  [Parameter(Mandatory = $true)][ValidateSet("user", "search")][string]$Mode,
  [Parameter(Mandatory = $true)][string]$Value,
  [string]$OutDir = "."
)

$headers = @{
  "Accept" = "application/vnd.github+json"
  "User-Agent" = "CodexPublicGitHubSummary/1.0"
}

if (-not (Test-Path -LiteralPath $OutDir)) {
  New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
}

if ($Mode -eq "user") {
  $username = $Value
  $user = Invoke-RestMethod -Uri "https://api.github.com/users/$([uri]::EscapeDataString($username))" -Headers $headers
  $repos = Invoke-RestMethod -Uri "https://api.github.com/users/$([uri]::EscapeDataString($username))/repos?per_page=100&sort=updated" -Headers $headers
  $summary = [pscustomobject]@{
    source = "public GitHub API"
    note = "Unauthenticated public API does not list private repositories."
    user = [pscustomobject]@{
      login = $user.login
      name = $user.name
      html_url = $user.html_url
      public_repos = $user.public_repos
      followers = $user.followers
      following = $user.following
      created_at = $user.created_at
      updated_at = $user.updated_at
    }
    repos = @($repos | ForEach-Object {
      [pscustomobject]@{
        name = $_.name
        full_name = $_.full_name
        visibility = $_.visibility
        html_url = $_.html_url
        description = $_.description
        language = $_.language
        stars = $_.stargazers_count
        forks = $_.forks_count
        updated_at = $_.updated_at
        pushed_at = $_.pushed_at
      }
    })
  }
  $outPath = Join-Path $OutDir "github-$($user.login)-public-summary.json"
  $summary | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $outPath -Encoding UTF8
  [pscustomobject]@{ outPath = $outPath; login = $user.login; publicRepos = @($summary.repos).Count } | ConvertTo-Json -Compress
}

if ($Mode -eq "search") {
  $query = $Value
  $encoded = [uri]::EscapeDataString($query)
  $result = Invoke-RestMethod -Uri "https://api.github.com/search/repositories?q=$encoded&per_page=10&sort=stars&order=desc" -Headers $headers
  $summary = [pscustomobject]@{
    source = "public GitHub search API"
    query = $query
    total_count = $result.total_count
    items = @($result.items | ForEach-Object {
      [pscustomobject]@{
        full_name = $_.full_name
        html_url = $_.html_url
        description = $_.description
        language = $_.language
        stars = $_.stargazers_count
        forks = $_.forks_count
        updated_at = $_.updated_at
      }
    })
  }
  $safeName = ($query -replace '[^a-zA-Z0-9._-]+', '_')
  if ($safeName.Length -gt 80) { $safeName = $safeName.Substring(0, 80) }
  if (-not $safeName) { $safeName = "query" }
  $outPath = Join-Path $OutDir "github-search-$safeName.json"
  $summary | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $outPath -Encoding UTF8
  [pscustomobject]@{ outPath = $outPath; totalCount = $result.total_count; returned = @($summary.items).Count } | ConvertTo-Json -Compress
}
