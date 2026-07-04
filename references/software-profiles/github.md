# GitHub

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
