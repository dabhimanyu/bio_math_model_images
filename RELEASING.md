# RELEASING.md — My GitHub Release & Tagging CheckList

#### To Do checklist for the developer

My one-pager checklist to produce clean and reproducible releases (tags + GitHub releases) with zero surprises. Works from my macOS Terminal or MATLAB’s Git integration (for commit/push). Tagging and release creation are documented via Terminal and GitHub Web UI (with GitHub CLI as an option). Had to create this after comitting these blunders over and over again.

---

## 0) Prerequisites

* Git installed (macOS) or windows Terminal (Commonly pre-installed in Ubuntu).
* A clean working tree (no pending edits unless staged and committed).
* Optional: GitHub CLI (`gh`) if you prefer making releases from Terminal. (Since I do it sometimes)

**Check your repo and remote:**

```bash
cd /path/to/bio_math_model_images  # Use your patway here
git remote -v
```

**What this does**

* `cd /path/to/...` - Move into your repository directory.
* `git remote -v` - Shows remotes (e.g., `origin`) and their URLs to confirm you’re pushing to the correct GitHub repo.

---

## 1) Pre-flight Checks :)

**Ensure nothing uncommitted is lurking:**

```bash
git status
```

**What this does**

* `git status` - Lists staged/unstaged changes and untracked files to ensure a clean baseline.

**Set user identity (one time or when changing machines):**

```bash
git config user.name "Your Name"
git config user.email "you@example.com"
```

**What this does**

* `git config user.name` - Sets the author/committer display name.
* `git config user.email` - Sets the author/committer email recorded in commits.

---

## 2) Sync Your Main Branch (avoid divergence)
Ensure that you are on `main` branch.

```bash
git checkout main
git fetch origin
git pull --rebase origin main
```

**What this does**

* `git checkout main` - Switch to the `main` branch for release work.
* `git fetch origin` - Retrieves the latest refs/objects from the remote without integrating.
* `git pull --rebase origin main` - Replays your local commits (if any) on top of the remote `main`, preserving a linear history (cleaner than merge).

---

## 3) Decide What Goes Into the Release

* If you have **untracked artifacts** (large sample images, scratch output), keep them **untracked** or add to `.gitignore`.
* If you want **small samples versioned**, `git add` them thoughtfully (consider Git LFS for large binaries).

**Example: add typical MATLAB ignores**

```bash
printf "%s\n" \
"*.asv" \
"*.m~" \
"*.mat" \
".DS_Store" \
"Translate_and_Track_/OutPut_Directory_For_Translated_Images_/" \  # Or any directory that you wanrt to ignore
">> .gitignore
git add .gitignore
git commit -m "Adding .gitignore for MATLAB & local outputs"
```

**What this does**

* `printf ... >> .gitignore` - Appends common ignore patterns.
* `git add .gitignore` - Stages ignore changes.
* `git commit -m ...` - Records the ignore update in history.

*(Adjust ignores to your project reality; do not blindly ignore `.mat` if you actually want them versioned.)*

---

## 4) Identify the Target Commit for the Tag

**Inspect recent history to select the exact commit to tag:**

```bash
git log --oneline --decorate --graph -n 10
```

**What this does**

* `git log --oneline` - Compact commit list.
* `--decorate --graph` - Shows branch/tag decorations and ASCII graph.
* `-n 10` - Limits output to 10 recent commits.

If you’re tagging the **current** state, you can use `HEAD`. If tagging a previous commit, copy its **full or short SHA**.

---

## 5) Create an **`Annotated`** Tag

**Tag current HEAD (e.g., legacy pre-protocol):**

```bash
git tag -a v1.9-legacy -m "v1.9-legacy - pre-protocol snapshot (legacy baseline)"
```

**What this does**

* `git tag -a v1.9-legacy` - Creates an *annotated* tag named `v1.9-legacy` (preferred for releases).
* `-m "..."` - Attaches a readable message (appears on GitHub and in `git show`).

**Tag a specific older commit by hash (example):**

```bash
git tag -a v1.0 d8a945d5a2c2 -m "v1.0 - Code used in Heliyon 2024 (DOI: 10.1016/j.heliyon.2024.e38307)"
```

**What this does**

* Same as above, but pins the tag to an explicit commit SHA (use when tagging non-HEAD snapshots).

**Push the tag to GitHub:**

```bash
git push origin v1.9-legacy
```

**What this does**

* `git push origin v1.9-legacy` - Publishes the tag to the remote so GitHub can use it for a release.

**Verify the tag content:**

```bash
git show --stat v1.9-legacy
```

**What this does**

* `git show --stat v1.9-legacy` - Displays the tagged commit and a summary of files changed.

---

## 6) Create the GitHub Release

### A) GitHub Web UI

1. Open your repo → **Releases** → **Draft a new release**.
2. **Choose a tag** → select the existing tag (e.g., `v1.9-legacy`).
3. Title: e.g., `v1.9-legacy - Pre-Protocol Snapshot (Legacy)`.
4. Create your release notes.
5. For legacy/baselines, tick **Pre-release**.
6. **Publish release**.

### B) GitHub CLI (optional)

```bash
gh release create v1.9-legacy \
  --title "v1.9-legacy - Pre-Protocol Snapshot (Legacy)" \
  --notes "Legacy baseline prior to protocol refactor. MATLAB ≥ R2022; Image Processing Toolbox; Parallel optional; no GPU." \
  --prerelease
```

**What this does**

* `gh release create <tag>` - Creates a GitHub Release tied to that tag.
* `--title` - Sets a readable title.
* `--notes` - Inline notes; or `--notes-file path.md` to reuse a file.
* `--prerelease` - Marks as a pre-release.

---

## 7) Post-Release Checklist

* Stay on `main` **or** create a working branch for new work:

  ```bash
  git checkout -b protocol-refactor
  git push -u origin protocol-refactor
  ```

  **What this does**

  * `git checkout -b ...` - Creates and switches to a new branch for the protocol work.
  * `git push -u origin ...` - Pushes and sets upstream so future `git pull` and `git push` are simpler.

* Before every push: keep history linear and clean:

  ```bash
  git pull --rebase origin main
  git pull --rebase origin protocol-refactor # Do it one by one with all the relevent brances
  ```

  **What this does**

  * Replays your local commits atop the latest remote branch state, avoiding merge bubbles.

---

## 8) Troubleshooting

**“Your branch and 'origin/main' have diverged”**
Use rebase to linearize:

```bash
git checkout main
git fetch origin
git pull --rebase origin main
git push origin main
```

**Accidentally tagged the wrong commit**
*(Avoid rewriting public history if people already depend on the wrong tag.)* If safe to fix:

```bash
git tag -d v1.9-legacy
git push origin :refs/tags/v1.9-legacy
git tag -a v1.9-legacy <correct-commit-sha> -m "v1.9-legacy - corrected target"
git push origin v1.9-legacy
```

**What this does**

* `git tag -d` - Deletes the local tag.
* `git push origin :refs/tags/<tag>` - Deletes the remote tag.
* Recreate the tag on the correct commit, then push.

---

## 9) Versioning Points to Keep in mind 

* **Tags**: `vMAJOR.MINOR[-qualifier]` (e.g., `v1.9-legacy`, `v2.0-protocol`).
* **Pre-release** when the API or scripts may change.
* **Release notes**: include scope, system requirements, “How to Run”, and citation lines.

---

# Quick Reference - Full Command Sequence

> **Use this when you already know what you’re tagging and just need the sequence of commands.**
> Adjust tag names/commit SHAs as needed.

```bash
# 1) Go to repo & pre-flight
cd /path/to/bio_math_model_images
git status

# 2) Sync main branch
git checkout main
git fetch origin
git pull --rebase origin main

# 3) (Optional) Update .gitignore for local artifacts
# printf "%s\n" "*.asv" "*.m~" "*.mat" ".DS_Store" \
# "Translate_and_Track_/OutPut_Directory_For_Translated_Images_/" >> .gitignore
# git add .gitignore
# git commit -m "chore(repo): update .gitignore for MATLAB & local outputs"

# 4) Inspect history and pick commit
git log --oneline --decorate --graph -n 10

# 5) Create an annotated tag (current HEAD or specific SHA)
git tag -a v1.9-legacy -m "v1.9-legacy - pre-protocol snapshot (legacy baseline)"
# OR: git tag -a v1.0 d8a945d5a2c2 -m "v1.0 - Code used in Heliyon 2024 (DOI: 10.1016/j.heliyon.2024.e38307)"

# 6) Push the tag to GitHub
git push origin v1.9-legacy

# 7) Verify tag content
git show --stat v1.9-legacy

# 8) Create a GitHub Release
# Web UI: Releases -> Draft a new release -> Choose existing tag -> Publish
# OR GitHub CLI:
# gh release create v1.9-legacy \
#   --title "v1.9-legacy - Pre-Protocol Snapshot (Legacy)" \
#   --notes "Legacy baseline prior to protocol refactor. MATLAB ≥ R2022; Image Processing Toolbox; Parallel optional; no GPU." \
#   --prerelease

# 9) (Optional) Start protocol work on a fresh branch
# git checkout -b protocol-refactor
# git push -u origin protocol-refactor
```

---
# Done :) 
---
