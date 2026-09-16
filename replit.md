# Kandev on Replit

Official upstream Kandev runtime configured for a single Replit Webview process.

## Run & Operate

- `pnpm --filter @workspace/api-server run dev` — run the API server (port 5000)
- `pnpm start` — run the official Kandev v0.94.0 npm runtime on `0.0.0.0:$PORT`
- `pnpm run typecheck` — full typecheck across all packages
- `pnpm run build` — typecheck + build all packages
- `pnpm --filter @workspace/api-spec run codegen` — regenerate API hooks and Zod schemas from the OpenAPI spec
- `pnpm --filter @workspace/db run push` — push DB schema changes (dev only)
- Required env: `DATABASE_URL` — Postgres connection string
- Kandev stores its SQLite database, task data, repositories, sessions, and worktrees under `.kandev-home/.kandev/`. This directory is persistent in the project filesystem and intentionally ignored by Git.

## Stack

- pnpm workspaces, Node.js 24, TypeScript 5.9
- API: Express 5
- DB: PostgreSQL + Drizzle ORM
- Validation: Zod (`zod/v4`), `drizzle-zod`
- API codegen: Orval (from OpenAPI spec)
- Build: esbuild (CJS bundle)

## Where things live

_Populate as you build — short repo map plus pointers to the source-of-truth file for DB schema, API contracts, theme files, etc._

## Architecture decisions

_Populate as you build — non-obvious choices a reader couldn't infer from the code (3-5 bullets)._

## Product

- Official Kandev web UI, backend API, WebSocket gateway, Kanban workflows, Git worktrees, review/merge flows, and supported coding-agent adapters.

## User preferences

_Populate as you build — explicit user instructions worth remembering across sessions._

## Gotchas

- Keep Kandev as the foreground process. Do not wrap the start command with `nohup`, background it, or replace the upstream UI.
- The Replit entrypoint pins the tested official npm runtime version. Upgrade deliberately after reviewing upstream release notes.

## Pointers

- See the `pnpm-workspace` skill for workspace structure, TypeScript setup, and package details
