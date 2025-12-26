# Week 4 – Git & GitHub Advanced: Solution

This document records commands, rationale, and best practices for the advanced Git tasks. Username examples use `shashank-2310`; replace tokens like `<your-PAT>` as needed.

---

## Task 1: Pull Requests (PRs)

Commands used:

```bash
# Clone your fork
git clone https://github.com/shashank-2310/90DaysOfDevOps.git
cd 2025/git/02_Git_and_Github_Advanced

# Create a feature branch and commit
git checkout -b feature/pr-demo
echo "New Feature" >> feature.txt
git add feature.txt
git commit -m "Add feature.txt: initial feature"

# Push and open PR
git push -u origin feature/pr-demo
```

PR best practices:
- Clear title: action + scope (e.g., "Add API contract for orders").
- Concise description: what, why, how; link issues/tickets; screenshot/logs where useful.
- Small, focused changes; keep PRs under ~300 lines when possible.
- Checklist: tests added/updated, docs updated, breaking changes noted, release notes needed?
- Labels, reviewers, and assignees set appropriately.

Handling review comments:
- Respond to every comment; push incremental commits or amend/squash if agreed.
- Prefer code changes over debate; add clarifying comments near complex code.
- Re-request review after addressing feedback; keep CI green.

---

## Task 2: Reset vs Revert

Commands used:

```bash
# Create an intentional bad commit
echo "Wrong code" >> wrong.txt
git add wrong.txt
git commit -m "Committed by mistake"

# Undo scenarios
# 1) Soft reset: move HEAD back, keep index (staged)
git reset --soft HEAD~1

# 2) Mixed reset: move HEAD back, unstage, keep working tree (default)
git reset --mixed HEAD~1

# 3) Hard reset: move HEAD back, drop index and working tree changes
git reset --hard HEAD~1

# 4) Revert: create a new commit that undoes a specific commit (safe for shared branches)
git revert <commit-hash-or-HEAD>
```

Key differences:
- `reset` rewrites history by moving `HEAD` (and possibly index/worktree). Use locally before pushing.
- `revert` writes a new commit that negates a prior commit. Use on shared branches to avoid history rewrites.
- Use `--hard` with caution; data can be lost (recover via `git reflog` if needed).

When to use:
- Use `reset` for local cleanup before publish; use `revert` for public corrections after publish.

---

## Task 3: Stashing

Commands used:

```bash
# Make uncommitted work
echo "Temporary Change" >> temp.txt
git add temp.txt

# Save work-in-progress
git stash push -m "WIP: temp changes"

# Switch and restore later
git checkout main
# Apply and remove the top stash
git stash pop
# Or apply without removing from stash list
git stash apply

# List and inspect stashes
git stash list
git stash show -p stash@{0}
```

Notes:
- Use stash to quickly park changes before switching context.
- `pop` applies and drops; `apply` applies but keeps the stash for reuse.
- Stashes are local; consider a WIP branch for longer work.

---

## Task 4: Cherry-picking

Commands used:

```bash
# Find the commit to cherry-pick
git log --oneline

# Apply a specific commit to current branch
git cherry-pick <commit-hash>

# If conflicts arise
git status
# resolve files, then
git add <resolved-files>
git cherry-pick --continue
```

Usage and risks:
- Great for porting a targeted bugfix across branches without merging full history.
- Risks: duplicate history, conflict storms if used excessively, harder to track lineage.
- Prefer backport branches or shared fix branches when multiple commits are related.

---

## Task 5: Rebasing for a Clean History

Commands used:

```bash
# Update your local view of main
git fetch origin main

# Rebase current branch on top of latest main
git rebase origin/main

# Resolve conflicts then continue
git add <resolved-files>
git rebase --continue

# If needed, abort and return to pre-rebase state
git rebase --abort

# After a rebase on a published branch, force-push safely
git push --force-with-lease
```

Merge vs Rebase:
- `merge`: preserves true history, creates merge commits, simpler for shared work.
- `rebase`: linearizes history, easier to follow `git log`, but rewrites commits.

Best practices:
- Do not rebase shared/public branches unless team agrees; if you must, use `--force-with-lease`.
- Use interactive rebase (`git rebase -i`) to squash fixups before PR.
- Prefer `git pull --rebase` to avoid needless merge commits in feature branches.

---

## Task 6: Branching Strategies

Strategies and trade-offs:
- Git Flow: feature/release/hotfix branches. Pros: structured releases; Cons: heavy, slower—less ideal for continuous delivery.
- GitHub Flow: main + short-lived feature branches + PRs. Pros: simple, great for CI/CD; Cons: fewer long-running release branches.
- Trunk-Based Development: frequent small merges to main, feature flags. Pros: maximizes flow and CI; Cons: requires robust testing/flags.

Best for DevOps/CI/CD:
- Trunk-Based or GitHub Flow with short-lived branches and mandatory PR checks typically performs best.

Simulation commands:

```bash
# Example short-lived feature/hotfix flow
git checkout -b feature/payment-validation
# ... changes ...
git commit -m "Validate card number format"
git push -u origin feature/payment-validation
# open PR, review, merge

git checkout -b hotfix/null-pointer
# ... critical fix ...
git commit -m "Hotfix: guard against null pointer"
git push -u origin hotfix/null-pointer
# open PR and fast-track
```

---

## Extras and Good Practices

- Use signed commits (GPG/SSH) for provenance; enable "Require signed commits" in protected branches.
- Protect `main`/`master`: require PR, status checks, reviews, and linear history if desired.
- Use templates: PR and Issue templates improve consistency.
- Use `git bisect` to locate regressions efficiently in larger histories.

---

## Submission Steps

```bash
# From the repo root or current folder
git add .
git commit -m "Complete Git & GitHub Advanced Challenge"
# Your default branch may be main or master; push accordingly
git push origin main || git push origin master
```

Open a PR with title:

```
Git & GitHub Advanced Challenge - Completed
```

PR description:
- Steps followed for each task, key commands, and outcomes.
- Any screenshots/logs if applicable.
- Notes on strategy choice for CI/CD.

---

## Quick Reference

```bash
# Reset vs revert
git reset --soft|--mixed|--hard <ref>
git revert <commit>

# Stash
git stash push -m "msg"
git stash list | show -p
git stash pop | apply

# Cherry-pick
git cherry-pick <hash>

# Rebase
git fetch origin main
git rebase origin/main
git rebase -i origin/main

# Safe force push after history edits
git push --force-with-lease
```

---

## Links
- Git docs: https://git-scm.com/doc
- Reset & Revert: https://www.atlassian.com/git/tutorials/resetting-checking-out-and-reverting
- Stash: https://git-scm.com/book/en/v2/Git-Tools-Stashing-and-Cleaning
- Cherry-pick: https://www.atlassian.com/git/tutorials/cherry-pick
- Branching strategies: https://www.atlassian.com/git/tutorials/comparing-workflows
