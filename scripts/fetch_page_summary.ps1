param(
  [Parameter(Mandatory = $true)][string]$Url,
  [string]$OutDir = "."
)

if (-not (Test-Path -LiteralPath $OutDir)) {
  New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
}

$headers = @{
  "User-Agent" = "Mozilla/5.0 (compatible; CodexPageSummary/1.0)"
}

$response = Invoke-WebRequest -Uri $Url -Headers $headers -UseBasicParsing
$html = $response.Content
$title = ""
if ($html -match "(?is)<title[^>]*>(.*?)</title>") {
  $title = ($Matches[1] -replace "\s+", " ").Trim()
}

$links = @()
$matches = [regex]::Matches($html, "(?is)<a\b[^>]*href=['""]([^'""]+)['""][^>]*>(.*?)</a>")
foreach ($match in $matches | Select-Object -First 50) {
  $text = ($match.Groups[2].Value -replace "<[^>]*>", " " -replace "\s+", " ").Trim()
  if ($text.Length -gt 120) { $text = $text.Substring(0, 120) }
  $links += [pscustomobject]@{
    href = $match.Groups[1].Value
    text = $text
  }
}

$hostName = ([uri]$response.BaseResponse.ResponseUri.AbsoluteUri).Host
if (-not $hostName) { $hostName = ([uri]$Url).Host }
$safeName = $hostName -replace '[^a-zA-Z0-9.-]+', '_'
if (-not $safeName) { $safeName = "page" }

$htmlPath = Join-Path $OutDir "$safeName.html"
$jsonPath = Join-Path $OutDir "$safeName.summary.json"
$html | Set-Content -LiteralPath $htmlPath -Encoding UTF8
[pscustomobject]@{
  url = $Url
  finalUrl = $response.BaseResponse.ResponseUri.AbsoluteUri
  status = [int]$response.StatusCode
  contentType = $response.Headers["Content-Type"]
  title = $title
  links = $links
} | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $jsonPath -Encoding UTF8

[pscustomobject]@{ htmlPath = $htmlPath; jsonPath = $jsonPath; status = [int]$response.StatusCode; title = $title } | ConvertTo-Json -Compress
