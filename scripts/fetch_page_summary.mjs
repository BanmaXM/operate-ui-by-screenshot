import { writeFile } from "node:fs/promises";
import { basename, join } from "node:path";

const url = process.argv[2];
const outDir = process.argv[3] || ".";
if (!url) {
  console.error("Usage: node fetch_page_summary.mjs <url> [outDir]");
  process.exit(2);
}

const res = await fetch(url, {
  headers: {
    "user-agent": "Mozilla/5.0 (compatible; CodexPageSummary/1.0)",
  },
});
const text = await res.text();
const title = (text.match(/<title[^>]*>([\s\S]*?)<\/title>/i)?.[1] || "")
  .replace(/\s+/g, " ")
  .trim();
const links = [...text.matchAll(/<a\b[^>]*href=["']([^"']+)["'][^>]*>([\s\S]*?)<\/a>/gi)]
  .slice(0, 50)
  .map((m) => ({
    href: m[1],
    text: m[2].replace(/<[^>]*>/g, " ").replace(/\s+/g, " ").trim().slice(0, 120),
  }));

const safeName = basename(new URL(url).hostname).replace(/[^a-z0-9.-]+/gi, "_") || "page";
const htmlPath = join(outDir, `${safeName}.html`);
const jsonPath = join(outDir, `${safeName}.summary.json`);
await writeFile(htmlPath, text, "utf8");
await writeFile(jsonPath, JSON.stringify({
  url,
  finalUrl: res.url,
  status: res.status,
  contentType: res.headers.get("content-type"),
  title,
  links,
}, null, 2), "utf8");
console.log(JSON.stringify({ htmlPath, jsonPath, status: res.status, title }, null, 2));
