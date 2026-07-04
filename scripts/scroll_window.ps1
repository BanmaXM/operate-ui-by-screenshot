param(
  [int]$X = 960,
  [int]$Y = 900,
  [int]$Notches = -5,
  [string]$ProcessName = "msedge",
  [string]$TitlePattern = "",
  [string]$OutPath = "",
  [int]$DelayMs = 700
)

& "$PSScriptRoot\focus_window.ps1" -ProcessName $ProcessName -TitlePattern $TitlePattern | Out-Null

Add-Type @'
using System;
using System.Runtime.InteropServices;
public class CodexMouseWheel {
  [DllImport("user32.dll")] public static extern bool SetCursorPos(int X, int Y);
  [DllImport("user32.dll")] public static extern void mouse_event(uint flags, uint dx, uint dy, int data, UIntPtr extra);
}
'@

[CodexMouseWheel]::SetCursorPos($X, $Y) | Out-Null
Start-Sleep -Milliseconds 80
$delta = 120 * $Notches
[CodexMouseWheel]::mouse_event(0x0800, 0, 0, $delta, [UIntPtr]::Zero)

if ($OutPath) {
  & "$PSScriptRoot\capture_screen.ps1" -OutPath $OutPath -DelayMs $DelayMs
}
