# Luogu

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
- Reusable lessons: if the page shows `login / register`, private code history is unavailable until the user completes login.
- Notes: Never submit code without explicit confirmation.
