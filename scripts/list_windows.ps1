param(
  [string]$ProcessName = "",
  [string]$TitlePattern = ""
)

$items = Get-Process -ErrorAction SilentlyContinue |
  Where-Object { $_.MainWindowHandle -ne 0 }

if ($ProcessName) {
  $items = $items | Where-Object { $_.ProcessName -eq $ProcessName }
}
if ($TitlePattern) {
  $items = $items | Where-Object { $_.MainWindowTitle -match $TitlePattern }
}

$items |
  Sort-Object ProcessName, MainWindowTitle |
  Select-Object ProcessName, Id, MainWindowTitle, MainWindowHandle |
  ConvertTo-Json -Depth 3
