# Microsoft Edge + ChatGPT

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
