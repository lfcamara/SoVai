# UI Prototype

Build **several radically different variations** of an interface that the user can flip between, pick a winner from, and throw the rest away.

If the question is about logic or state rather than what something looks like — wrong branch. Use [LOGIC.md](LOGIC.md).

## When this is the right shape

- "What should this screen look like?"
- "Show me a few options before I commit."
- "Try a different layout for this flow."
- Any time the user would otherwise spend a day comparing three vague mockups held in their head.

## Pick a host

Variants have to live somewhere. Take the first of these that applies:

**A — inside an existing view.** The view already exists in the codebase. Variants render in place, and the real data, params, and auth all stay; only the rendering swaps. Prefer this whenever there is a plausible host, including for something new that would naturally live inside an existing view — a new section, a new card, a new step in a flow.

A variant judged in isolation always looks fine. Butting it against the real surrounding interface, real data, and real density is what exposes the problems, which is why this host beats the others when it is available.

**B — a new throwaway view in the codebase.** For a genuinely new top-level surface with nowhere to embed. Follow the project's existing conventions and name it so it is obviously a prototype. Before choosing this, check again that there is really no existing view to host it — an empty surface hides problems a populated one would show.

**C — a standalone artifact.** No codebase yet, or the project is still being planned. Load the `artifact-design` skill, build a self-contained HTML page holding all the variants, and publish it with the Artifact tool. This is the planning-stage host: it needs nothing to exist, works whatever the eventual platform is, and gives the user a link to react to.

Where the target platform is not the web, keep the artifact honest about proportion and input — size the frames to the real device and do not lean on interactions the platform will not have.

## Process

### 1. State the question and pick N

Default to **3 variants**. Past 5 they stop being different and start being noise.

Write the plan down in one line, at the top of the prototype:

> "Three variants of the settings screen, switchable from the bar, on the existing settings view."

### 2. Generate radically different variants

Variants must be **structurally different** — different layout, different information hierarchy, different primary affordance. Three lightly-tweaked card grids is not a prototype, it is wallpaper. If two drafts come out similar, redo one with an explicit constraint ruling out the shape they share.

Hold each variant to the view's purpose, the data actually available, and the project's existing component and styling system where there is one.

### 3. Wire up a switcher

One control that moves between variants: previous, the current variant's key and name, next. Whatever the platform, it must be

- **operable without editing code** — the user flips through it themselves,
- **stable across a reload**, so a variant can be returned to,
- **shareable** where the platform allows it, so the user can point someone at one,
- **visually distinct** from the interface being judged, so it is never mistaken for part of the design,
- **absent from production builds**, gated behind a development check, so a stray merge cannot ship it.

On the web that is naturally a URL search param, which buys shareability for free. Elsewhere use whatever the platform gives — an in-app toggle, a query on the route, a control in the artifact. Keyboard or gesture navigation on top of it is a bonus; if arrow keys are used, leave them alone while a text field has focus.

### 4. Hand it over

Give the user the link or command and the variant keys. The most useful response is almost always **"the header from B with the sidebar from C"** — that recombination is the actual design, and it is what the exercise was for.

### 5. Capture the answer and clean up

Once a variant wins, record which one and why, then follow the capture rule in [SKILL.md](SKILL.md). Fold the winner into the real code — rewritten properly, since the variant was built under prototype constraints — and move the losing variants and the switcher onto the throwaway branch. The full set is the primary source and worth keeping; left in main it rots and confuses the next reader.

## Anti-patterns

- **Variants that differ only in colour or copy.** That is a tweak. Real variants disagree about structure.
- **Sharing too much between variants.** A shared header is fine; a shared layout defeats the point. Each variant must be free to throw the layout out.
- **Wiring variants to real mutations.** Read-only is fine — point at a stub. The question is what it should look like, not whether the backend works.
- **Promoting prototype code straight to production.** It was written with no tests and no error handling. Rewrite it when folding it in.
