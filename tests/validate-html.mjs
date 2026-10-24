import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { spawnSync } from 'node:child_process';

const file = process.argv[2] || 'app/ARKA-v28b-renja-workspace-implementation.html';
const html = fs.readFileSync(file, 'utf8');
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
if (process.exitCode) process.exit(process.exitCode);
console.log('All static checks passed. This does not test Supabase connectivity/RLS or write persistence.');
