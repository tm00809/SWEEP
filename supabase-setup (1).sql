-- ============================================================
-- 赛季阵容编辑器 · Supabase 云端档案 建表脚本
-- 使用方法：
--   1. 登录 https://supabase.com → New Project（免费版即可）
--   2. 左侧 SQL Editor → New query → 粘贴本文件全部内容 → Run
--   3. Project Settings → API 页面拿到：
--        Project URL      → 填入 app.js 的 SUPABASE_CONFIG.url
--        anon public key  → 填入 app.js 的 SUPABASE_CONFIG.anonKey
-- ============================================================

-- 用户表：代号 + 访问码（首次登录自动注册）
create table if not exists users (
  user_code  text primary key,
  pin        text not null,
  created_at timestamptz default now()
);

-- 档案表：每个用户可存多套阵容（按赛季区分）
create table if not exists plans (
  id         bigint generated always as identity primary key,
  user_code  text not null,
  season     int  not null,
  name       text not null,
  data       jsonb not null,
  created_at timestamptz default now()
);

-- 开启行级安全（RLS）
alter table users enable row level security;
alter table plans enable row level security;

-- 匿名访问策略（anon key 是公开的，靠代号+访问码做轻量身份校验）
create policy "users anon access" on users
  for all using (true) with check (true);
create policy "plans anon access" on plans
  for all using (true) with check (true);

-- 常用索引
create index if not exists plans_user_season_idx on plans (user_code, season);
