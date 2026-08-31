# Design Brief Format

The brief lives at `docs/planning/<effort>/<effort> — Design Brief.md`.

It is not a document about the design — it **is the prompt**. The user opens it, takes the whole thing to a visual design tool (Claude Design, or whatever they use), and gets a canvas back. Write it to be pasted, not to be read.

## Template

```md
# <Effort name> — Design Brief

> Derived from [[<effort> — Wireframes]]. Regenerate it from there rather than editing it by hand.

Build a low-fidelity wireframe canvas for <effort name>. One artboard per screen below, laid out so the flow reads left to right.

## Fidelity

Deliberately low. Spend everything on structure:

- Greyscale only. One typeface. No imagery, no brand, no colour.
- Boxes, labels, and hierarchy — what is on the screen and what dominates it.
- Real content shape: a list of nine items, a title that wraps, an empty state. No lorem ipsum.

This is for critiquing flow and structure. Visual design is a later, separate stage.

## Canvas

Artboards sized to <target platform> proportions: <dimensions>.

## Artboards

### <Screen name>

Purpose: one line — what the user is here to do.

Holds, in hierarchy order:
- <element>
- <element>

States to draw as separate artboards: <empty, loading, error, …>

## Flow

<Screen A> —<action>→ <Screen B>
```

## Rules

- **Self-contained.** Someone pasting this into a tool with no other context must get the right thing. No wikilinks in the body, no references to files the tool cannot open.
- **Carry the fidelity constraints explicitly, every time.** A design tool pulls toward high fidelity by default, and high fidelity buys critique of colour and type while the missing step goes unmentioned. The constraints are the reason this stage exists.
- **Every screen in the record appears here**, including the unglamorous states.
- **Derived and disposable.** The header says so. When the record changes, rewrite the brief from it rather than patching both.
