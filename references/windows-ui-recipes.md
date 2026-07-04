# Windows UI Recipes

Use these recipes for visible Windows UI tasks when no richer automation channel is available.

## Capture A Screenshot

```powershell
$SkillRoot = Split-Path -Parent $PSScriptRoot
$OutDir = Join-Path $env:TEMP "operate-ui-screens"
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

& "$SkillRoot\scripts\capture_screen.ps1" `
  -OutPath (Join-Path $OutDir "state-01.png") `
  -DelayMs 500
```

If running outside the skill directory, call scripts by absolute path.

## Focus A Window

Prefer the bundled script:

```powershell
$SkillRoot = Split-Path -Parent $PSScriptRoot
& "$SkillRoot\scripts\focus_window.ps1" `
  -ProcessName msedge
```

Inline fallback:

```powershell
$p = Get-Process msedge | Where-Object { $_.MainWindowHandle -ne 0 } | Select-Object -First 1
Add-Type @'
using System;
using System.Runtime.InteropServices;
public class Win32Focus {
  [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);
}
'@
[Win32Focus]::SetForegroundWindow($p.MainWindowHandle) | Out-Null
```

Use the exact process name when possible: `msedge`, `WINWORD`, `Photoshop`, `Adobe Premiere Pro`, etc.

## Click A Visible Coordinate

Only click after a screenshot confirms the target.

```powershell
$SkillRoot = Split-Path -Parent $PSScriptRoot
$OutDir = Join-Path $env:TEMP "operate-ui-screens"
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

& "$SkillRoot\scripts\click_at.ps1" `
  -X 850 -Y 527 `
  -OutPath (Join-Path $OutDir "after-click.png")
```

## Paste Text And Submit

Use paste for long text, Chinese text, paths, prompts, and multiline content. Verify with a screenshot before submitting if the action is high-impact.

```powershell
$SkillRoot = Split-Path -Parent $PSScriptRoot
$OutDir = Join-Path $env:TEMP "operate-ui-screens"
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

& "$SkillRoot\scripts\paste_text.ps1" `
  -Text "你是谁？" `
  -SelectAll `
  -OutPath (Join-Path $OutDir "after-paste.png")
```

Submit after verification:

```powershell
$SkillRoot = Split-Path -Parent $PSScriptRoot
$OutDir = Join-Path $env:TEMP "operate-ui-screens"
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

& "$SkillRoot\scripts\paste_text.ps1" `
  -Text "你是谁？" `
  -Submit `
  -OutPath (Join-Path $OutDir "after-submit.png")
```

## Send Keys Or Scroll

Use helper scripts for repeated keyboard and wheel actions:

```powershell
$SkillRoot = Split-Path -Parent $PSScriptRoot
$OutDir = Join-Path $env:TEMP "operate-ui-screens"
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

& "$SkillRoot\scripts\send_keys.ps1" -Keys "^0"
& "$SkillRoot\scripts\send_keys.ps1" -Keys "{ESC}"
& "$SkillRoot\scripts\scroll_window.ps1" `
  -Notches -8 `
  -OutPath (Join-Path $OutDir "bottom.png")
```

`SendKeys` strings use Windows Forms syntax such as `^l`, `^v`, `{ENTER}`, `{ESC}`, and `{END}`.

## Open Edge Without Losing The Current Page

Use `-NewTab` for read-only exploration that should not overwrite the user's current tab:

```powershell
$SkillRoot = Split-Path -Parent $PSScriptRoot
$OutDir = Join-Path $env:TEMP "operate-ui-screens"
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

& "$SkillRoot\scripts\open_edge_url.ps1" `
  -Url "https://github.com/vercel-labs/agent-browser" `
  -NewTab `
  -ResetZoom `
  -OutPath (Join-Path $OutDir "github-agent-browser.png")
```

## File Dialog Pattern

1. Trigger the file dialog from the UI.
2. Copy the absolute path to the clipboard.
3. Paste it into the filename box with `Ctrl+V`.
4. Press `Enter`.
5. Verify the selected/imported file appears in the app.

Prefer absolute paths. For Chinese paths, PowerShell-native copy/paste is usually safer than passing the path through Python or another shell.

## Recover A Bad Page State

When a screenshot shows accidental full-page text selection, shifted controls, stale dropdowns, wrong zoom, or a click that repeatedly misses:

1. Press `{ESC}` once.
2. Reset zoom with `^0`.
3. Refresh or navigate directly to the target URL if layout is still suspect.
4. Capture a new screenshot before clicking again.
5. Switch from coordinates to keyboard tab order or UI Automation when repeated clicks miss.

## Verification Checklist

- The intended app is foregrounded.
- The URL, title, or app name matches the target.
- The clicked button changed state as expected.
- Text appears exactly once in the intended field.
- A new file, export, conversation, timeline, or dialog state is visible.
- Any modal, warning, or login screen is treated as a checkpoint.
- For account/project creation, the owner, name, visibility, and final action button are visible and match the user's request.
