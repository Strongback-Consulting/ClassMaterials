# Class repository setup

The Git modules (`git-repositories` through `git-zos-workflow`) work in a real Git
repository. In a normal delivery the customer forks Strongback's class
materials into their own Git provider before training, and each student
clones that fork.

| Token | Meaning |
|-------|---------|
| `<CLASS-REPO-URL>` | The customer's fork of the class materials — the URL students clone. Your instructor gives you this. |

Upstream, maintained by Strongback:

```
https://github.com/Strongback-Consulting/ClassMaterials.git
```

---

## For students

### 1. Clone the class repository

Your instructor will give you `<CLASS-REPO-URL>`. In VS Code, open the
Command Palette (`Ctrl+Shift+P`, macOS `Cmd+Shift+P`) and run **Git: Clone**,
paste the URL, and choose a folder to clone into. Or from a terminal:

```sh
git clone <CLASS-REPO-URL> ClassMaterials
```

Cloning gives you the full history, and `origin` is already configured — the
`git-remotes-sync` module builds on that.

### 2. Open the workspace

Open `ClassMaterials.code-workspace` from the clone. The **Source Control**
view now shows your repository.

### 3. Set your identity

Only needed once per machine, and the `git-repositories` lab walks it:

```sh
git config user.name  "Your Name"
git config user.email "you@your-company.com"
```

> **Do not put the clone inside another Git repository.** A repository nested
> in another confuses the Source Control view. If you unpack ClassMaterials
> inside a checkout of something else, move it out first.

### If your class has no forked repository

Some deliveries have no reachable Git provider — an air-gapped room, or a
customer whose fork is not ready. In that case, work from the shipped
`ClassMaterials` folder and build the repository locally:

**Windows (PowerShell):**

```powershell
cd C:\Workshop\ClassMaterials
.\git-bootstrap.ps1
```

If PowerShell refuses to run it: `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass`

**macOS / Linux:**

```sh
cd ~/Workshop/ClassMaterials
chmod +x git-bootstrap.sh
./git-bootstrap.sh
```

This produces the same starting point a clone would have: branch `main`, an
as-delivered commit tagged `class-start`, and two maintenance commits to read.
Everything through `git-history-recovery` then works normally. The two
remote-facing modules (`git-remotes-sync`, `git-collaboration`) run as
instructor demonstrations instead — every lab task in them states its offline
fallback.

---

## For the instructor and the account team

### Before the engagement: fork the materials

1. Fork `https://github.com/Strongback-Consulting/ClassMaterials.git` into the
   customer's provider — GitHub, GitHub Enterprise, GitLab, Bitbucket or
   Azure DevOps. A mirror-push works equally well where forking across
   providers is not supported:

   ```sh
   git clone --bare https://github.com/Strongback-Consulting/ClassMaterials.git
   cd ClassMaterials.git
   git push --mirror <CLASS-REPO-URL>
   ```

2. Decide the repository shape:
   - **One repository per student** (`class-<tsoid>`) is simplest and lets
     everyone push to `main` freely.
   - **One shared repository, a branch per student** makes the pull-request
     lab in `git-collaboration` far more realistic. Protect `main` if you
     take this route, so pull requests are actually required.

3. **Confirm the teaching history is present.** The labs read it: an
   as-delivered commit tagged `class-start`, then two maintenance commits on
   `src/cobol/SANDBOX.cbl` by two different authors. `git-history-recovery`
   is built entirely on those, and Blame is far less convincing without them.

   ```sh
   git log --oneline --decorate
   ```

   If they are missing, clone the fork, add them and push:

   ```sh
   git clone <CLASS-REPO-URL> ClassMaterials
   cd ClassMaterials
   ./git-bootstrap.sh --seed-existing      # or .\git-bootstrap.ps1 -SeedExisting
   git push origin main --tags
   ```

   The script is idempotent — it does nothing if the history is already there.

4. Decide how students authenticate, and be ready to walk it:
   - **GitHub** — VS Code's built-in account sign-in is easiest.
   - **GitLab / Bitbucket / Azure DevOps** — a personal access token entered
     at the credential prompt. Know the exact scope needed
     (`write_repository` or the equivalent). `GitDbb`'s four token modules
     carry the per-platform screenshots if you want to project them.

5. **Check the classroom network reaches the provider.** Corporate guest
   Wi-Fi frequently blocks it. Find out before the day, not during it.

### Give the students

- `<CLASS-REPO-URL>` — the clone URL, or the URL pattern if one repo each.
- The authentication method, and any token scopes.
- Whether `main` is protected, and the branch naming convention.

### Two files worth reading with the class

- **`.gitignore`** — what stays out of the repository and why. The
  `git-collaboration` module walks it.
- **`.gitattributes`** — how Git treats z/OS source when a Windows
  workstation, a macOS workstation and an EBCDIC host all touch the same
  file. The `git-zos-workflow` module walks it.

Many delivered samples carry Windows line endings, which `.gitattributes`
normalises. That is expected, and it happens once.

---

## Starting over

Delete your clone and clone again. If you built the repository locally with
the bootstrap instead, delete the `.git` folder and re-run the script — you
lose your own commits and get the delivered state back.
