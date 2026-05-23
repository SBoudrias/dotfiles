---
name: unit-test-quality
description: Write or improve unit tests so they validate durable behavior instead of implementation details. Use when Codex is adding tests, revising tests after review feedback, reducing mocks, designing fixtures, choosing assertion boundaries, or deciding how to test generated output, state changes, side effects, errors, or user-visible behavior.
---

# Unit Test Quality

## Core Rule

Test the externally meaningful behavior, not the private path the implementation currently takes to produce it. A good unit test should survive a reasonable refactor that preserves the contract.

Prefer real inputs and observable outputs. Mock only dependencies that would make the test slow, flaky, nondeterministic, unsafe, or outside the unit's responsibility.

## Choose The Boundary

Before writing assertions, name the behavior the test is proving and pick the boundary that observes it most directly:

- **Pure logic**: assert return values for representative inputs and edge cases.
- **State changes**: assert the final public state, not the sequence of internal assignments.
- **Generated output**: read the output and assert the properties that matter to consumers.
- **Persistence or filesystem effects**: assert created, changed, deleted, or untouched files at the real boundary when practical.
- **Network or service effects**: mock at the protocol/API boundary and assert the request or response behavior, not lower-level helper calls.
- **UI behavior**: interact like a user and assert visible state, accessibility roles, or submitted data.
- **Errors**: assert the observable failure mode and any recovery behavior, not the specific internal branch unless that branch is the contract.

## Assertion Design

Make each assertion answer a question a maintainer would care about if it broke. Avoid broad snapshots, duplicated expected structures, and assertions that merely restate the implementation.

Use the output's natural shape:

- For structured output, parse it and assert the relevant fields.
- For canonicalized output, assert it is stable under the canonicalizer instead of hard-coding the whole transformed artifact. Normalize incidental whitespace before snapshotting.
- For ordered collections, assert entries in order in one place rather than splitting value and order assertions.
- For "no change" behavior, assert the relevant persisted or returned data still equals the original fixture.
- For side effects, assert the final side effect rather than every internal call that led to it.

Keep important expectations inline unless a helper removes substantial repetitive setup. Assertion helpers can hide what the test really proves and make review harder. Keep test names aligned with the actual contract; misleading names are test quality issues.

## Fixture Discipline

Keep fixtures realistic, minimal, and shaped like production data. Local production data, such as JSON files read from disk, can be the best fixture when stable and cheap to load; do not replace it with fake inline data by default. Live APIs, networks, and other unstable or slow boundaries should still be mocked.

Keep fixture ordering and formatting consistent with production output when the test rewrites or compares whole artifacts. Arbitrary fixture differences create review churn and can obscure the behavior under test.

Name reusable values once and reuse them. If the test creates a path, ID, request body, or fixture object, avoid reconstructing the same value later with a different expression.

## Mock Discipline

Use fewer, coarser mocks. Mock at the boundary that lets the unit run deterministically or faster, not every helper the implementation currently calls. Returning curated real records from a mocked disk-loading boundary is valid when the assertions still cover observable behavior.

Avoid tests that only prove "helper X was called with Y" unless that call is the public contract. Prefer verifying the resulting return value, stored data, emitted event, request, file content, or UI state.

Do not mock the code path you are trying to validate. If a test replaces the important behavior with a mock, it is usually testing wiring rather than behavior.

## Frontend and Testing Library

- Prefer page or public component tests over internal child components when the boundary is cheap enough.
- Use semantic queries with accessible names. Avoid `data-testid`, broad text queries, and DOM traversal unless there is a measured reason.
- For controlled inputs, use a small stateful harness and assert visible value or state, not callback churn from an un-rerendered prop.
- Prefer `userEvent` for workflows. Use low-level events only when the event itself is the boundary.
- For URL state, assert the router or query adapter result, not internal setter calls.
- For search and filters, assert both inclusion and exclusion inside the relevant list or group.
- For links, query user-visible anchors and use shared URL factories when available.

## Useful Patterns

For canonicalized generated output:

```typescript
const content = await readOutput();

expect(content).toBe(await canonicalize(content));
```

For structured generated output:

```typescript
const output = parse(await readOutput());

expect(output.requiredField).toBe('expected value');
expect(output.removedField).toBeUndefined();
```

For ordered data:

```typescript
expect(Object.entries(output.items)).toEqual([
    ['alpha', '1.0.0'],
    ['zebra', '1.0.0'],
]);
```
