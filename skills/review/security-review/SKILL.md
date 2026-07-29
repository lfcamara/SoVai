---
name: security-review
description: Review the security surface of a diff — untrusted input reaching an interpreter, authorization gaps, secrets, data exposure, and new dependencies. Use when reviewing a diff's security implications, or when another skill needs the security axis of a review run.
---

# Security Review

This axis reviews what a diff exposes to an attacker. It does not own general code quality (`code-review`) or whether the feature is the right one (`spec-review`) — a change can be well-factored, on-spec, and still open a hole.

A finding on this axis must name a concrete path from an attacker's input to harm. "Unvalidated input" is not a finding; "the `search` param reaches `db.raw()` unescaped at line 42" is. State the reachable interpreter or the reachable data, not the category it belongs to — categories don't tell the reader whether to block the merge.

## Untrusted input reaching an interpreter

Trace every value that originates outside the trust boundary — a request body, query param, header, uploaded file, or a value from another service that itself takes untrusted input — to where it's consumed. Flag it where it reaches:

- A SQL or query-language call built by concatenation or interpolation rather than parameterization.
- A shell command, subprocess call, or anything that ends up on a command line.
- A template engine or HTML sink where the value isn't escaped for its context.
- A deserializer for a format that can construct arbitrary objects or invoke code (a language-native serializer over untrusted bytes is the classic case).

The finding is the traced path — where the input enters and where it lands — not the mere presence of an interpreter somewhere in the codebase.

## AuthN vs AuthZ

Being logged in and being allowed to do this are different checks, and a diff that only does the first has a gap. Read every new or changed endpoint and handler for two things: does it verify identity, and separately, does it verify that this identity is permitted this specific action on this specific resource.

The tell to look for is an object reference — an ID pulled from the URL, body, or query — passed straight to a lookup or mutation with no check that the caller owns or is scoped to that object. A handler that checks "is there a valid session" and then fetches `/orders/:id` for any `id` a caller supplies has authentication without authorization.

## Secrets

Check the diff for credentials, API keys, tokens, or connection strings appearing as literal values — in source, in a config file that's committed to the repo, in a test fixture, or written into a log statement. A secret loaded from environment or a secrets manager is fine; a secret that would show up in `git log` or a log aggregator is a finding, ranked by what it unlocks.

## Data exposure

Check response shapes and error output for more than the caller needs. Two forms:

- A serializer or response builder that returns a full record — internal fields, other users' data, a password hash — where the caller's use case needs a subset.
- An error message or stack trace that reaches the client with internal detail: file paths, query text, dependency versions, infrastructure hostnames.

## Dependencies

Check every dependency the diff adds or bumps. A new dependency expands the trust boundary to include its maintainers and its own dependency tree; a version bump can introduce a new one transitively or drop a fix the codebase was relying on. Note what the dependency is used for — that's what determines its blast radius if it's compromised, not its size or popularity.

## New unauthenticated surface

Anything the diff makes reachable without authentication — a new route, a new webhook receiver, a new public file, a relaxed CORS or auth-bypass rule — deserves a look for that reason alone, independent of what else it does. Reachability without a login is itself the risk factor: it moves the attack surface from "requires a compromised account" to "requires only a network path."

## Ranking

Order findings by exploitability and blast radius: how easily an attacker reaches the flaw (no auth required outranks authenticated-only; a public endpoint outranks an admin-only tool) crossed with what they gain if it lands (full data access or code execution outranks a single field leak). Do not rank by category — a "secrets" finding that's a low-privilege internal token in a dead code path is a lower finding than a "data exposure" finding that leaks every user's email on an unauthenticated endpoint.

This applies the same way regardless of target — web, mobile, or backend service — the interpreters and trust boundaries differ, the reasoning about reachability and blast radius does not.

## Severity

Assign each finding a severity per `review`'s ladder, using the ranking above to sort it: critical is an unauthenticated path to full data access or code execution; high is the same reachable only with an authenticated session, or an unauthenticated path to a narrower gain.
