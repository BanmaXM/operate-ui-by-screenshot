import { mkdir, writeFile } from "node:fs/promises";
import { join } from "node:path";

const mode = process.argv[2];
const value = process.argv[3];
const outDir = process.argv[4] || ".";

if (!mode || !value || !["user", "search"].includes(mode)) {
  console.error("Usage: node github_public_summary.mjs <user|search> <value> [outDir]");
  process.exit(2);
}

const headers = {
  "accept": "application/vnd.github+json",
  "user-agent": "CodexPublicGitHubSummary/1.0",
};

async function getJson(url) {
  const res = await fetch(url, { headers });
  const text = await res.text();
  let body;
  try {
    body = text ? JSON.parse(text) : null;
  } catch {
    body = { raw: text };
  }
  if (!res.ok) {
    throw new Error(`${res.status} ${res.statusText}: ${JSON.stringify(body).slice(0, 500)}`);
  }
  return body;
}

await mkdir(outDir, { recursive: true });

if (mode === "user") {
  const username = value;
  const user = await getJson(`https://api.github.com/users/${encodeURIComponent(username)}`);
  const repos = await getJson(`https://api.github.com/users/${encodeURIComponent(username)}/repos?per_page=100&sort=updated`);
  const summary = {
    source: "public GitHub API",
    note: "Unauthenticated public API does not list private repositories.",
    user: {
      login: user.login,
      name: user.name,
      html_url: user.html_url,
      public_repos: user.public_repos,
      followers: user.followers,
      following: user.following,
      created_at: user.created_at,
      updated_at: user.updated_at,
    },
    repos: repos.map((repo) => ({
      name: repo.name,
      full_name: repo.full_name,
      visibility: repo.visibility,
      html_url: repo.html_url,
      description: repo.description,
      language: repo.language,
      stars: repo.stargazers_count,
      forks: repo.forks_count,
      updated_at: repo.updated_at,
      pushed_at: repo.pushed_at,
    })),
  };
  const outPath = join(outDir, `github-${user.login}-public-summary.json`);
  await writeFile(outPath, JSON.stringify(summary, null, 2), "utf8");
  console.log(JSON.stringify({ outPath, login: user.login, publicRepos: summary.repos.length }, null, 2));
}

if (mode === "search") {
  const query = value;
  const result = await getJson(`https://api.github.com/search/repositories?q=${encodeURIComponent(query)}&per_page=10&sort=stars&order=desc`);
  const summary = {
    source: "public GitHub search API",
    query,
    total_count: result.total_count,
    items: result.items.map((repo) => ({
      full_name: repo.full_name,
      html_url: repo.html_url,
      description: repo.description,
      language: repo.language,
      stars: repo.stargazers_count,
      forks: repo.forks_count,
      updated_at: repo.updated_at,
    })),
  };
  const safeName = query.replace(/[^a-z0-9._-]+/gi, "_").slice(0, 80) || "query";
  const outPath = join(outDir, `github-search-${safeName}.json`);
  await writeFile(outPath, JSON.stringify(summary, null, 2), "utf8");
  console.log(JSON.stringify({ outPath, totalCount: result.total_count, returned: summary.items.length }, null, 2));
}
