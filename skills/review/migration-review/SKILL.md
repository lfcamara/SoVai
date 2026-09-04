---
name: migration-review
description: The migration axis of `review` — a schema or data migration's reversibility, destructive operations, deploy-time safety, and backfill correctness. Use when `review` dispatches this axis.
---

# Migration Review

Migrations differ from the rest of a diff in one way that changes how they must be reviewed: they run once, against real data, and a mistake doesn't roll back cleanly the way a bad deploy does. `code-review` covers how the migration code is written; this axis covers what happens the moment it runs against production data — the failure mode here is data loss, not a bug ticket.

## Reversibility

Check for a down migration and read it, not just confirm it exists. A down path that doesn't actually undo the up — drops a column the up added but can't restore data the up transformed — is worse than none, because it looks safe.

Where a migration genuinely can't be reversed — a destructive transform, a dropped column with no source to reconstruct it from — that has to be a decision the author made and stated, not a gap discovered when someone needs to roll back. Look for that statement in the migration or its description; its absence on an irreversible migration is itself a finding.

## Destructive operations

Flag any of these and check whether the diff has a reason on record for doing it now rather than behind an expand-contract sequence:

- Dropping or renaming a column or table.
- Narrowing a type (varchar length, int size, nullable to non-null) that existing rows might not satisfy.
- Adding a constraint (unique, foreign key, check, not-null) that existing rows can violate.

For a constraint addition specifically, check whether the migration validates existing data against it before or during the change — a constraint added to a table with violating rows either fails the migration or, worse, succeeds by silently truncating.

## Expand–contract sequencing

Anything that would break code still running against the old schema mid-deploy needs the sequence: add the new form beside the old, ship the code that reads and writes both (or the new one), let every reader and writer move over, and only then remove the old form in a later migration. A migration that renames a column in one step, in a codebase deployed gradually across multiple instances, breaks every instance still running the old code the moment it runs.

Check the deploy ordering explicitly: does the migration need to run before the code that depends on it, after, or does it not matter — and does the diff's deploy sequence actually match what the migration requires. A migration that adds a column the new code reads must run first; one that drops a column the old code still writes must run last, after every instance is on the new code.

## Behavior on large tables

Check what the migration does to the table while it runs: does it take a lock that blocks reads or writes, and for how long relative to the table's size. A migration that's instant on a development database with a thousand rows can hold a lock for the deployment window's full duration on a production table with a hundred million. Look for online/concurrent variants the database offers (e.g. building an index without blocking writes) and check whether the diff uses them where they exist. If the migration can't complete inside the deployment window, that's a finding regardless of correctness.

## Backfills

A backfill needs three properties, and the diff should be checked against all three:

- **Idempotent** — running it twice, or resuming after a partial failure, doesn't corrupt data or double-apply the change.
- **Resumable** — a backfill over a large table that fails partway through can pick up from where it stopped rather than starting over or requiring manual cleanup.
- **Correct for concurrent writes** — rows created or modified while the backfill is running end up correct, not skipped because they didn't exist when the backfill's query was planned, and not overwritten by the backfill after the application already wrote the correct value.

## Tested against realistic data

Check whether the migration was actually run against a copy of production-shaped data — realistic row counts, realistic null patterns, realistic duplicate or malformed values — rather than only an empty local database. An empty database can't surface a lock that takes too long, a constraint that existing rows violate, or a backfill that times out. Ask for evidence of this rather than assuming it happened; a migration diff with no mention of how it was tested is a gap, not a pass.

## Entered directly

Dispatched by `review`, this axis inherits a pinned fixed point, the severity ladder it assigns against, and a record `wrap-up` reads before it merges. Reached on its own it has none of those, so say that with the findings — and where the work is heading for a merge, run `review` for this axis instead, so what you find lands where the merge gate can see it.

## Severity

Assign each finding a severity per `review`'s ladder. On this axis, critical is a migration that can silently destroy or corrupt data already in production — an irreversible drop with no reconstruction path, a backfill that isn't idempotent or safe against concurrent writes. High is one that breaks the deploy itself without touching data permanently — a lock that outlasts the deployment window, or a sequencing gap that breaks code still running against the old schema.
