param(
  [Parameter(Mandatory = $true)][string]$Keys,
  [string]$ProcessName = "msedge",
  [string]$TitlePattern = "",
  [string]$OutPath = "",
  [int]$DelayMs = 700
)

Add-Type -AssemblyName System.Windows.Forms
& "$PSScriptRoot\focus_window.ps1" -ProcessName $ProcessName -TitlePattern $TitlePattern | Out-Null

[System.Windows.Forms.SendKeys]::SendWait($Keys)

if ($OutPath) {
  & "$PSScriptRoot\capture_screen.ps1" -OutPath $OutPath -DelayMs $DelayMs
}
