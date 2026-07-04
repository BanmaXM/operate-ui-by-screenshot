param(
  [string]$ProcessName = "msedge",
  [string]$TitlePattern = "",
  [int]$WaitSeconds = 0
)

Add-Type @'
using System;
using System.Runtime.InteropServices;
public class CodexFocusWindow {
  [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);
}
'@

$deadline = (Get-Date).AddSeconds($WaitSeconds)
do {
  $candidates = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue |
    Where-Object { $_.MainWindowHandle -ne 0 }
  if ($TitlePattern) {
    $candidates = $candidates | Where-Object { $_.MainWindowTitle -match $TitlePattern }
  }
  $target = $candidates | Sort-Object StartTime -Descending | Select-Object -First 1
  if ($target) { break }
  Start-Sleep -Milliseconds 250
} while ((Get-Date) -lt $deadline)

if (-not $target) {
  throw "No foregroundable window found for process '$ProcessName'."
}

[CodexFocusWindow]::SetForegroundWindow($target.MainWindowHandle) | Out-Null
Start-Sleep -Milliseconds 200
[pscustomobject]@{
  ProcessName = $target.ProcessName
  Id = $target.Id
  MainWindowTitle = $target.MainWindowTitle
} | ConvertTo-Json -Compress
