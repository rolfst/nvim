---
name: jj
description: "Jujutsu VCS operations with opt-in activation. Git-compatible VCS featuring automatic snapshotting, first-class conflicts, and powerful undo. **Use for**: explicit jj requests, change-based workflows, conflict-safe rebasing, operation log inspection."
license: Proprietary
compatibility: opencode
metadata:
  category: version-control
  risk: medium
  owner: Foundation department at DHL eCommerce BNL, IT & Digital
  audience: developers
  workflow: git
  tags: [jj, jujutsu, version-control, git, vcs]
  version: 1.0.0
---

# LLM Summary (Read First)

Jujutsu (jj) is a Git-compatible VCS with automatic change snapshotting and first-class conflict support. This skill is **OPT-IN ONLY** - agents must receive explicit user instruction to use jj (e.g., "use jj for this", "commit with jj").

**Core safety features you should emphasize:**
- `jj undo` - reverses the last operation completely
- `jj op log` - shows full operation history for recovery
- Conflicts don't block operations - can be committed and resolved later

**Trigger this skill when user explicitly:**
- Mentions "jj" or "jujutsu" in their request
- Is working in a repo with `.jj/` directory AND asks to use jj
- Asks questions about jj workflow or concepts

**Do NOT trigger for:**
- Generic git requests (use git unless user specifies jj)
- Repos without `.jj/` directory (unless user asks to initialize)
- Automated workflows (stick with git until jj requested)

---

## Core Concepts (Teach These First)

### 1. **Changes vs Commits**

**Change ID**: Stable identifier that survives rewrites (e.g., `kntqzsqt`)
**Commit ID**: Git-style hash that changes with each rewrite (e.g., `5d39e19d`)

```bash
# View change evolution over time
jj evolog              # See how one change evolved through amendments
jj evolog -p           # Show diffs between versions

# Reference specific change version
jj show <change-id>/1  # Second-most-recent version of that change
```

**Why this matters**: Track work through rebases, amendments, and squashes. Change IDs enable true change-based development vs commit-based.

### 2. **Working Copy is Always a Commit (`@`)**

```bash
jj log     # Working copy shows as @ - it's a real commit

# Every jj command snapshots working copy first
# No "git add" needed - changes are automatically tracked
echo "new" > file.txt   # Automatically tracked on next jj command

# Explicitly snapshot without other operations
jj commit -m "snapshot current work"  # Creates commit + new empty @
```

**Key difference from Git**: No staging area. Working copy (`@`) is a commit that gets auto-snapshotted before every operation.

### 3. **Bookmarks (Not Branches)**

Bookmarks are **named pointers to commits** but do NOT move automatically like Git branches:

```bash
# Create bookmark - does NOT move with new commits
jj bookmark create feature-x

# Bookmarks must be moved manually
jj commit -m "new work"
jj bookmark move feature-x --to @-   # Move bookmark to parent of @

# Track remote bookmark
jj bookmark track feature-x --remote=origin

# List bookmarks
jj bookmark list
jj bookmark list --all  # Include remotes
```

**Critical difference**: Git branches move automatically; jj bookmarks stay put until you move them explicitly.

### 4. **Operation Log (Your Safety Net)**

Every operation is recorded and reversible:

```bash
# View all operations
jj op log
jj op log -p           # With diffs

# Undo last operation
jj undo

# Restore to specific operation
jj op restore <operation-id>

# View repo at past operation
jj --at-op=<operation-id> log
```

**Agent behavior**: Lead with this safety feature early. Users can experiment fearlessly knowing `jj undo` exists.

### 5. **First-Class Conflicts**

Conflicts DON'T block operations:

```bash
# Rebase succeeds even with conflicts
jj rebase -s <commit> -d <dest>   # Creates conflicted commit, doesn't stop

# View conflicts
jj log                # Shows (conflict) label

# Resolve later
jj new <conflicted-commit>
# Edit conflict markers
jj squash              # Move resolution into conflicted commit
```

**Agent behavior**: Explain conflicts can be committed and rebased like any change. Resolution can be deferred.

---

## Activation Criteria

### ✅ TRIGGER this skill when:

- User explicitly says "use jj", "with jujutsu", "jj commit", etc.
- User asks "how do I X in jj?" or "what's the jj equivalent of Y?"
- User is in a `.jj/` repo AND says "commit this" after previously using jj
- User asks to initialize jj: "set up jj here", "jj git init"

### ❌ DO NOT trigger for:

- Generic version control requests without mentioning jj
- "git commit" (even in a colocated repo - honor explicit tool choice)
- Automated scripts/CI unless explicitly configured for jj
- First-time repo operations (default to git until user opts in)

### 🔍 Detection Patterns

```regex
# Positive triggers (explicit jj mentions)
\bjj\s+(commit|new|describe|squash|rebase|bookmark|evolog|undo|op\s+log)\b
\buse\s+jj\b
\bjujutsu\b
\bwith\s+jj\b

# Questions about jj
\bhow\s+(do|to|can).+(in|with|using)\s+jj\b
\bjj\s+equivalent\b
\bchange\s+id\b.*jj
\bevolog\b

# Context: already using jj (check .jj/ exists + user said "commit")
# Only trigger if previous messages in session used jj
```

---

## Guardrails (Hard Rules)

### A. **Never Auto-Switch to JJ**

- ❌ NEVER: "I see this is a colocated repo, let me use jj..."
- ✅ INSTEAD: "This repo supports both git and jj. Which would you like to use?"

**Rationale**: Explicit opt-in prevents surprising users unfamiliar with jj.

### B. **Respect Tool Choice**

- If user says "git commit", use git (even if `.jj/` exists)
- If user says "jj commit", use jj (even if they used git before)
- Don't switch tools mid-workflow without explicit request

### C. **No Destructive Remote Operations Without Confirmation**

```bash
# ❌ Never auto-run:
jj git push --force
jj git push --bookmark main  # Pushing to protected bookmark

# ✅ Always ask first:
"This will force-push to remote. Confirm to proceed."
```

### D. **Bookmark Protection (Adapted from safe-push-review)**

Protected bookmarks (never push directly):
- `main`
- `master`
- `production`
- `release/*`

```bash
# If on protected bookmark:
jj bookmark list   # Check current

# ❌ BLOCK:
jj git push --bookmark main

# ✅ SUGGEST:
"Cannot push directly to 'main' bookmark.
Should I create a feature bookmark?
  jj bookmark create feature/<name> -r @-
"
```

### E. **Story Reference Validation (Adapted for Changes)**

Per `dhl-story-tracking`, but adapted for jj's change model:

```bash
# Story should be in change description (survives rewrites)
jj describe -m "feat: Add validation [PLAT-123]"

# Check if change has story reference
jj show @   # Inspect description

# Story key pattern: [A-Z]{2,10}-[0-9]+
```

**Why change-based**: Git commit-ids change on rewrite; jj change-ids persist. Track story per change, not commit.

### F. **Colocated Repository Detection**

When both `.jj/` and `.git/` exist:

```bash
# ✅ Detect and inform:
"This is a colocated repo (both jj and git).
Git commands work normally.
To use jj instead, say 'use jj for X'.

Note: Git will show detached HEAD (normal for colocated repos).
"

# ❌ Don't auto-switch or surprise user
```

---

## Primary Workflows

### Workflow 1: **Squash Workflow (Default)**

Use this for most operations. Replaces Git's staging area:

```bash
# 1. Start new change
jj new main                    # Create empty working copy on main

# 2. Make changes
# Edit files... (automatically tracked)

# 3. Check status
jj st                          # Like git status, no staging
jj diff                        # Show working copy changes

# 4. Create commit (freezes work, creates new empty @)
jj commit -m "feat: Add validation [PLAT-123]"

# 5. Continue editing new @
# Make more changes...

# 6. Squash changes into parent commit (amend)
jj squash                      # Moves @ into parent

# 7. Or squash specific files
jj squash file1.txt file2.txt

# 8. Push when ready
jj bookmark create feature/validation -r @-
jj bookmark track feature/validation
jj git push --bookmark feature/validation
```

**Agent template for squash workflow:**

1. Verify `.jj/` exists or ask to initialize
2. `jj st` to show current state
3. If working copy has changes: suggest `jj commit` to freeze
4. For amendments: suggest `jj squash` to update parent
5. For partial amendments: `jj squash <files>`
6. Before push: create/move bookmark, then `jj git push`

### Workflow 2: **Edit Workflow (Advanced)**

Use when user needs to modify specific historical commit:

```bash
# 1. Edit specific commit directly
jj edit <commit-id or change-id>    # Working copy becomes that commit

# 2. Make changes
# Edit files... (automatically amends the commit)

# 3. Return to tip
jj new                               # Create new empty @ on top

# Warning: Avoid jj edit on conflicted commits (breaks markers)
```

**When to teach edit workflow:**
- User asks "how do I modify commit X?"
- User needs to split old commit: `jj edit <commit>`, then `jj split`
- User wants to insert changes in middle of stack

**Agent behavior**: Warn that edit modifies history, descendants will be rebased. Suggest `jj evolog` to see before/after.

### Workflow 3: **Split Changes**

Split working copy or commit into multiple commits:

```bash
# Interactive split (like git add -p)
jj split -i

# Split specific files into new commit
jj squash file1      # Move file1 to parent
jj split file2       # Keep file2 in new commit

# Split old commit
jj edit <commit>     # Edit target commit
jj split -i          # Split interactively
jj new               # Return to tip
```

---

## Common Operations

### Initialize JJ

```bash
# In existing Git repo (colocated setup)
jj git init --colocate

# Clone with jj + git support
jj git clone --colocate <url>

# Pure jj repo (no git)
jj git init
```

**Agent behavior**: Always use `--colocate` for existing git repos. Explain git still works normally.

### Daily Operations

```bash
# Status and diff
jj st                         # Working copy status
jj diff                       # Working copy changes
jj diff -r <commit>           # Changes in specific commit
jj show <commit>              # Commit details + diff

# Commit operations
jj commit -m "message"        # Freeze work, create new @
jj describe -m "new message"  # Update @ description
jj squash                     # Move @ into parent
jj squash -i                  # Interactive squash
jj split -i                   # Split @ into multiple commits

# View history
jj log                        # Change graph
jj log -r 'mine()'           # Only my changes
jj evolog                     # Evolution of current change
jj evolog -r <change-id>      # Evolution of specific change

# Rebase (descendants auto-rebase)
jj rebase -s <commit> -d <dest>  # Rebase commit and descendants
jj rebase -r <commit> -d <dest>  # Rebase single commit only

# Abandon (hide commit, rebase descendants)
jj abandon <commit>

# Undo/Redo
jj undo                       # Undo last operation
jj redo                       # Redo undone operation
jj op log                     # View operation history
jj op restore <op-id>         # Restore to specific operation
```

### Bookmark Operations

```bash
# Create and manage bookmarks
jj bookmark create <name>              # Create at @
jj bookmark create <name> -r <commit>  # Create at specific commit
jj bookmark move <name> --to <commit>  # Move bookmark
jj bookmark delete <name>              # Delete bookmark

# Track remote bookmarks
jj bookmark track <name>               # Track remote bookmark
jj bookmark untrack <name>             # Untrack

# List bookmarks
jj bookmark list                       # Local bookmarks
jj bookmark list --all                 # Include remotes
```

### Remote Operations (Colocated Repos)

```bash
# Fetch from remote
jj git fetch

# Push to remote
jj git push                            # Push all tracked bookmarks
jj git push --bookmark <name>          # Push specific bookmark
jj git push --change @-                # Auto-create bookmark, push parent
jj git push --force                    # Force push (rare, needs confirmation)

# Export jj changes to git
jj git export                          # Sync jj → git (automatic on push)

# Import git changes to jj
jj git import                          # Sync git → jj (automatic on fetch)
```

### Conflict Resolution

```bash
# View conflicts
jj log                        # Shows (conflict) label
jj st                         # Shows conflicted files

# Resolve conflicts
jj new <conflicted-commit>    # Create new @ on conflicted commit
# Edit conflict markers in files
jj squash                     # Move resolution into parent

# Conflict marker styles (configure if needed)
# ~/.config/jj/config.toml:
# ui.conflict-marker-style = "diff"      # Default
# ui.conflict-marker-style = "snapshot"  # Full sides
# ui.conflict-marker-style = "git"       # Git diff3 style

# Use external merge tool
jj resolve                    # Launch merge tool for conflicts
```

---

## Integration with Other Skills

### With `dhl-story-tracking` (Adapted for Changes)

**Story reference in change description** (persists through rewrites):

```bash
# Add story to change description
jj describe -m "feat: Add validation [PLAT-123]"

# Story extraction pattern (same as git)
# Pattern: [A-Z]{2,10}-[0-9]+
# Regex: (?:Story:|Fixes|Closes|\[)\s*([A-Z]{2,10}-[0-9]+)

# View change description
jj show @                     # Check if story present
```

**Agent checklist:**
- [ ] Extract story key from `jj show @` description
- [ ] If missing, prompt: "Which story is this change for? (e.g., PLAT-123)"
- [ ] Add story via `jj describe -m "..."`
- [ ] Cache story per change-id (not commit-id)
- [ ] On push: verify story present and valid

**Caching strategy:**
```bash
# Cache file: .opencode/.cache/jj/change-stories.json
# Format: { "<change-id>": "PLAT-123", ... }
# TTL: Session lifetime (changes are mutable, stories shouldn't change)
```

### With `safe-push-review` (Adapted for Bookmarks)

**Sensitive file detection** (same as git):

```bash
# Before jj commit or jj squash:
jj st                         # List changed files
# Run sensitive file checks (GDPR, secrets, PII)
# If sensitive files detected, block until resolved
```

**Bookmark protection** (replaces branch protection):

```bash
# Protected bookmarks: main, master, production, release/*
# Before jj git push --bookmark <name>:

# Check if bookmark is protected
jj bookmark list | grep "^$BOOKMARK"

# If protected:
echo "❌ Cannot push directly to '$BOOKMARK' bookmark."
echo "Create a feature bookmark:"
echo "  jj bookmark create feature/<name> -r @-"
echo "  jj git push --bookmark feature/<name>"
exit 1
```

**Push confirmation gate:**

```bash
# Before any jj git push:
echo "Sensitive file check: ✓"
echo "Bookmark protection check: ✓"
echo ""
echo "Please confirm the feature/bugfix works end-to-end."
echo "Reply 'Confirmed to push' to proceed."
# Wait for user confirmation
```

### With `git-release`

When creating releases in colocated repos:

```bash
# Option 1: Use git commands (releases are git concepts)
git tag v1.2.0
gh release create v1.2.0

# Option 2: Use jj to create git tag
jj git export                 # Ensure git is synced
cd .git && git tag v1.2.0 && cd ..
jj git import                 # Import tag back to jj

# Recommended: Use git for release management
# Use jj for development workflow
```

**Agent behavior**: For releases, suggest using git commands even in colocated repos (releases are git/GitHub concepts).

---

## Git Mental Model Transitions

Help users/agents trained on git understand jj equivalents:

| Git Command | JJ Equivalent | Notes |
|------------|---------------|-------|
| `git add <file>` | *No equivalent* | Changes auto-tracked |
| `git add -p` | `jj split -i` | Interactive change selection |
| `git commit` | `jj commit` | Also creates new empty @ |
| `git commit --amend` | `jj squash` | Works from any commit |
| `git rebase -i` | `jj rebase` + `jj squash`/`split` | Descendants auto-rebase |
| `git checkout <branch>` | `jj new <bookmark>` | Creates new commit on top |
| `git switch <branch>` | `jj edit <commit>` | Direct edit (less common) |
| `git stash` | `jj new` | Just create commits |
| `git cherry-pick` | `jj rebase -r <commit> -d <dest>` | Rebase single commit |
| `git reset --hard HEAD~` | `jj abandon @` | Hide current commit |
| `git reflog` | `jj op log` | Atomic operation log |
| `git reset --hard <commit>` | `jj undo` or `jj op restore` | Undo operations |
| `git branch -d <branch>` | `jj bookmark delete <name>` | Delete bookmark |
| `git push` | `jj git push` | Same in colocated repos |
| `git pull` | `jj git fetch` + `jj rebase` | Separate fetch/integrate |

### Common Pattern Translations

**Git: Stage partial changes and commit**
```bash
git add -p file.txt
git commit -m "partial changes"
```
**JJ equivalent:**
```bash
jj split -i
jj describe -m "partial changes"
```

---

**Git: Amend last commit**
```bash
git commit --amend
```
**JJ equivalent:**
```bash
jj squash              # Move @ into parent
```

---

**Git: Interactive rebase to fixup**
```bash
git rebase -i HEAD~3
# Mark commit as "fixup"
```
**JJ equivalent:**
```bash
jj squash --into <target-commit>
```

---

**Git: Stash work, switch branch**
```bash
git stash
git checkout other-branch
# work...
git checkout -
git stash pop
```
**JJ equivalent:**
```bash
jj commit -m "WIP"     # Just commit it
jj new other-bookmark  # Switch context
# work...
jj new wip-change      # Return to WIP change
jj squash              # Continue work (or abandon if done)
```

---

## Agent Action Template

When user requests jj operation, follow this checklist:

### 1. **Verify JJ Available**

```bash
# Check jj installed
jj --version

# If not installed:
"JJ (Jujutsu) is not installed.
Install: https://github.com/martinvonz/jj#installation
Or use git for this operation?"
```

### 2. **Detect Repository Type**

```bash
# Check for .jj directory
ls -la .jj/

# Check for colocated setup
ls -la .jj/ .git/

# Report status:
if .jj/ and .git/ exist:
  "This is a colocated repo (jj + git).
   Both tools work. Using jj as requested."
elif only .jj/ exists:
  "Pure jj repo. Using jj."
elif only .git/ exists:
  "This is a git-only repo.
   Would you like to initialize jj?
     jj git init --colocate"
else:
  "No version control. Initialize?
     jj git init --colocate  (jj + git)
     jj git init             (jj only)
     git init                (git only)"
```

### 3. **Safety Feature Reminder (First Use)**

On first jj command in session:

```
💡 JJ Safety Features:
- jj undo        Reverse last operation
- jj op log      View all operations
- jj evolog      See change evolution

You can experiment safely - operations are reversible!
```

### 4. **Execute Requested Operation**

Follow workflow patterns (squash, edit, split, etc.)

### 5. **Show Result**

```bash
# After operation, show:
jj log -n 5         # Recent changes
jj st               # Current state

# Explain what happened:
"Created change kntqzsqt: feat: Add validation [PLAT-123]
Working copy (@) is now empty and ready for new work.

Next steps:
- Continue editing: changes auto-tracked
- Amend: jj squash
- Push: jj bookmark create feature/validation -r @- && jj git push
"
```

### 6. **Integration Checks**

**Story tracking:**
```bash
# Check for story reference
jj show @ | grep -E '[A-Z]{2,10}-[0-9]+'

# If missing:
"No story reference found.
Per dhl-story-tracking skill, add story key:
  jj describe -m 'feat: Add validation [PLAT-123]'
"
```

**Sensitive files:**
```bash
# Before commit/squash
jj st
# Check changed files for sensitive content
# (same logic as safe-push-review)
```

**Bookmark protection:**
```bash
# Before push
jj bookmark list
# Check if target is protected (main, master, production, release/*)
```

---

## Error Handling

### Error: "No JJ repo found"

```bash
# User ran jj command outside .jj repo
# Response:
"No .jj repository found here.

Initialize jj:
- In existing git repo: jj git init --colocate
- New jj repo: jj git init
- Clone with jj: jj git clone --colocate <url>
"
```

### Error: Conflict markers in files

```bash
# User edited conflicted files, jj confused
# Response:
jj st    # Show conflicted state

"Conflict markers detected.
Resolve conflicts:
  1. Edit files to resolve conflicts
  2. jj squash  (move resolution into parent)

Or use external tool:
  jj resolve

Conflicts in jj are normal and can be committed.
Resolve now or later (jj new <conflicted> when ready).
"
```

### Error: Bookmark doesn't exist

```bash
# jj bookmark move feature/x --to @
# Error: No such bookmark 'feature/x'

# Response:
jj bookmark list    # Show available bookmarks

"Bookmark 'feature/x' not found.

Create it:
  jj bookmark create feature/x -r @-

Or did you mean one of these?
  [list similar bookmarks]
"
```

### Error: Push rejected (non-fast-forward)

```bash
# jj git push --bookmark feature/x
# Error: non-fast-forward

# Response:
"Push rejected (non-fast-forward).
Someone else pushed to this bookmark.

Options:
1. Fetch and rebase:
   jj git fetch
   jj rebase -s <your-change> -d <remote-bookmark>
   jj git push --bookmark feature/x

2. Force push (dangerous):
   jj git push --force --bookmark feature/x
   ⚠ Only if you're sure no one else has this work.

3. Create new bookmark:
   jj bookmark create feature/x-v2 -r @-
   jj git push --bookmark feature/x-v2
"
```

### Error: Descendant commits exist

```bash
# User tries to abandon/edit commit with descendants
# jj will auto-rebase descendants

# Response (before operation):
"This commit has descendants that will be rebased:
  [show affected commits with jj log]

Proceed? This will rewrite history.
- Yes: Operation continues (descendants rebased)
- No: Cancel operation
- View first: jj log -r '<commit>::@'
"
```

### Recovery: "I messed up, undo everything"

```bash
# User wants to revert recent operations
jj op log -n 10     # Show recent operations

"You can undo operations:

Undo last operation:
  jj undo

Undo last N operations:
  jj undo  (repeat N times)

Restore to specific point:
  jj op log           # Find operation ID
  jj op restore <op-id>

View repo at past state (read-only):
  jj --at-op=<op-id> log
"
```

---

## GitHub/GitLab Workflow

### Pattern 1: Auto-Generated Bookmark (Quick)

```bash
# Start work
jj new main
# Make changes...
jj commit -m "feat: Add validation [PLAT-123]"

# Push with auto-bookmark
jj git push --change @-    # Creates push-<change-id> bookmark
# Example: push-kntqzsqt

# GitHub PR:
gh pr create --head push-kntqzsqt --base main
```

**Agent template:**
```
1. jj commit to freeze work
2. jj git push --change @-  (auto-bookmark)
3. Note bookmark name from output
4. gh pr create --head <bookmark> --base main
```

### Pattern 2: Named Bookmark (Explicit)

```bash
# Start work
jj new main
jj commit -m "feat: Add validation"

# Create named bookmark
jj bookmark create feature/validation -r @-
jj bookmark track feature/validation

# Push
jj git push --bookmark feature/validation

# GitHub PR:
gh pr create --head feature/validation --base main
```

**Agent template:**
```
1. jj commit to freeze work
2. jj bookmark create feature/<name> -r @-
3. jj bookmark track feature/<name>
4. jj git push --bookmark feature/<name>
5. gh pr create --head feature/<name> --base main
```

### Pattern 3: Update PR (Address Review Comments)

```bash
# Make changes in response to review
# (working copy @ is on top of PR commit)

# Squash into PR commit
jj squash

# Force push (updates PR)
jj git push --bookmark feature/validation
# jj auto-force-pushes when bookmark moved
```

**Agent behavior**: Explain that jj force-pushes automatically when bookmark is rewritten (safe for feature branches).

### Pattern 4: Stacked PRs

```bash
# Base change
jj new main -m "base: Add validation framework"
jj bookmark create base-validation -r @-

# Dependent change
jj new -m "feat: Add specific validator"
jj bookmark create feature-validator -r @-

# Push both
jj git push --bookmark base-validation
jj git push --bookmark feature-validator

# Create PRs
gh pr create --head base-validation --base main
gh pr create --head feature-validator --base base-validation
```

---

## Colocated Repository Patterns

### Understanding Colocated Setup

```bash
# After jj git init --colocate:
.jj/       # JJ repository
.git/      # Git repository (backing store)

# Git sees:
git status    # Detached HEAD (normal!)
git log       # Same commits as jj

# JJ sees:
jj log        # Change graph with change-ids
```

**Agent explanation:**
```
In colocated repos:
- Git shows "detached HEAD" (normal for jj)
- Both tools work on same commits
- jj uses git as storage backend
- Changes sync automatically

Use jj for workflow, git for compatibility.
```

### Sync Behavior

```bash
# Automatic sync:
jj git fetch     # git → jj (imports git refs)
jj git push      # jj → git (exports bookmarks as branches)

# Manual sync (rare):
jj git import    # Force import from git
jj git export    # Force export to git
```

### Mixing Git and JJ Commands

```bash
# Scenario: Team member uses git, you use jj

# They pushed to git:
git pull origin main     # Update git
jj git import            # Import to jj (or jj git fetch)

# You push with jj:
jj git push --bookmark feature/x    # Exports to git
# Team sees normal git branch "feature/x"
```

**Agent guidance:**
```
Safe to mix tools:
- Use jj for your work (better workflow)
- Use git when required (releases, hooks, team conventions)
- jj git fetch/push syncs automatically

Warning: Interleaving rapidly can cause bookmark divergence.
Pick primary tool per task.
```

---

## Caching Strategy

### Change-Story Mapping

**Cache file**: `.opencode/.cache/jj/change-stories.json`

**Format**:
```json
{
  "kntqzsqt": "PLAT-123",
  "vruxwmqv": "PLAT-456"
}
```

**TTL**: Session lifetime (stories shouldn't change after assignment)

**Usage**:
```bash
# On jj commit/describe:
CHANGE_ID=$(jj log -r @ --no-graph -T 'change_id' | head -1)
STORY=$(jj show @ | grep -oE '[A-Z]{2,10}-[0-9]+' | head -1)
# Write to cache: { "$CHANGE_ID": "$STORY" }

# On jj git push:
# Read cache, verify story still present
```

### Repository Metadata

**Cache file**: `.opencode/.cache/jj/repo-info.json`

**Format**:
```json
{
  "repo_root": "/path/to/repo",
  "is_colocated": true,
  "protected_bookmarks": ["main", "master", "production"],
  "last_check": "2026-03-07T21:00:00Z"
}
```

**TTL**: 1 hour

**Usage**: Cache expensive checks (colocated detection, bookmark enumeration)

---

## Configuration

### User Config Location

```bash
# Linux/Mac: ~/.config/jj/config.toml
# Windows: %USERPROFILE%\.config\jj\config.toml
```

### Recommended Settings

```toml
[user]
name = "Your Name"
email = "your.email@dhl.com"

[ui]
# Conflict marker style (default is good)
# conflict-marker-style = "diff"       # Default
# conflict-marker-style = "snapshot"   # Show full sides
# conflict-marker-style = "git"        # Git-style diff3

# Pager
pager = "less -FRX"

# Diff tool
diff-tool = "vimdiff"
merge-tool = "vimdiff"

[git]
# Auto-push tracked bookmarks
# push-bookmark-prefix = "push-"   # For jj git push --change

[revsets]
# Custom aliases for revset queries
log = "@ | ancestors(remote_bookmarks()..@, 2) | heads(remote_bookmarks())"

[aliases]
# Custom command aliases (if desired)
# l = ["log", "-r", "@::"]
# st = ["status"]
```

### Team-Level Config

**Per-repo config**: `.jj/repo/config.toml`

```toml
[git]
# Require story references before push (future enhancement)
# pre-push-hook = ".jj/hooks/story-check.sh"

[revsets]
# Team conventions
mine = "author('me@dhl.com')"
team = "author_regex('.*@dhl.com')"
```

---

## Monitoring & Debugging

### Check Repository State

```bash
# Repository info
jj git root                # Show git dir
jj root                    # Show workspace root

# Status checks
jj st                      # Working copy status
jj log -n 10               # Recent changes
jj bookmark list --all     # All bookmarks

# Operation health
jj op log -n 20            # Recent operations
# Look for errors, divergent ops
```

### Verify Sync in Colocated Repo

```bash
# Compare jj and git views
jj log -r main             # JJ view
git log main --oneline     # Git view
# Should show same commits (different IDs)

# Check export status
jj git export              # Ensure git is synced
git status                 # Should show detached HEAD
```

### Debug Change Evolution

```bash
# Trace change history
jj evolog -r <change-id>   # All versions of change
jj evolog -p               # With diffs

# Find when change was created
jj op log | grep <change-id>
```

### Performance Issues

```bash
# Large repo, slow operations?
# Check operation log size:
jj op log | wc -l

# Compact operations (if needed)
# Note: jj auto-compacts, manual rare

# Check working copy size
du -sh .jj/
```

---

## Setup Instructions

### First-Time Setup (New User)

1. **Install JJ**: https://github.com/martinvonz/jj#installation

2. **Configure user**:
   ```bash
   jj config set --user user.name "Your Name"
   jj config set --user user.email "your.email@dhl.com"
   ```

3. **Initialize in existing repo**:
   ```bash
   cd /path/to/repo
   jj git init --colocate
   ```

4. **Verify setup**:
   ```bash
   jj log
   jj st
   # Should show working copy and history
   ```

5. **Create cache directory**:
   ```bash
   mkdir -p .opencode/.cache/jj
   ```

### Team Onboarding

**For teams adopting jj:**

1. **Read-only exploration** (safe):
   ```bash
   jj git clone --colocate <url>
   jj log
   jj show <commit>
   # Explore without fear - operations are reversible
   ```

2. **First workflow** (squash pattern):
   ```bash
   jj new main
   # Make changes...
   jj st
   jj diff
   jj commit -m "your message"
   # Practice jj undo to see operation log
   ```

3. **First push** (feature branch):
   ```bash
   jj bookmark create feature/my-first
   jj git push --bookmark feature/my-first
   # Create PR as normal
   ```

4. **Learn safety features**:
   ```bash
   # Experiment freely:
   jj undo         # Always available
   jj op log       # See what you did
   jj evolog       # Track change evolution
   ```

---

## Quick Reference

| Task | Command | Notes |
|------|---------|-------|
| **Setup** |
| Init colocated | `jj git init --colocate` | In existing git repo |
| Clone | `jj git clone --colocate <url>` | Git-compatible |
| **Daily Work** |
| Status | `jj st` | Like git status |
| Diff | `jj diff` | Working copy changes |
| Commit | `jj commit -m "msg"` | Freezes work, new @ |
| Amend | `jj squash` | Update parent commit |
| Split | `jj split -i` | Interactive split |
| History | `jj log` | Change graph |
| **Bookmarks** |
| Create | `jj bookmark create <name>` | At current @ |
| Move | `jj bookmark move <name> --to @-` | Manual move |
| List | `jj bookmark list --all` | All bookmarks |
| **Remote** |
| Fetch | `jj git fetch` | Get remote changes |
| Push | `jj git push --bookmark <name>` | Push bookmark |
| Quick push | `jj git push --change @-` | Auto-bookmark |
| **Safety** |
| Undo | `jj undo` | Reverse last operation |
| Op log | `jj op log` | View all operations |
| Restore | `jj op restore <op-id>` | Jump to operation |
| Evolog | `jj evolog` | Change evolution |
| **Advanced** |
| Edit | `jj edit <commit>` | Modify commit directly |
| Rebase | `jj rebase -s <src> -d <dst>` | Move commits |
| Abandon | `jj abandon <commit>` | Hide commit |
| Resolve | `jj resolve` | External merge tool |

---

## Example User Interactions

### Scenario 1: User Asks to Commit

**User**: "Commit these changes"

**Agent** (checks context):
```bash
# Check if .jj exists
ls .jj/ 2>/dev/null

# If exists and user previously used jj:
"I can use jj or git. Which would you prefer?
- jj commit (recommended if you've been using jj)
- git commit (standard workflow)
"

# If user says "use jj":
jj st

"Working copy has changes:
- modified: src/validator.ts
- added: tests/validator.test.ts

Commit these changes?
  jj commit -m 'feat: Add validator [PLAT-123]'

This will freeze the changes and create a new empty working copy.
"
```

### Scenario 2: User Asks About JJ Concepts

**User**: "What's a change ID in jj?"

**Agent**:
```
Change IDs are stable identifiers in jj that survive rewrites.

Example:
- Change ID: kntqzsqt (stays same through amends, rebases)
- Commit ID: 5d39e19d (changes each rewrite)

Why it matters:
- Track work through history rewrites
- Reference same logical change: jj show kntqzsqt
- View evolution: jj evolog -r kntqzsqt

Git only has commit IDs (which change on rebase).
JJ has both for powerful change tracking.
```

### Scenario 3: User Makes Mistake

**User**: "Oh no, I just abandoned the wrong commit!"

**Agent**:
```bash
# Immediate undo
jj undo

"Undone! The abandoned commit is restored.

JJ safety feature: every operation is reversible.
- jj undo: reverse last operation
- jj op log: see full operation history
- jj op restore <op-id>: jump to any point

You can experiment fearlessly - operations are atomic and reversible.
```

### Scenario 4: First-Time JJ User

**User**: "Can I try jj in this repo?"

**Agent**:
```bash
# Check current state
git status

"This is a git repo. You can add jj support:

Initialize jj (colocated setup):
  jj git init --colocate

This will:
✓ Work alongside git (both tools available)
✓ Use git as storage (no duplication)
✓ Git shows 'detached HEAD' (normal for colocated repos)
✓ All changes reversible (jj undo)

Your git workflow remains unchanged.
Want to proceed?
"

# If yes:
jj git init --colocate
jj log

"JJ initialized! Your git history is now visible to jj.

Try these safe commands:
- jj log         (view history)
- jj st          (working copy status)
- jj new main    (start new change)

Remember: jj undo reverses any operation.
"
```

### Scenario 5: Conflict During Rebase

**User**: "Rebase feature onto main"

**Agent**:
```bash
jj git fetch
jj rebase -s feature-bookmark -d main

# Output shows conflicts
"Rebase completed with conflicts in:
- src/validator.ts

In jj, conflicts are first-class:
✓ Rebase succeeded (didn't abort like git)
✓ Conflicted commit is visible: jj log (shows 'conflict' label)
✓ You can continue other work
✓ Resolve when ready:
  jj new <conflicted-commit>
  # Edit conflict markers
  jj squash

Or resolve now:
  jj resolve
  # Opens merge tool

Conflicts don't block you - resolve now or later.
"
```

---

## Future Enhancements

Potential additions as team matures with jj:

1. **Pre-push hooks** for jj (story validation, sensitive files)
2. **Change-based CI** (trigger CI per change-id, not commit-id)
3. **Stacked PR workflow** templates
4. **Team revset aliases** (for consistent queries)
5. **Custom conflict marker styles** per team preference
6. **Operation log auditing** for compliance
7. **jj absorb** integration (auto-distribute changes to recent commits)

---

If you need:
- Custom workflow templates
- Team training materials
- Migration guide from git
- Pre-push hook for story validation
- CI integration patterns

Just ask!
