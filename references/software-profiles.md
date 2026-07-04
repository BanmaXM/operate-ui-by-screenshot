# Software Profiles Index

Use this index when a task targets a known app or website, or when a new app/site workflow should be captured for reuse.

## How To Use Profiles

1. Identify the target app or website.
2. Load only the matching profile below.
3. If no profile exists, use `software-profiles/new-site-profile-template.md`.
4. After a successful new workflow, summarize reusable lessons and add or update a profile.

## Available Profiles

| Target | Profile |
|---|---|
| Microsoft Edge + ChatGPT | `software-profiles/edge-chatgpt.md` |
| GitHub | `software-profiles/github.md` |
| Kaggle | `software-profiles/kaggle.md` |
| Luogu | `software-profiles/luogu.md` |
| Adobe Premiere Pro | `software-profiles/adobe-premiere-pro.md` |
| New app/site template | `software-profiles/new-site-profile-template.md` |

## Add Or Update A Profile

Each profile should stay short and operational: launch, stable landmarks, interface strategy, common actions, verification screenshots, stop conditions, reusable lessons, and notes.

When a new workflow becomes repeatable:

1. Create a file under `references/software-profiles/` using lowercase hyphenated naming, such as `github.md` or `adobe-premiere-pro.md`.
2. Record durable facts only: stable landmarks, best interface, common safe actions, stop conditions, verification screenshots, and recovery rules.
3. Do not record passwords, cookies, tokens, private user data, personal account identifiers, one-off coordinates, or screenshots that contain private content.
4. If a helper script would prevent repeated fragile code, add it under `scripts/` and test it.
5. Add the profile to the table above.

## Self-Evolution Rule

Treat every new app/site operation as an opportunity to improve the skill:

- If the agent discovered a stable selector, landmark, API endpoint, UIA pattern, or reliable screenshot cue, preserve it in a profile.
- If the agent hit a failure mode such as stale overlays, shifted buttons, login traps, scroll virtualization, disabled buttons, wrong zoom, or ambiguous modals, record the recovery rule.
- If a workflow required three or more repeated shell snippets, consider creating a helper script.
- Keep the main `SKILL.md` generic; store app/site-specific details in profile files.
