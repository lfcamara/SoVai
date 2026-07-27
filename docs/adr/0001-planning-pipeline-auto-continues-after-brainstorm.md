# Planning pipeline auto-continues after brainstorm, no named entry skill

The Planning block has no dedicated "entry" skill invoked by name to kick off idea capture. Instead, an ordinary `grilling`-style brainstorm session recognizes a new idea/feature/project and runs; once it reaches shared understanding (no more open questions), doc generation (PRD, then spec) follows automatically as the natural next step of the same session, not a separate manual invocation. Breaking into tickets (`to-tickets`) is likewise the natural consequence of finishing a spec, not a separately-named step.

Considered requiring the user to explicitly invoke each stage by name (matching mattpocock/skills' convention, where `to-spec`/`to-tickets`/`wayfinder` are all `disable-model-invocation: true`). Rejected: the user wants the whole idea → brainstorm → PRD → spec → tickets flow to read as one continuous conversation, not a sequence of slash commands.
