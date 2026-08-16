/**
 * Standalone banner generator for the garage repo (not part of the shared
 * unraid-apps wrapper-banner generator, since this is its own repo).
 * Same technique as the house style: text rendered at local origin, then
 * positioned via <g transform> to avoid opentype.js NaN at large absolute X.
 * Run: node .github/assets/gen-banner.mjs
 */
import { readFileSync, writeFileSync, existsSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";
import { tmpdir } from "node:os";
import { createRequire } from "node:module";
import { execSync } from "node:child_process";

const require = createRequire(import.meta.url);
const groot = execSync("npm root -g").toString().trim();
const opentype = require(`${groot}/opentype.js`);
const { Resvg } = require(`${groot}/@resvg/resvg-js`);
const HERE = dirname(fileURLToPath(import.meta.url));

async function font(file, url) {
  const p = join(tmpdir(), file);
  if (!existsSync(p)) { const r = await fetch(url); if (!r.ok) throw new Error(`${file} ${r.status}`); writeFileSync(p, Buffer.from(await r.arrayBuffer())); }
  const b = readFileSync(p);
  return opentype.parse(b.buffer.slice(b.byteOffset, b.byteOffset + b.byteLength));
}
const lato = await font("jdp-Lato-Regular.ttf", "https://github.com/google/fonts/raw/main/ofl/lato/Lato-Regular.ttf");
const bbox = (svg) => new Resvg(svg, { fitTo: { mode: "original" } }).getBBox();

// The official Garage logo (garagehq.deuxfleurs.fr) is a mark+wordmark lockup
// (crate icon above the "Garage" wordmark, both baked into icon.svg's paths) —
// so unlike the other repos' banners, no separate headline text is drawn here.
// Only the claim runs alongside it.
const W = 1600, H = 500, LOGO_INK = 380, LOGO_X = 220, GAP_LOGO_TEXT = 90, CLAIM_CAP = 44, RIGHT_PAD = 120;
const CLAIM = "Object storage with its own garage door opener.";

const iconSrc = readFileSync(join(HERE, "icon.svg"), "utf8");
const iconInner = iconSrc.replace(/^[\s\S]*?<svg[^>]*>/, "").replace(/<\/svg>\s*$/, "");
const iconVb = { x: 0, y: 0, w: 512, h: 512 };

const mb = bbox(`<svg xmlns="http://www.w3.org/2000/svg" viewBox="${iconVb.x} ${iconVb.y} ${iconVb.w} ${iconVb.h}">${iconInner}</svg>`);
const sM = LOGO_INK / Math.max(mb.width, mb.height);
const markW = mb.width * sM, markH = mb.height * sM;
const markTX = LOGO_X - mb.x * sM, markTY = H / 2 - markH / 2 - mb.y * sM;
const textX = LOGO_X + markW + GAP_LOGO_TEXT;
const maxClaimW = W - textX - RIGHT_PAD;

function fitClaim(text, maxW, cap) {
  let size = Math.min(cap, Math.floor((100 * maxW) / lato.getAdvanceWidth(text, 100)));
  for (; size > 10; size--) if (!lato.getPath(text, 0, 0, size).toPathData(2).includes("NaN")) return size;
  return 10;
}
const claimSize = fitClaim(CLAIM, maxClaimW, CLAIM_CAP);
const claimAsc = lato.ascender * (claimSize / lato.unitsPerEm), claimDesc = -lato.descender * (claimSize / lato.unitsPerEm);
const claimBaseline = Math.round(H / 2 + (claimAsc - claimDesc) / 2);
const claimD = lato.getPath(CLAIM, 0, 0, claimSize).toPathData(2);

const THEMES = [
  { suf: "", bg: "#ffffff", name: "#1f2328", claim: "#5a5d5e" },
  { suf: "-dark", bg: "#0d1117", name: "#e6edf3", claim: "#9aa4ad" },
];
for (const t of THEMES) {
  const svg = `<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${W} ${H}" width="${W}" height="${H}" role="img" aria-label="garage">
  <rect width="${W}" height="${H}" fill="${t.bg}"/>
  <g transform="translate(${markTX.toFixed(2)},${markTY.toFixed(2)}) scale(${sM.toFixed(5)})">${iconInner}</g>
  <g transform="translate(${textX.toFixed(2)},${claimBaseline})"><path d="${claimD}" fill="${t.claim}"/></g>
</svg>
`;
  writeFileSync(join(HERE, `banner${t.suf}.svg`), svg);
  writeFileSync(join(HERE, `banner${t.suf}.png`), new Resvg(svg, { background: t.bg, fitTo: { mode: "original" } }).render().asPng());
}
console.log("banner + banner-dark written");
