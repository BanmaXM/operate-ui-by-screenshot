# Kaggle

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
