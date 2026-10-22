// Supabase Edge Function: ARKA user administration.
// Deploy with secrets SUPABASE_URL, SUPABASE_ANON_KEY, SUPABASE_SERVICE_ROLE_KEY.
import { createClient } from "npm:@supabase/supabase-js@2";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL") || "";
function readKey(legacyName: string, collectionName: string): string {
  const legacy = Deno.env.get(legacyName);
  if (legacy) return legacy;
  const raw = Deno.env.get(collectionName);
  if (!raw) return "";
  try {
    const keys = JSON.parse(raw) as Record<string, string>;
    return keys.default || Object.values(keys)[0] || "";
  } catch {
    return "";
  }
}
// Support legacy project variables and current named key collections.
const SUPABASE_ANON_KEY = readKey("SUPABASE_ANON_KEY", "SUPABASE_PUBLISHABLE_KEYS");
const SUPABASE_SERVICE_ROLE_KEY = readKey("SUPABASE_SERVICE_ROLE_KEY", "SUPABASE_SECRET_KEYS");
const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Content-Type": "application/json; charset=utf-8",
};
const ROLES = new Set(["admin", "pengelola", "pimpinan"]);
const UNITS = new Set(["umum_keuangan", "persidangan", "fasilitasi"]);
const json = (body: unknown, status = 200) => new Response(JSON.stringify(body), { status, headers: corsHeaders });

async function findAuthUserByEmail(adminClient: ReturnType<typeof createClient>, email: string) {
  const target = email.trim().toLowerCase();
  const perPage = 100;
  for (let page = 1; page <= 100; page++) {
    const { data, error } = await adminClient.auth.admin.listUsers({ page, perPage });
    if (error) throw error;
    const users = data.users || [];
    const found = users.find((u) => String(u.email || "").trim().toLowerCase() === target);
    if (found) return found;
    if (users.length < perPage) return null;
  }
  throw new Error("Pemeriksaan email berhenti karena jumlah akun melebihi batas pencarian. Periksa akun di Supabase Authentication.");
}

function validateProfile(input: Record<string, unknown>) {
  const email = String(input.email ?? "").trim().toLowerCase();
  const nama = String(input.nama ?? "").trim();
  const peran = String(input.peran ?? "");
  const unitRaw = input.unit == null || input.unit === "" ? null : String(input.unit);
  if (!email || email.length > 254 || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) throw new Error("Format email tidak valid.");
  if (!nama || nama.length > 160) throw new Error("Nama wajib diisi (maksimal 160 karakter).");
  if (!ROLES.has(peran)) throw new Error("Peran tidak valid.");
  if (peran === "pengelola" && (!unitRaw || !UNITS.has(unitRaw))) throw new Error("Pengelola wajib memiliki unit kerja yang valid.");
  if (peran !== "pengelola" && unitRaw !== null) throw new Error("Unit kerja hanya diisi untuk peran Pengelola.");
  return { email, nama, peran, unit: peran === "pengelola" ? unitRaw : null };
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });
  if (req.method !== "POST") return json({ error: "Gunakan metode POST." }, 405);

  const authorization = req.headers.get("Authorization");
  if (!authorization?.startsWith("Bearer ")) return json({ error: "Sesi login diperlukan." }, 401);
  if (!SUPABASE_URL || !SUPABASE_ANON_KEY || !SUPABASE_SERVICE_ROLE_KEY) {
    return json({ error: "Konfigurasi secret Edge Function belum lengkap." }, 500);
  }

  const callerClient = createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
    global: { headers: { Authorization: authorization } },
    auth: { persistSession: false, autoRefreshToken: false },
  });
  const adminClient = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  try {
    const { data: authData, error: authError } = await callerClient.auth.getUser();
    const caller = authData?.user;
    if (authError || !caller) return json({ error: "Sesi login tidak valid atau sudah kedaluwarsa." }, 401);

    const { data: callerProfile, error: profileError } = await adminClient
      .from("profiles").select("peran,nama,unit").eq("id", caller.id).maybeSingle();
    if (profileError) throw profileError;
    if (callerProfile?.peran !== "admin") return json({ error: "Hanya admin ARKA yang dapat mengelola pengguna." }, 403);

    let body: Record<string, unknown>;
    try { body = await req.json(); } catch { return json({ error: "Isi permintaan tidak valid." }, 400); }
    const action = String(body.action ?? "");
    const actorLabel = caller.email || caller.id;

    const audit = async (aksi: string, ref: string) => {
      const { error } = await adminClient.from("audit_log").insert({
        aksi, modul: "pengguna", ref, user_name: actorLabel,
      });
      if (error) console.error("Audit pengguna gagal dicatat:", error.message);
    };

    if (action === "list") {
      const authUsers = [] as Array<{id:string; email?:string; created_at?:string; last_sign_in_at?:string|null; email_confirmed_at?:string|null}>;
      const perPage = 100;
      for (let page = 1; page <= 100; page++) {
        const { data, error } = await adminClient.auth.admin.listUsers({ page, perPage });
        if (error) throw error;
        const batch = data.users || [];
        authUsers.push(...batch.map((u) => ({ id: u.id, email: u.email, created_at: u.created_at,
          last_sign_in_at: u.last_sign_in_at, email_confirmed_at: u.email_confirmed_at })));
        if (batch.length < perPage) break;
      }
      const { data: profiles, error } = await adminClient.from("profiles").select("id,nama,peran,unit");
      if (error) throw error;
      const byId = new Map((profiles || []).map((p) => [p.id, p]));
      const users = authUsers.map((u) => ({ ...u, ...(byId.get(u.id) || { nama: null, peran: null, unit: null }) }))
        .sort((a,b) => String(a.email || "").localeCompare(String(b.email || "")));
      return json({ users });
    }

    if (action === "create") {
      const profile = validateProfile(body);
      // This installation uses dummy/test emails, so do not send an invitation.
      // Auth creates the user with a confirmed email and an admin-supplied initial password.
      const password = String(body.password ?? "");
      if (password.length < 8 || password.length > 128) {
        return json({ code: "PASSWORD_INVALID", error: "Password awal wajib 8–128 karakter." }, 400);
      }
      const existingAuthUser = await findAuthUserByEmail(adminClient, profile.email);
      if (existingAuthUser) {
        const { data: existingProfile, error: existingProfileError } = await adminClient
          .from("profiles").select("id,nama,peran,unit").eq("id", existingAuthUser.id).maybeSingle();
        if (existingProfileError) throw existingProfileError;
        return json({
          code: "EMAIL_ALREADY_EXISTS",
          existingUserId: existingAuthUser.id,
          error: `Email ${profile.email} sudah terdaftar di Supabase Authentication. Gunakan Edit pada akun yang sudah ada${existingProfile ? "." : "; akun ini belum memiliki profil akses."}`,
        }, 409);
      }

      const { data, error } = await adminClient.auth.admin.createUser({
        email: profile.email,
        password,
        email_confirm: true,
        user_metadata: { full_name: profile.nama, arka_managed: true },
      });
      if (error) {
        const message = String(error.message || "Supabase Auth gagal membuat akun.");
        const lower = message.toLowerCase();
        if (/already registered|already exists|user already|email.*exists|duplicate/i.test(message)) {
          return json({ code: "EMAIL_ALREADY_EXISTS", error: `Email ${profile.email} sudah terdaftar. Gunakan Edit pada akun yang sudah ada.` }, 409);
        }
        if (/email.*invalid|invalid.*email|email_address_invalid/i.test(message + " " + String(error.code || ""))) {
          return json({
            code: "EMAIL_INVALID",
            error: `Supabase Auth menolak alamat email ${profile.email}. Email konfirmasi memang tidak dikirim, tetapi Auth tetap memerlukan alamat berformat valid. Periksa alamat atau aturan validasi email pada proyek Supabase. Detail: ${message}`,
          }, 400);
        }
        if (/password.*(weak|short|length|characters)|weak password/i.test(lower)) {
          return json({ code: "PASSWORD_INVALID", error: `Password awal ditolak oleh Supabase Auth. Gunakan password yang memenuhi kebijakan proyek. Detail: ${message}` }, 400);
        }
        const status = Number(error.status) >= 400 && Number(error.status) <= 599 ? Number(error.status) : 400;
        return json({ code: error.code || "AUTH_CREATE_FAILED", error: `Supabase Auth gagal membuat akun tanpa email konfirmasi: ${message}` }, status);
      }
      const newUser = data.user;
      if (!newUser?.id) throw new Error("Supabase tidak mengembalikan ID akun baru.");
      const { error: insertError } = await adminClient.from("profiles").upsert({
        id: newUser.id, nama: profile.nama, peran: profile.peran, unit: profile.unit,
      });
      if (insertError) {
        const { error: rollbackError } = await adminClient.auth.admin.deleteUser(newUser.id);
        if (rollbackError) console.error("Rollback akun gagal:", rollbackError.message);
        throw new Error("Akun Authentication dibuat, tetapi profil gagal disimpan: " + insertError.message);
      }
      await audit("TAMBAH", `${profile.email} (${profile.peran}; tanpa email konfirmasi)`);
      return json({
        ok: true,
        user: { id: newUser.id, email: profile.email, ...profile, email_confirmed_at: newUser.email_confirmed_at },
        message: "Akun dibuat dengan email terkonfirmasi. Tidak ada email yang dikirim.",
      }, 201);
    }

    if (action === "update") {
      const id = String(body.id ?? "");
      if (!/^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(id)) return json({ error: "ID pengguna tidak valid." }, 400);
      const profile = validateProfile(body);
      const { data: existingUserData, error: existingUserError } = await adminClient.auth.admin.getUserById(id);
      if (existingUserError || !existingUserData?.user) return json({ error: "Akun pengguna tidak ditemukan." }, 404);
      const { data: oldProfile, error: oldProfileError } = await adminClient.from("profiles").select("id,nama,peran,unit").eq("id", id).maybeSingle();
      if (oldProfileError) throw oldProfileError;
      if (oldProfile?.peran === "admin" && profile.peran !== "admin") {
        const { count, error } = await adminClient.from("profiles").select("id", { count: "exact", head: true }).eq("peran", "admin");
        if (error) throw error;
        if ((count ?? 0) <= 1) return json({ error: "Tidak dapat mengubah peran admin terakhir. Tetapkan admin pengganti terlebih dahulu." }, 409);
      }
      const oldEmail = existingUserData.user.email || "";
      if (profile.email !== oldEmail || !existingUserData.user.email_confirmed_at) {
        const authUpdate: { email?: string; email_confirm: boolean } = { email_confirm: true };
        if (profile.email !== oldEmail) authUpdate.email = profile.email;
        const { error } = await adminClient.auth.admin.updateUserById(id, authUpdate);
        if (error) throw error;
      }
      const { error: saveError } = await adminClient.from("profiles").upsert({
        id, nama: profile.nama, peran: profile.peran, unit: profile.unit,
      });
      if (saveError) {
        if (profile.email !== oldEmail) {
          const { error: rollbackError } = await adminClient.auth.admin.updateUserById(id, { email: oldEmail, email_confirm: true });
          if (rollbackError) console.error("Rollback email gagal:", rollbackError.message);
        }
        throw saveError;
      }
      await audit("UBAH", `${oldEmail} → ${profile.email} (${profile.peran})`);
      return json({ ok: true, user: { id, ...profile } });
    }

    if (action === "delete") {
      const id = String(body.id ?? "");
      if (!/^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(id)) return json({ error: "ID pengguna tidak valid." }, 400);
      if (id === caller.id) return json({ error: "Akun yang sedang digunakan tidak dapat dihapus. Gunakan akun admin lain." }, 409);
      const { data: targetData, error: targetError } = await adminClient.auth.admin.getUserById(id);
      if (targetError || !targetData?.user) return json({ error: "Akun pengguna tidak ditemukan." }, 404);
      const targetEmail = targetData.user.email || id;
      const { data: targetProfile, error: targetProfileError } = await adminClient.from("profiles").select("peran").eq("id", id).maybeSingle();
      if (targetProfileError) throw targetProfileError;
      if (targetProfile?.peran === "admin") {
        const { count, error } = await adminClient.from("profiles").select("id", { count: "exact", head: true }).eq("peran", "admin");
        if (error) throw error;
        if ((count ?? 0) <= 1) return json({ error: "Tidak dapat menghapus admin terakhir. Tetapkan admin pengganti terlebih dahulu." }, 409);
      }
      const { error } = await adminClient.auth.admin.deleteUser(id);
      if (error) throw error;
      await audit("HAPUS", targetEmail);
      return json({ ok: true, id });
    }

    return json({ error: "Aksi tidak dikenal. Gunakan list, create, update, atau delete." }, 400);
  } catch (error) {
    console.error("arka-users-admin error:", error);
    const e = error as { message?: string; status?: number; code?: string };
    const message = error instanceof Error ? error.message : String(e?.message || "Kesalahan server tidak diketahui.");
    const lower = message.toLowerCase();
    const duplicate = /already registered|already exists|user already|email.*exists|duplicate key/i.test(message);
    const invalidEmail = /email.*invalid|invalid.*email|email_address_invalid/i.test(message + " " + String(e?.code || ""));
    const weakPassword = /password.*(weak|short|length|characters)|weak password/i.test(lower);
    const rateLimit = /rate limit|too many requests/i.test(lower);
    const status = duplicate ? 409 : (invalidEmail || weakPassword ? 400 : (rateLimit ? 429 : (Number(e?.status) >= 400 && Number(e?.status) <= 599 ? Number(e.status) : 400)));
    const code = duplicate ? "EMAIL_ALREADY_EXISTS" : (invalidEmail ? "EMAIL_INVALID" : (weakPassword ? "PASSWORD_INVALID" : (rateLimit ? "AUTH_RATE_LIMIT" : (e?.code || "ARKA_REQUEST_FAILED"))));
    const userMessage = duplicate
      ? "Email sudah terdaftar di Supabase Authentication. Gunakan Edit pada akun yang sudah ada."
      : invalidEmail
        ? `Supabase Auth menolak format/alamat email. Tidak ada email konfirmasi yang dikirim, tetapi alamat tetap harus memenuhi validasi Auth. Detail: ${message}`
        : weakPassword
          ? `Password awal ditolak. Gunakan password sesuai kebijakan proyek. Detail: ${message}`
          : rateLimit
            ? `Permintaan dibatasi oleh Supabase. Tunggu sebelum mencoba lagi. Detail: ${message}`
            : message;
    return json({ error: userMessage, code }, status);
  }

});
