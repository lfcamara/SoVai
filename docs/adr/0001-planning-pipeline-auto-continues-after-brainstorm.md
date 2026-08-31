# Planning pipeline auto-continues after brainstorm, no named entry skill

The Planning block has no dedicated "entry" skill invoked by name to kick off idea capture. Instead, an ordinary `grilling`-style brainstorm session recognizes a new idea/feature/project and runs; once it reaches shared understanding (no more open questions), doc generation (PRD, then spec) follows automatically as the natural next step of the same session, not a separate manual invocation. Breaking into tickets (`to-tickets`) is likewise the natural consequence of finishing a spec, not a separately-named step.

Considered requiring the user to explicitly invoke each stage by name (matching mattpocock/skills' convention, where `to-spec`/`to-tickets`/`wayfinder` are all `disable-model-invocation: true`). Rejected: the user wants the whole idea → brainstorm → PRD → spec → tickets flow to read as one continuous conversation, not a sequence of slash commands.

## Entry is routed by the hook, and a new effort never edits an old PRD

**Status: accepted, 2026-08-31.** Extends the decision above, which settled how the pipeline *continues* but never said how it is *entered*.

The gap showed up as a real failure mode: every request landed at the top. `brainstorm` chained unconditionally into `to-prd`, so a copy change and a new product got the same five documents, and the only escape was a single sentence telling the agent to notice the work was already shaped and "name the next step" — where the next step in the chain was `to-prd` regardless. A pipeline that cannot be entered in the middle is a pipeline people stop entering.

There are three entrances, sized by the work: an idea whose boundaries are still open goes to `brainstorm`; a feature already shaped goes to `to-prd`, skipping the interview and not the documents; a change that fits in one ticket goes to `to-tickets`, or straight to `implement` where a ticket exists.

**The routing rule lives in the SessionStart hook, not in a new skill.** A router only works if it fires before everything else, and skill invocation is semantic rather than ordered — a routing skill's description would have to be broad enough to match any incoming request, competing with every other description in the plugin for the same trigger. One that fires most of the time is worse than none, because the misses are unrouted *and* the always-loaded description has already been paid for. The hook fires in every session by construction, which is the same reason ADR-0012 put the invocation contract there. `brainstorm` keeps a short version as a backstop for when it is entered directly.

**A new effort gets a new directory, always.** The second question this exposed was what happens when a feature arrives at a project that already has efforts on disk: new PRD, or edit the existing one. New, and `to-prd` now says so. A PRD is a dated argument for one piece of work — the problem, the scope, the explicit no's — and editing it to also cover work decided months later destroys the record of both, in the one document whose value is that it recorded what was believed at the time. Efforts link to the efforts they build on. What genuinely outlives an effort has homes built for revision: `CONTEXT.md` for the vocabulary, `docs/adr/` for the decisions.

