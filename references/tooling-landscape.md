# Tooling Landscape

Use this reference when deciding whether to automate through DOM, accessibility tree, UI Automation, image matching, or raw coordinates.

## Decision Matrix

| Target | Prefer | Use When | Avoid When |
| --- | --- | --- | --- |
| Public website data | HTTP/API fetch | Links, metadata, JSON APIs, public profiles | Login/session or JS-rendered private state is required |
| Inspectable browser page | Playwright/Browser MCP/DOM | Locators, roles, labels, screenshots, console logs | The user's normal logged-in Edge session is required and not attached |
| AI browser automation CLI | Accessibility tree refs | A CLI can expose element refs, snapshots, waits, and screenshots | It would use a separate browser profile and lose needed login state |
| Windows desktop app | UI Automation / pywinauto | Controls expose names, roles, values, and invoke patterns | Custom canvas/video UIs expose no meaningful controls |
| Image-only UI | Screenshot/image matching | Buttons/icons are visually stable and no structured API exists | Theme, scale, animation, or resolution changes frequently |
| Last resort | Coordinates | Target is visible, stable, low-risk, and verified by screenshot | State-changing or sensitive actions without a verification screenshot |

## Patterns Worth Copying

- Accessibility snapshots are better than raw coordinates because they create stable element references.
- Locator/actionability checks are better than immediate clicks because they wait for visibility, enabled state, and stable target state.
- Image matching helps when there is no accessible tree, but it is sensitive to DPI, zoom, theme, and animation.
- A useful UI skill keeps screenshots as evidence, not as the only state source.
- Safe web account work should separate public API inventory from authenticated UI actions.
- Read-only web exploration should prefer a new tab or public fetch/API so it does not overwrite the user's active work page.

## Useful Public References

- Browser Use: AI browser agent with browser/computer action space and recovery loops: https://github.com/browser-use/browser-use
- agent-browser: browser automation CLI with snapshots, refs, waits, screenshots, and batch commands: https://github.com/vercel-labs/agent-browser
- Playwright locators: https://playwright.dev/docs/locators
- Microsoft UI Automation overview: https://learn.microsoft.com/en-us/windows/win32/winauto/entry-uiauto-win32
- pywinauto: Windows GUI automation with Win32 and UI Automation backends: https://pywinauto.readthedocs.io/en/latest/
- PyAutoGUI screenshot/image location: https://pyautogui.readthedocs.io/en/latest/screenshot.html
- SikuliX visual workflows: https://sikulix-2014.readthedocs.io/en/latest/basicinfo.html
- GitHub REST repositories API: https://docs.github.com/en/rest/repos

## Local Helper Policy

Add a helper script when the same fragile shell block is used more than twice, especially for:

- Focusing windows.
- Capturing screenshots.
- Navigating Edge by URL.
- Pasting exact text.
- Dumping UI Automation controls.
- Querying public account/profile APIs.

Keep helpers single-purpose, non-destructive by default, and easy to run with absolute paths.
