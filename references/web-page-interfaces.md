# Web Page Interfaces

Use this reference when the target is a website, local frontend app, Edge tab, ChatGPT page, HTML document, or browser-rendered UI.

## Priority Order

1. **Codex in-app Browser plugin**: best for DOM inspection, interaction, screenshots, local frontend testing, and pages where a controlled browser session is enough.
2. **Terminal HTTP/HTML capture**: best for public static pages, APIs, raw HTML, downloads, and repeatable scraping without login.
3. **Debuggable Edge instance**: useful when a Chromium page must be inspected through CDP and a separate browser profile is acceptable.
4. **Visible user Edge screenshot control**: use when the user's existing login/session is required and no DOM interface is attached.

Do not default to screenshot clicks for websites. Use screenshots for visual confirmation, not as the primary extraction method, unless the live logged-in Edge window is the only available surface.

## Account And Profile Pages

For tasks like "what projects do I have", "what competitions did I join", or "what submissions exist":

1. Check whether an official CLI, official API, or public profile page can answer the question.
2. Use the visible logged-in browser only for private or authenticated information that the API cannot access.
3. Distinguish viewed, bookmarked, hosted, and participated records; do not treat sidebars or recommendations as participation history.
4. When a public API shows fewer items than the authenticated UI, report that the API result is public-only.
5. Save a screenshot of the final profile/account page when the answer depends on visible authenticated state.

## In-App Browser Capabilities

When the browser plugin is available, read its own skill first and bootstrap the browser through the Node REPL. After bootstrap, use:

- `browser.tabs.new()`, `tabs.selected()`, `tab.goto(url)`, `tab.reload()`, `tab.url()`, `tab.title()`.
- `tab.playwright.domSnapshot()` for locator ground truth and visible DOM structure.
- `tab.playwright.evaluate(fn)` for bounded read-only DOM extraction.
- `tab.playwright.getByRole/getByText/getByLabel/locator` for interactions, after confirming uniqueness with `count()`.
- `tab.screenshot({ fullPage: true })` for visual QA.
- `tab.dev.logs(...)` for console messages.
- `tab.capabilities.get("pageAssets")` when assets from the current page are needed.
- `tab.clipboard.writeText(...)` when browser-session clipboard is safer than OS clipboard.

Rules:

- Use a fresh DOM snapshot after navigation before building locators.
- Do not dump entire body text or large app state as exploratory search.
- Use one bounded `evaluate` to collect a compact set of links, headings, forms, or metadata.
- Confirm locator uniqueness before clicking or filling.
- Prefer targeted checks over repeated screenshots.

## Terminal Fetch And HTML Capture

Use terminal requests for public, non-authenticated pages and APIs:

```powershell
$url = "https://example.com"
$html = (Invoke-WebRequest -Uri $url -UseBasicParsing).Content
$html | Set-Content -Encoding UTF8 "page.html"
```

Node 24 has built-in `fetch` in this workspace:

```powershell
@'
const url = "https://example.com";
const res = await fetch(url, { headers: { "user-agent": "Mozilla/5.0" } });
console.log(res.status, res.headers.get("content-type"));
console.log((await res.text()).slice(0, 2000));
'@ | node -
```

Use this path for:

- saving raw HTML,
- checking HTTP status and redirects,
- retrieving JSON APIs,
- downloading public assets,
- extracting links, titles, metadata, and static content.

On Windows, prefer the bundled PowerShell helper when `node` is not on PATH:

```powershell
$SkillRoot = Split-Path -Parent $PSScriptRoot
$OutDir = Join-Path $env:TEMP "operate-ui-summaries"
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

& "$SkillRoot\scripts\fetch_page_summary.ps1" `
  -Url "https://example.com" `
  -OutDir $OutDir
```

Limitations:

- It will not see client-rendered DOM after JavaScript runs.
- It will not reuse the user's visible Edge login cookies unless explicitly exported by the user.
- It must not bypass paywalls, authentication, or anti-bot controls.

## Debuggable Edge Instance

Current user Edge often runs without `--remote-debugging-port`, so existing tabs cannot be inspected through CDP. If structured DOM access is needed and a separate browser profile is acceptable, launch an isolated Edge:

```powershell
$profile = "$env:TEMP\codex-edge-profile"
Start-Process msedge.exe "--remote-debugging-port=9222 --user-data-dir=`"$profile`" about:blank"
```

Then inspect:

```powershell
Invoke-RestMethod http://127.0.0.1:9222/json/version
Invoke-RestMethod http://127.0.0.1:9222/json
```

Notes:

- This creates a separate Edge session and usually will not share the user's normal login state.
- Ask before closing windows or killing Edge processes.
- Use this for inspectable public or test pages, not for accounts that rely on the user's main browser session.

## Visible Edge With Existing Login

Use screenshot control when:

- The user is already logged in in normal Edge.
- The task is low-risk: ask a question, click a visible button, export a visible file, capture a process screenshot.
- DOM/CDP is unavailable.

Recommended loop:

1. Start/focus Edge with the target URL.
2. Reset zoom with `Ctrl+0` when coordinates/layout matter.
3. Capture full screen.
4. If the page is visually unhealthy, press `Esc`, refresh or re-navigate, then capture again.
5. Click the field/control only after visible confirmation.
6. Paste text through clipboard.
7. Send/submit only if the user authorized that exact action.
8. Capture a final screenshot and summarize what happened.

Stop for login prompts, CAPTCHA, account settings, uploads of personal files, payments, sharing, deletes, or permission prompts.

When the user explicitly authorizes login:

- Click ordinary sign-in buttons only if credentials are already filled by the browser or an existing session.
- Do not type or reveal passwords, 2FA codes, recovery codes, passkeys, or CAPTCHA answers.
- Stop at OAuth scope or permission grants unless the requested task clearly requires that exact authorization.

## State-Changing Web Actions

Before clicking a final create, publish, or send button:

- Capture the form state with owner/account, target name, and relevant settings visible.
- Verify private/public visibility labels literally match the request.
- For GitHub-like creation flows, ensure the final button is enabled and no validation error appears near the name field.
- Capture the result page showing the created resource and its key state label.

## Frontend Testing Pattern

For local apps:

1. Start the dev server.
2. Use in-app Browser or Playwright-style DOM access for functional checks.
3. Use screenshots for layout checks at desktop and mobile widths.
4. Inspect console logs and network-visible failures when available.
5. Prefer DOM state for correctness and screenshots for visual quality.

When the app is static HTML, `file://` or a local HTTP server may be enough. For frameworks that require routing or assets, use a dev server.
