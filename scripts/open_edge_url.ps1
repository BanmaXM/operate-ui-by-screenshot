param(
  [Parameter(Mandatory = $true)][string]$Url,
  [string]$OutPath = "",
  [int]$DelayMs = 2500,
  [switch]$ResetZoom,
  [switch]$NewTab
)

Add-Type -AssemblyName System.Windows.Forms

$edge = Get-Process msedge -ErrorAction SilentlyContinue |
  Where-Object { $_.MainWindowHandle -ne 0 } |
  Select-Object -First 1

if (-not $edge) {
  Start-Process msedge.exe $Url
  Start-Sleep -Milliseconds $DelayMs
} else {
  & "$PSScriptRoot\focus_window.ps1" -ProcessName msedge | Out-Null
  if ($ResetZoom) {
    [System.Windows.Forms.SendKeys]::SendWait("^0")
    Start-Sleep -Milliseconds 150
  }
  if ($NewTab) {
    [System.Windows.Forms.SendKeys]::SendWait("^t")
    Start-Sleep -Milliseconds 150
  }
  Set-Clipboard -Value $Url
  [System.Windows.Forms.SendKeys]::SendWait("^l")
  Start-Sleep -Milliseconds 100
  [System.Windows.Forms.SendKeys]::SendWait("^v")
  Start-Sleep -Milliseconds 100
  [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
  Start-Sleep -Milliseconds $DelayMs
}

if ($OutPath) {
  & "$PSScriptRoot\capture_screen.ps1" -OutPath $OutPath
}
