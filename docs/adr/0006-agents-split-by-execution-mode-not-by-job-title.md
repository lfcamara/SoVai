# Agents split by execution mode, not by job title

The plugin ships two custom agents — `implementer` (writes) and `reviewer` (read-only) — rather than a roster of role agents such as frontend developer, backend developer, or devops engineer.

Role labels were considered and rejected. Telling a capable model "you are a backend developer" barely changes its behaviour; what changes outcomes is which files it can see, which tools it holds, which skill it must follow, and what counts as done. A role taxonomy would also sit orthogonal to the existing organization by workflow block, forcing every task through two unrelated classifications with an arbitrary mapping — a React component that calls an API belongs to neither "frontend" nor "backend" cleanly. Human role boundaries exist because people cannot context-switch cheaply and need career specialization; neither constraint applies here.

Role agents become worthwhile when a role implies a distinct standing context pack — a frontend agent that always loads the design system, a devops agent that always carries the deploy runbook. No such pack exists yet, so those agents would be empty labels. They can be added when there is something specific to put in them.

The read-only constraint on `reviewer` is deliberate rather than incidental: a reviewer able to edit fixes what it finds, which destroys the evidence and returns a verdict that cannot be audited. Anthropic's own `feature-dev` plugin takes the same posture, granting none of its three agents write access.

The higher-value half of this decision is the `delegate` skill rather than the agent roster. Subagent failures come from thin briefs, not from missing job titles: an agent that starts cold and cannot ask a question will fill a gap by guessing, and a plausible wrong answer arrives looking finished. `delegate` defines the six-part brief and the standing rule that unsettled decisions travel back rather than being resolved locally.

Orchestration stays in the main session on Opus; execution runs on Sonnet subagents.
