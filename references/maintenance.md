# Maintenance

Update this skill when a new UI workflow becomes repeatable.

## Add A New Software Profile

1. Append a short section to `references/software-profiles.md`.
2. Include launch method, stable landmarks, common actions, preferred input method, verification screenshots, stop conditions, and notes.
3. For websites, also record whether the best interface is in-app Browser, terminal fetch, CDP/debug Edge, or visible screenshot control.
4. Keep app-specific facts in the profile, not in `SKILL.md`.
5. If the workflow needs reusable code, add a small script under `scripts/` and test it.

## Capture Lessons From A Session

Record only reusable facts:

- Which controls were reliable landmarks.
- Which structured interface was available: DOM snapshot, HTML fetch, page assets, CDP, or screenshot only.
- Which steps worked better through clipboard paste.
- Which actions required extra screenshots.
- Which prompts or dialogs should stop automation.
- Which parts should be done by scripts or APIs instead of GUI.
- Whether a page-health recovery rule is needed, such as reset zoom, press `Esc`, refresh, or abandon stale coordinates.
- Whether the workflow should add or update a helper script instead of repeating inline shell snippets.
- Whether outside tools/projects suggest a reusable pattern; record durable patterns in `references/tooling-landscape.md`, not in the main `SKILL.md`.

## Do Not Store

- Passwords, cookies, session tokens, account IDs, or private user data.
- One-off coordinates unless tied to a screenshot and clearly marked as example-only.
- Long transcripts or screenshots that are not useful as workflow examples.

## Validate After Changes

After editing this skill:

1. Run the skill creator `quick_validate.py` script against the skill folder.
2. Run at least one representative helper script with a harmless action, such as focusing Edge or capturing a screenshot.
3. Re-read `agents/openai.yaml` when the skill purpose changes; keep display metadata aligned with `SKILL.md`.
