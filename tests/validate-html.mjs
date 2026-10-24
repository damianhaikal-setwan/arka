import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawnSync } from 'node:child_process';

const repoRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const file = process.argv[2] ? path.resolve(process.cwd(), process.argv[2]) : path.join(repoRoot, 'index.html');
const html = fs.readFileSync(file, 'utf8');
const migrationPath = path.join(repoRoot, 'supabase/migrations/20261024151600_renja_workspace_guardrails.sql');
const migration = fs.readFileSync(migrationPath, 'utf8');
const assert = (condition, message) => { if (!condition) { console.error(`FAIL: ${message}`); process.exitCode = 1; } else console.log(`PASS: ${message}`); };

const scripts = [...html.matchAll(/<script\b[^>]*>([\s\S]*?)<\/script\s*>/gi)].map(m => m[1]).filter(s => s.trim());
assert(scripts.length > 0, 'HTML contains inline JavaScript');
for (let i=0; i<scripts.length; i++) {
  const temp = path.join(os.tmpdir(), `arka-renja-check-${process.pid}-${i}.js`);
  fs.writeFileSync(temp, scripts[i]);
  const res = spawnSync('node', ['--check', temp], { encoding:'utf8' });
  fs.rmSync(temp, { force:true });
  assert(res.status === 0, `inline script ${i+1} syntax${res.status === 0 ? '' : `: ${res.stderr}`}`);
}
assert(html.includes('Workspace Renja'), 'workspace renderer present');
for (const label of ['Identitas Renja','Program','Kegiatan','Subkegiatan','Rekap & T-C.33']) assert(html.includes(label), `workspace label present: ${label}`);
assert(!/src=["']arka-icon\.svg["']/i.test(html) && !/href=["']arka-icon\.svg["']/i.test(html), 'no external arka-icon.svg reference');
assert(html.includes('function arkaToRow') && html.includes('function arkaFromRow'), 'Supabase row mapping hooks present');
assert(html.includes('function renjaValidation') && html.includes('function renjaOutputRows'), 'validation and T-C.33 derivation present');
assert(/function printRenjaTC33\(\)[\s\S]{0,900}renjaValidation\(d\)[\s\S]{0,500}blockers/.test(html), 'T-C.33 printing checks hierarchy and budget validation');
assert(html.includes('function renjaOrphans(t){const validDocs=new Set'), 'stale Renja references are exposed as orphans');
assert(migration.includes("'Draft', 'Berjalan', 'Selesai', 'Terlambat'"), 'Program/Kegiatan status constraints support Draft');
for (const constraint of ['program_renja_ref_fkey','kegiatan_renja_ref_fkey','subkegiatan_renja_ref_fkey']) assert(migration.includes(constraint), `server-side Renja foreign key present: ${constraint}`);
assert((migration.match(/ON DELETE RESTRICT NOT VALID/g) || []).length === 3, 'Renja foreign keys restrict deletion without validating historical rows upfront');
if (process.exitCode) process.exit(process.exitCode);
console.log('All static checks passed. This does not execute SQL or test Supabase connectivity/RLS, browser behavior, or cross-user concurrency.');
