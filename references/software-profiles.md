# Software Profiles

Add one profile per app or website. Keep each profile short and operational: launch, stable landmarks, interface strategy, common actions, verification screenshots, and risk checkpoints.

## New App/Site Lesson Capture

When an unfamiliar app/site workflow becomes repeatable, add a short profile below using the same format. Preserve only stable landmarks, the best interface choice, common safe actions, verification expectations, stop conditions, and reusable recovery rules.

Do not preserve secrets, cookies, tokens, passwords, private user data, screenshots with private content, or one-off coordinates.

## Profile Format

```markdown
## App Or Site Name

- Launch:
- Stable landmarks:
- Interface strategy:
- Common actions:
- Preferred input method:
- Verification screenshots:
- Stop conditions:
- Reusable lessons:
- Notes:
```

## Microsoft Edge + ChatGPT

- Launch: `Start-Process msedge.exe 'https://chatgpt.com'`.
- Stable landmarks: address bar shows `chatgpt.com`; left sidebar has ChatGPT navigation; center page has prompt box; logged-in user avatar may appear in the sidebar.
- Interface strategy:
  - Prefer Codex in-app Browser for inspectable pages, frontend testing, DOM snapshots, HTML/asset capture, and pages that do not need the user's normal Edge login.
  - Prefer terminal `fetch` for public raw HTML, metadata, links, JSON APIs, and downloads.
  - Use visible Edge screenshot control when the user's existing logged-in ChatGPT session is needed.
  - Use an isolated remote-debugging Edge only when CDP/DOM access is needed and a separate profile is acceptable.
- Common actions:
  - New chat: click visible new chat item or use the blank home prompt.
  - Ask a short question: click the prompt field, paste text, press `Enter`.
  - Verify response: screenshot should show the user message bubble and assistant response text.
- Preferred input method: clipboard paste, especially for Chinese prompts and long prompts.
- Verification screenshots:
  - `edge_chatgpt_attempt_screen1.png`: page loaded and prompt box visible.
  - `edge_chatgpt_attempt_screen2.png`: user message and response visible.
- Stop conditions: login prompt, CAPTCHA, subscription/payment prompt, account/security settings, export/delete/share decisions unless explicitly requested.
- Reusable lessons: model and reasoning controls can move; capture the menu open state before choosing, then capture the composer after selection.
- Notes: Current normal Edge may not expose a remote debugging port. Do not assume existing tabs can be scraped through CDP. Use screenshots for logged-in visible Edge, and use in-app Browser or a separate debug Edge for structured page inspection.

## GitHub

- Launch: `Start-Process msedge.exe 'https://github.com'`; for new repositories, use `https://github.com/new`.
- Stable landmarks: GitHub header, owner selector, repository name field, visibility control, final create button, repository title with visibility badge.
- Interface strategy:
  - Use `gh` or the official GitHub API for public profile/repository inventory when available.
  - Use visible Edge for actions requiring the user's logged-in session.
- Common actions:
  - Inspect public repositories: `https://api.github.com/users/<user>/repos?per_page=100&sort=updated`.
  - Summarize public repositories/search: use `scripts/github_public_summary.ps1` on Windows, or the `.mjs` equivalent when Node is available.
  - Create private repository: fill owner, name, description, choose `Private`, screenshot, scroll to create button, click, then screenshot the created repo page.
- Preferred input method: clipboard paste for names/descriptions; reset zoom before coordinate work.
- Verification screenshots:
  - Form filled with owner/name/visibility.
  - `Private` selected before creation.
  - Result page shows `<owner>/<repo>` and `Private` badge.
- Stop conditions: 2FA, passkey prompts, OAuth permission grants not clearly requested, organization policy prompts, billing prompts, destructive settings.
- Reusable lessons: public API does not list private repositories without authentication; do not infer that a private repo is missing just because a public API returns `[]`.
- Notes: Check owner/name/visibility in the same screenshot before pressing the final create button.

## Kaggle

- Launch: `Start-Process msedge.exe 'https://www.kaggle.com'`.
- Stable landmarks: signed-in avatar/name, profile page, competitions/progression tabs, counts for solo/team/hosted competitions.
- Interface strategy:
  - Use public profile pages or visible Edge logged-in pages; Kaggle pages are heavily client-rendered, so screenshots may be more reliable than raw HTML.
- Common actions:
  - Open profile from avatar menu.
  - Inspect competitions page or profile progression page.
  - Distinguish viewed/recent sidebar items from actual participation counts.
- Preferred input method: direct URL paste and screenshot verification.
- Verification screenshots:
  - Profile page with username.
  - Competitions/progression page showing solo/team/hosted counts.
- Stop conditions: login prompt requiring credentials, CAPTCHA, account settings, API token creation/download, dataset upload/publish.
- Reusable lessons: viewed competition cards are not participation evidence.
- Notes: Use visible count labels rather than inferred card lists when possible.

## Luogu

- Launch: `Start-Process msedge.exe 'https://www.luogu.com.cn'`.
- Stable landmarks: left navigation, top search/login area, problem pages, record/submission pages.
- Interface strategy:
  - Use public problem pages for statements.
  - Use visible Edge only for private submission/code history, which requires login.
- Common actions:
  - Search by problem title or problem id.
  - Open problem records/submissions only after confirming login state.
- Preferred input method: direct URL/search paste.
- Verification screenshots:
  - Login state or login requirement.
  - Problem page or submission/code page if accessible.
- Stop conditions: username/password entry, GitHub/OAuth login requiring credentials, CAPTCHA, code submission, profile/security settings.
- Reusable lessons: if the page shows `登录 / 注册`, private code history is unavailable until the user completes login.
- Notes: Never submit code without explicit confirmation.

## Adobe Premiere Pro

- Launch: Start menu shortcut or direct `.lnk`/app launch. Wait longer than for browser workflows.
- Stable landmarks: project window, import/media panel, timeline panel, export settings dialog, sequence name.
- Interface strategy: for precise rendering, subtitles, trimming, normalization, or batch generation, prefer FFmpeg or scripts, then use Premiere for integration, inspection, and evidence screenshots.
- Common actions:
  - Create/open project.
  - Import a media file through file dialog or drag/drop equivalent.
  - Create a sequence by placing media on the timeline.
  - Capture screenshots for project created, media imported, timeline, and export settings.
- Preferred input method: paste absolute file paths into file dialogs when possible; use script-generated media and Premiere mainly for workflow evidence when precise edit automation is unnecessary.
- Verification screenshots:
  - Project created.
  - Media imported into project panel.
  - Timeline contains video/audio tracks.
  - Export settings show H.264, intended resolution, frame rate, and output path.
- Stop conditions: missing media prompts, overwrite prompts, online sign-in/licensing prompts, destructive project changes, or export settings that do not match required deliverables.
- Reusable lessons: Premiere launch and dialogs can be slow; wait for stable panels before clicking coordinates.
- Notes: Record output path and export settings in the verification screenshot.
