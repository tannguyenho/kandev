---
name: Unrelated Git histories
description: Safe synchronization when a local snapshot and GitHub main have no common ancestor
---

When local and remote histories have no common ancestor, preserve both roots with a named backup and an explicit merge commit using non-force update semantics. Treat the upstream tree as the base and resolve only the genuinely shared files; never reset one side over the other without confirmation.

**Why:** A local Replit workspace can be a deployment/integration snapshot while GitHub main is the upstream product repository. Rebase, reset, or force-push can silently discard one repository's files and history.

**How to apply:** Fetch first, compare roots and file overlap, create a recovery ref before editing, merge with unrelated histories only after choosing the target branch, verify both parents and zero ahead/behind, then use a normal push or an authenticated Git provider API with `force: false`. Keep credential setup separate from repository contents.