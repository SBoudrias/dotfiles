# Tool use

## Github

When interacting with Github (github.com), ALWAYS use `gh` on the command line, do not use an MCP server.

ALWAYS open new PRs in draft mode.

## Worktrees

1. Before creating new worktrees, always fetch the latest state of our main branch (`main` or `preprod` or etc) so we're working on a recent state of the codebase.
2. Use short but descriptive names for the branch and the worktree folder name. Do NOT only use a ticket number.
3. Create worktrees inside `~/github/.worktrees/`
4. Always run install inside the new worktree after creation. Use the proper package management tool, look at the lock file to know which one a project use.
