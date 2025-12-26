# Week 4 Challenge – Solution
This document captures the exact commands run and the reasoning behind key Git/GitHub workflows for the Week 4 challenge. Username is prefilled as `shashank-2310`; replace other placeholders (like `<your-PAT>`) with your details when executing.

---
## Repository Setup (Fork & Clone)

Commands used:

```bash
# Fork the upstream repo in GitHub UI, then clone your fork
git clone https://github.com/shashank-2310/90DaysOfDevOps.git
# Navigate to the challenge directory
cd 2025/git/01_Git_and_Github_Basics

Notes:
- Forking gives you your own copy to push to.
- Cloning pulls the repo locally so you can work and commit.

---
## Local Repo Init & Initial Commit

Commands used:

```bash
# Create challenge folder and enter it
mkdir week-4-challenge
cd week-4-challenge
# Initialize Git repository
git init
# Create the info file (example on Windows Git Bash / PowerShell)
echo "Your Name - brief introduction" > info.txt
# Stage and commit
git add info.txt
git commit -m "Initial commit: Add info.txt with introductory content"

Notes:
- `git init` starts tracking changes in this directory.
- A clear commit message explains what changed and why.

---
## Remote Configuration with PAT and Push/Pull

Commands used:

```bash
# Add or set the remote named origin with embedded PAT (exercise-only)
git remote add origin https://shashank-2310:<your-PAT>@github.com/shashank-2310/90DaysOfDevOps.git
# If origin already exists
git remote set-url origin https://shashank-2310:<your-PAT>@github.com/shashank-2310/90DaysOfDevOps.git
# Create/rename default branch to main if needed
git branch -M main
# Push and set upstream
git push -u origin main
# Verify pull works
git pull origin main

Notes:
- Embedding PAT is discouraged in production; use credential helpers or SSH instead.
- `-u` sets the upstream so future `git push`/`git pull` know the default remote branch.

---
## Explore Commit History

Commands used:

```bash
# Full log
git log
# Compact, visual overview
git log --oneline --graph --decorate --all
```

Record example (replace with yours):
- Example hash: `abc1234` – "Initial commit: Add info.txt with introductory content"

---
## Branching & Switching

Commands used:

```bash
# Create branch
git branch feature-update
# Switch to branch (preferred)
git switch feature-update
# Alternative
git checkout feature-update
# Edit file and commit
echo "Added more details to info.txt" >> info.txt
git add info.txt
git commit -m "Feature update: Enhance info.txt with additional details"
# Push the branch
git push origin feature-update

PR workflow:
- Open a Pull Request from `feature-update` to `main` on your fork.
- Request review and merge via GitHub UI.

Advanced (optional conflict simulation):

```bash
# From main, create experimental
git switch main
git branch experimental
git switch experimental
echo "Conflicting change" >> info.txt
git add info.txt
git commit -m "Experimental: conflicting change"

# Merge experimental into feature-update to simulate conflict
git switch feature-update
git merge experimental
# Resolve conflicts in info.txt, then
git add info.txt
git commit -m "Resolve merge conflict between feature-update and experimental"

---
## Why Branching Strategies Matter

- **Isolation of work:** Features, fixes, and experiments evolve independently without destabilizing `main`.
- **Parallel development:** Multiple contributors progress simultaneously without blocking each other.
- **Reduced merge conflicts:** Smaller, focused branches simplify diffs and integration.
- **Better code reviews:** Targeted PRs are easier to understand, review, and validate.
- **Clear release management:** Strategy (e.g., GitHub Flow, Git Flow, Trunk-Based) defines how changes ship predictably.

Recommended practices:
- Keep branches short-lived and focused on a single change.
- Rebase or sync regularly to minimize divergence.
- Use clear naming: `feature/<name>`, `fix/<ticket>`, `chore/<task>`.

---
## Bonus: SSH Authentication (Windows)

Commands used:

```bash
# Generate key (ed25519 recommended)
ssh-keygen -t ed25519 -C "<your-email>@example.com"
# Press Enter to accept default path, add a passphrase if desired

# Show and copy your public key
# PowerShell
type $env:USERPROFILE\.ssh\id_ed25519.pub
# Git Bash
cat ~/.ssh/id_ed25519.pub

# Add the public key in GitHub → Settings → SSH and GPG keys

# Switch remote to SSH
git remote set-url origin git@github.com:shashank-2310/90DaysOfDevOps.git

# Test push over SSH
git push origin feature-update
```

Notes:
- SSH avoids storing tokens in remotes and works well across machines.
- Ensure `ssh-agent` is running and your private key is loaded if prompted.

---
## Submission

- Push `feature-update` with the updated solution.
- Open a PR to `main` with title:

```
Week 4 Challenge - DevOps Batch 9: Git & GitHub Advanced Challenge
```

- In the PR description, summarize your process and list the commands used.
- Share your experience on LinkedIn with screenshots/logs and hashtags:
	`#90DaysOfDevOps #GitGithub #DevOps`.

---
## Quick Reference (Cheat Sheet)

```bash
# Create/switch
git branch <name>
git switch <name>

# Stage/commit/push
git add <file>
git commit -m "Message"
git push -u origin <branch>

# Logs
git log --oneline --graph --decorate --all

# Remotes
git remote -v
git remote set-url origin <url>
```

---
## Checklist

- [x] Forked and cloned repository
- [x] Initialized local repo and committed `info.txt`
- [x] Configured remote and pushed `main`
- [x] Created `feature-update`, updated `info.txt`, and pushed branch
- [x] Documented branching strategy rationale
- [x] (Bonus) Generated SSH key, configured GitHub SSH, and tested push
