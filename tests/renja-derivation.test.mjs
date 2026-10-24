import fs from 'node:fs';
import vm from 'node:vm';
import assert from 'node:assert/strict';

const html = fs.readFileSync(new URL('../index.html', import.meta.url), 'utf8');
const start = html.indexOf('function renjaText(v)');
const end = html.indexOf('function renjaParentName(', start);
assert.ok(start >= 0 && end > start, 'Renja derivation helpers are present in the app source');

const tables = {
  renja: [{ id: 'RJ-2026', tahun: 2026, pagu: 999 }, { id: 'RJ-2027', tahun: 2027, pagu: 0 }],
  renstra: [
    { id: 'S-01', jenis: 'Sasaran', kode: 'S-01', indikator: 'IKU A', t2026: '80', t2027: '85' },
    { id: 'S-02', jenis: 'Sasaran', kode: 'S-02', indikator: 'IKU B', t2026: '20', t2027: '25' },
    { id: 'T-01', jenis: 'Tujuan', kode: 'T-01', indikator: 'Tujuan', t2026: '100' }
  ],
  program: [
    { id: 'P-01', renjaRef: 'RJ-2026', tahun: 2026, pagu: 999 },
    { id: 'P-02', renjaRef: 'RJ-2026', tahun: 2026, pagu: 999 },
    { id: 'P-OLD', renjaRef: '', tahun: 2020, pagu: 500 },
    { id: 'P-STALE', renjaRef: 'RENJA-GONE', tahun: 2026, pagu: 20 }
  ],
  kegiatan: [
    { id: 'K-01', renjaRef: 'RJ-2026', program: 'P-01', tahun: 2026, pagu: 999 },
    { id: 'K-02', renjaRef: 'RJ-2026', program: 'P-01', tahun: 2026, pagu: 999 },
    { id: 'K-03', renjaRef: 'RJ-2026', program: 'P-02', tahun: 2026, pagu: 999 }
  ],
  subkegiatan: [
    { id: 'SK-01', renjaRef: 'RJ-2026', kegiatan: 'K-01', tahun: 2026, pagu: 30 },
    { id: 'SK-02', renjaRef: 'RJ-2026', kegiatan: 'K-01', tahun: 2026, pagu: 20 },
    { id: 'SK-03', renjaRef: 'RJ-2026', kegiatan: 'K-02', tahun: 2026, pagu: 25 },
    { id: 'SK-04', renjaRef: 'RJ-2026', kegiatan: 'K-03', tahun: 2026, pagu: 40 },
    { id: 'SK-ORPHAN', renjaRef: 'RENJA-GONE', kegiatan: 'NO-ACTIVITY', tahun: 2026, pagu: 900 }
  ]
};
const context = {
  dbAll: (table) => tables[table] || [],
  hasNumericValue: (v) => v !== null && v !== undefined && String(v).trim() !== '' && Number.isFinite(Number(v)),
  fmt: (v) => String(v),
  console
};
vm.runInNewContext(`${html.slice(start, end)}\nglobalThis.fns={renjaSasaranRenstra,renjaComputedKegiatanPagu,renjaComputedProgramPagu,renjaComputedDocumentPagu,renjaBudgetMismatch,renjaRecomputeCachedBudgets,renjaOrphans};`, context);
const f = context.fns;
const doc = tables.renja[0];

assert.equal(f.renjaSasaranRenstra(doc).length, 2, 'all Sasaran are derived; Tujuan rows are excluded');
assert.equal(f.renjaSasaranRenstra(doc)[0].targetRenja, '80', 'annual target follows Renja year (t2026)');
assert.equal(f.renjaSasaranRenstra(tables.renja[1])[0].targetRenja, '85', 'changing Renja year changes target source to t2027');
assert.equal(f.renjaComputedKegiatanPagu(doc, tables.kegiatan[0]), 50, 'Kegiatan pagu sums its direct Subkegiatan');
assert.equal(f.renjaComputedProgramPagu(doc, tables.program[0]), 75, 'Program pagu sums Kegiatan beneath the same Program');
assert.equal(f.renjaComputedProgramPagu(doc, tables.program[1]), 40, 'second Program total is independent');
assert.equal(f.renjaComputedDocumentPagu(doc), 115, 'Renja pagu sums derived Program totals');
assert.equal(f.renjaBudgetMismatch(999, 115), true, 'stored totals that disagree with child sums are flagged');
assert.equal(f.renjaOrphans('program').length, 2, 'null and stale Renja references are surfaced as orphans');

f.renjaRecomputeCachedBudgets();
assert.equal(tables.kegiatan[0].pagu, 50, 'cache recalculation updates Kegiatan total');
assert.equal(tables.program[0].pagu, 75, 'cache recalculation updates Program total');
assert.equal(tables.renja[0].pagu, 115, 'cache recalculation updates document total');
assert.equal(tables.program[2].pagu, 500, 'unlinked legacy Program keeps its existing budget');
console.log('All Renja derivation unit checks passed.');
