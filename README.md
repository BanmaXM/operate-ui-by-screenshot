# operate-ui-by-screenshot

Codex skill for cautious operation of desktop apps and websites. It is not only a screenshot-clicking helper: it is a reusable operating layer for GUI/web agents that can combine structured browser interfaces, DOM/HTML inspection, UI Automation, screenshots, visible state checks, clipboard paste, safe clicks, and verification screenshots.

中文说明见下方：[中文说明](#中文说明)。

## English

### What It Does

This repository is a Codex skill folder. The required skill entry point is [`SKILL.md`](SKILL.md).

The skill helps an agent operate apps and websites through a cautious, evidence-driven loop:

- Prefer APIs, CLIs, browser DOM inspection, HTML fetch, Playwright-style locators, CDP, or UI Automation before coordinate clicking.
- Use screenshot-based UI control only when no richer interface is available.
- Confirm visible state before clicking coordinates.
- Prefer clipboard paste for long prompts, paths, Chinese text, mixed-language content, and multiline values.
- Capture verification screenshots after clicks, paste actions, navigation, scrolling, exports, and other meaningful actions.
- Stop at sensitive checkpoints such as passwords, 2FA, CAPTCHA, payment, destructive actions, account/security changes, and ambiguous permission prompts.
- Reuse known app/site profiles, and summarize durable lessons after exploring a new app or website.

If a multimodal agent can inspect visual state and use basic UI tools, this skill can be extended to more websites and desktop software by adding small operation notes in `references/software-profiles.md`.

### Why It Matters

Many GUI-agent failures come from stale page state, shifted controls, hidden modals, wrong zoom, ambiguous focus, login traps, virtualized lists, unsafe final buttons, or missing post-action verification. This skill makes those operational details explicit so future GUI/web agents can act with a repeatable safety loop.

### Included Resources

```text
operate-ui-by-screenshot/
  SKILL.md
  agents/
    openai.yaml
  references/
    maintenance.md
    software-profiles.md
    tooling-landscape.md
    web-page-interfaces.md
    windows-ui-recipes.md
  scripts/
    capture_screen.ps1
    click_at.ps1
    dump_uia_tree.ps1
    fetch_page_summary.mjs
    fetch_page_summary.ps1
    focus_window.ps1
    github_public_summary.mjs
    github_public_summary.ps1
    list_windows.ps1
    open_edge_url.ps1
    paste_text.ps1
    scroll_window.ps1
    send_keys.ps1
```

### Reusable App/Site Lessons

`references/software-profiles.md` stores short profiles for known apps and websites, including Edge/ChatGPT, GitHub, Kaggle, Luogu, and Adobe Premiere Pro.

When the agent explores a new app or website, it can summarize durable operation lessons:

- launch URL or app start method;
- stable landmarks and visible state labels;
- best interface choice: API, CLI, HTML fetch, DOM, Playwright, CDP, UIA, or screenshot;
- common safe actions;
- verification screenshots and what each should show;
- app/site-specific stop conditions;
- recovery rules for overlays, scroll traps, disabled buttons, wrong zoom, stale state, or ambiguous modals.

Do not store secrets, cookies, tokens, passwords, private user data, private screenshots, or one-off coordinates.

### Installation

Clone this repository into your Codex skills directory:

```powershell
git clone https://github.com/BanmaXM/operate-ui-by-screenshot.git `
  "$env:USERPROFILE\.codex\skills\operate-ui-by-screenshot"
```

If your Codex home is different, place the folder under:

```text
<CODEX_HOME>/skills/operate-ui-by-screenshot
```

Restart Codex or reload skills after installation.

### Example Trigger

```text
Use $operate-ui-by-screenshot to open a website in Edge, inspect the page, click the visible export button, and save verification screenshots.
```

### Helper Script Examples

Capture a screenshot:

```powershell
$SkillRoot = "$env:USERPROFILE\.codex\skills\operate-ui-by-screenshot"
$OutDir = Join-Path $env:TEMP "operate-ui-screens"
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

& "$SkillRoot\scripts\capture_screen.ps1" `
  -OutPath (Join-Path $OutDir "state-01.png") `
  -DelayMs 500
```

Open Edge and capture the visible result:

```powershell
$SkillRoot = "$env:USERPROFILE\.codex\skills\operate-ui-by-screenshot"
$OutDir = Join-Path $env:TEMP "operate-ui-screens"
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

& "$SkillRoot\scripts\open_edge_url.ps1" `
  -Url "https://github.com/BanmaXM/operate-ui-by-screenshot" `
  -NewTab `
  -ResetZoom `
  -OutPath (Join-Path $OutDir "repo.png")
```

### Safety Model

The skill is designed around a cautious loop:

1. Inspect visible state.
2. Prefer structured interfaces over raw clicking.
3. Click coordinates only after screenshot confirmation.
4. Paste rather than type when text fidelity matters.
5. Verify after each meaningful action.
6. Stop at credentials, CAPTCHA, payments, destructive actions, account/security changes, and ambiguous permission decisions.

### Validation

Validate the skill frontmatter with the Codex skill-creator validator if available:

```powershell
python "$env:USERPROFILE\.codex\skills\.system\skill-creator\scripts\quick_validate.py" `
  "$env:USERPROFILE\.codex\skills\operate-ui-by-screenshot"
```

You can also run a harmless helper check:

```powershell
$SkillRoot = "$env:USERPROFILE\.codex\skills\operate-ui-by-screenshot"
& "$SkillRoot\scripts\list_windows.ps1"
```

## 中文说明

这是一个用于 Codex 的 UI 操作 skill，目标是让 agent 在操作桌面软件和网页时更加谨慎、可验证、可追溯。它不是单纯的“截图点按钮”工具，而是一个面向 GUI/Web agent 的可复用操作层：优先使用 API、CLI、浏览器 DOM、HTML 抓取、Playwright locator、CDP、UI Automation 等结构化接口；只有在没有更可靠接口时，才退回到截图驱动的可见 UI 操作。

只要多模态 agent 能观察屏幕状态并调用基本 UI 工具，这个 skill 的流程就可以迁移到更多网站和桌面软件。新的经验不需要写成庞大的文档，只要沉淀到 `references/software-profiles.md` 里，记录稳定入口、页面标志、安全动作、验证截图和停止条件即可。

### 它解决什么问题

GUI 操作类任务常见风险包括：

- 页面状态没看清就点击；
- 坐标点击偏移；
- 模态框、下拉框、加载状态遮挡目标；
- 文本输入出错，尤其是中文、路径、长 prompt 和多行内容；
- 操作后没有验证；
- 登录、2FA、支付、删除、发布等高风险动作被误触发。

这个 skill 把 UI 操作拆成一个谨慎循环：

1. 先观察当前可见状态；
2. 优先寻找结构化接口；
3. 必须点击坐标时，先用截图确认目标；
4. 输入文本时优先使用剪贴板粘贴；
5. 每个关键动作后截图验证；
6. 遇到密码、2FA、CAPTCHA、支付、删除、账号安全、权限授权等场景立即停止。

### 新网站/软件经验沉淀

当一个新网站或软件的工作流被探索清楚后，可以在 `references/software-profiles.md` 里增加一个简短 profile。建议记录：

- 启动方式或入口 URL；
- 稳定页面标志和关键控件；
- 最优接口选择：API、CLI、HTML fetch、DOM、Playwright、CDP、UIA 或截图；
- 常见安全动作；
- 验证截图应该显示什么；
- 特定停止条件；
- 遮罩层、滚动陷阱、按钮禁用、页面状态过期、焦点错误时的恢复规则。

不要记录密码、token、cookie、个人隐私数据、私密截图或一次性坐标。

### 适用场景

适合用于：

- 控制 Edge、ChatGPT、GitHub、Kaggle、Luogu 等网页；
- 操作桌面软件的按钮、菜单、文件对话框和导出流程；
- 需要保留过程截图的 UI 工作流；
- 没有 API 或 DOM 接口时的低风险可见 UI 操作；
- 前端页面测试中的截图验证、布局检查和控制台/DOM 辅助排查；
- 探索新网站/软件后，总结可复用的操作经验，逐步扩展 profile。

不适合用于：

- 自动输入密码、2FA、恢复码、API key；
- 绕过 CAPTCHA、登录验证、付费墙或权限控制；
- 未经确认点击购买、删除、发布、发送真实邮件、账号修改等不可逆操作；
- 只依赖坐标、不做截图验证的高风险自动化。

### 安装方式

把仓库克隆到 Codex skills 目录：

```powershell
git clone https://github.com/BanmaXM/operate-ui-by-screenshot.git `
  "$env:USERPROFILE\.codex\skills\operate-ui-by-screenshot"
```

如果你的 Codex 目录不是默认路径，可以放到：

```text
<CODEX_HOME>/skills/operate-ui-by-screenshot
```

安装后重启 Codex 或重新加载 skills。

### 触发示例

```text
Use $operate-ui-by-screenshot to operate this app or website with structured interfaces first, then safe screenshot-based UI actions when needed.
```

中文也可以这样说：

```text
使用 $operate-ui-by-screenshot 打开这个网页，优先用 DOM/API 检查页面；如果必须点 UI，请先截图确认，再点击并保存验证截图。
```

### 目录说明

- `SKILL.md`：skill 的核心触发描述和操作规则。
- `agents/openai.yaml`：Codex UI 中展示 skill 的元数据。
- `references/windows-ui-recipes.md`：Windows 截图、聚焦窗口、点击、粘贴、滚动等操作模板。
- `references/web-page-interfaces.md`：网页、Edge、DOM、HTML fetch、CDP 和可见浏览器操作策略。
- `references/software-profiles.md`：常见软件/网站 profile，以及新增 profile 的格式。
- `references/tooling-landscape.md`：DOM、UIA、截图、坐标点击等工具选择建议。
- `references/maintenance.md`：如何维护和扩展这个 skill。
- `scripts/`：可复用的 PowerShell / Node 辅助脚本。

### 开源说明

这个项目适合作为 GUI agent / UI automation / tool-use agent 的一个工程化示例：它强调的不是“让 agent 能点按钮”，而是让 agent 在真实 UI 中遵循可观察、可验证、可停止、可积累经验的操作协议。

## License

MIT License. See [`LICENSE`](LICENSE).
