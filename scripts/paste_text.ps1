param(
  [Parameter(Mandatory = $true)][string]$Text,
  [string]$ProcessName = "msedge",
  [string]$TitlePattern = "",
  [switch]$SelectAll,
  [switch]$Submit,
  [string]$OutPath = "",
  [int]$DelayMs = 700
)

Add-Type -AssemblyName System.Windows.Forms
& "$PSScriptRoot\focus_window.ps1" -ProcessName $ProcessName -TitlePattern $TitlePattern | Out-Null

Set-Clipboard -Value $Text
if ($SelectAll) {
  [System.Windows.Forms.SendKeys]::SendWait("^a")
  Start-Sleep -Milliseconds 100
}
[System.Windows.Forms.SendKeys]::SendWait("^v")
Start-Sleep -Milliseconds 150
if ($Submit) {
  [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
}

if ($OutPath) {
  & "$PSScriptRoot\capture_screen.ps1" -OutPath $OutPath -DelayMs $DelayMs
}
