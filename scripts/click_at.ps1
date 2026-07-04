param(
  [Parameter(Mandatory = $true)][int]$X,
  [Parameter(Mandatory = $true)][int]$Y,
  [string]$ProcessName = "msedge",
  [string]$TitlePattern = "",
  [string]$OutPath = "",
  [int]$DelayMs = 700
)

& "$PSScriptRoot\focus_window.ps1" -ProcessName $ProcessName -TitlePattern $TitlePattern | Out-Null

Add-Type @'
using System;
using System.Runtime.InteropServices;
public class CodexMouseClick {
  [DllImport("user32.dll")] public static extern bool SetCursorPos(int X, int Y);
  [DllImport("user32.dll")] public static extern void mouse_event(uint flags, uint dx, uint dy, uint data, UIntPtr extra);
}
'@

[CodexMouseClick]::SetCursorPos($X, $Y) | Out-Null
Start-Sleep -Milliseconds 80
[CodexMouseClick]::mouse_event(0x0002, 0, 0, 0, [UIntPtr]::Zero)
[CodexMouseClick]::mouse_event(0x0004, 0, 0, 0, [UIntPtr]::Zero)

if ($OutPath) {
  & "$PSScriptRoot\capture_screen.ps1" -OutPath $OutPath -DelayMs $DelayMs
}
