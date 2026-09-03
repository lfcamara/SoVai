# Work lands on a phase branch, through one worktree per ticket

A phase gets a branch of its own, cut from `main` when `to-tickets` publishes that phase's tickets and named `phase/<effort>-<NN>`. Every ticket branches from that phase branch, not from `main`, and is worked in its own git worktree at `<project root>/worktrees/<TICKET-ID>-<slug>`. A ticket's PR targets the phase branch; the phase branch targets `main` and merges once, when the phase closes.

## The phase is what ships, so the phase is what merges

ADR-0003 makes the phase the unit of shipped value, and the cancellation test asks whether a user is better off if everything after it is cancelled. A phase that reaches `main` one ticket at a time never answers that question at a point where anyone could act on it: `main` holds two thirds of a capability, and the only way back out is a sequence of reverts nobody planned.

With a phase branch, `main` takes one merge per phase, the phase is revertable as a unit, and the exit criteria `wrap-up` already verifies at phase close now have a pull request to sit on rather than a state of `main` that is true by the time anyone checks. That merge is its own approval under ADR-0008: approving the tickets said nothing about shipping the phase.

The cost is real and was accepted deliberately. `main` is no longer releasable per ticket, so a project deploying on every merge cannot use this shape. And a phase branch ages: it integrates `main` whenever `main` moves, and each ticket branch rebases on the phase branch before its PR, or the phase's final merge becomes the conflict that every ticket avoided.

## Worktrees are what make the frontier real

`to-tickets` ends on a **frontier** — the tickets whose blockers have all closed — and says they can run in parallel. In a single working tree they cannot: two implementers share one checkout and one HEAD, so the second one's first commit lands on the first one's branch. The parallelism the process promises has been unexecutable, and a worktree per ticket is what makes the promise true rather than aspirational.

One worktree per ticket also keeps a blocked implementer's half-finished tree out of everybody else's way — the work stays exactly where it stopped, on disk, while other tickets keep moving.

## Inside the project root, ignored

The path is derivable from the project root alone, which is what a cold subagent has: the brief names `<project root>/worktrees/<branch>` and nothing has to be resolved from the orchestrator's session. That is the whole argument for placing them inside the root rather than beside it.

The price is that everything which walks the project now walks N copies of it. `worktrees/` goes in the project's `.gitignore`, which settles git and every search tool that honours it — without that line, each worktree is a wall of untracked files and every code search returns the same hit once per tree. Tools that glob on their own terms need the same exclusion in their own config: TypeScript's `include`, test runners, Tailwind's content globs, a Docker build context.

## A worktree is a bare checkout, so the project says how to start it

Git materializes tracked files and nothing else, so a new worktree has no `.env` and no `node_modules` — it is not runnable at the moment it is created, and an implementer dispatched into one would fail on a missing dependency and report a broken project. This is true of any worktree location; it is not a consequence of putting them under the root.

The fix cannot live in this plugin. ADR-0013's argument applies unchanged: only the project knows what makes it runnable, so the project declares it, as a list of commands under `worktreeSetup` in its own `sovai.config.json`. `delegate` runs them after creating the worktree and before dispatching into it. A project that declares nothing gets a bare checkout, which is correct for a project that needs nothing.

## Removal belongs to the merge, and never forces

The worktree is removed when its PR merges, by the orchestrator in `wrap-up`, after the merge is confirmed — the same ordering ADR-0008 makes load-bearing for the tracker, and for the same reason: a worktree removed ahead of a merge that then fails has thrown away the only copy of the work.

Removal never forces. A worktree with uncommitted changes or unpushed commits holds something the merge did not carry, and that is a fact to report, not a directory to delete. The implementer cannot do this for itself in any case: it is standing inside the tree that would be removed.
