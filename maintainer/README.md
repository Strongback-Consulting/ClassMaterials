# Maintainer tooling (Strongback only)

These scripts do nothing useful in a fork: they push to Strongback's public
repository, which only Strongback-Consulting organisation owners can write to.
If you forked this repository for a class, you can ignore this folder.

## The model

- A **private source repository** is where Strongback edits. It holds exactly
  this tree.
- The **public** `Strongback-Consulting/ClassMaterials` is written only by
  `publish.sh`, **run by an organisation owner** with their own GitHub
  credentials. No team or member has write access to it, and its rulesets
  block force-push, deletion and direct pushes for everyone but owners.
  Deploy keys are switched off for the organisation, deliberately, so there
  is no separate publish key to look after.
- Only the refs in the allowlist are ever published:

  | Ref | Why |
  |-----|-----|
  | `main` | every lab |
  | `develop` | GitDbb `user-build` clones it |
  | `release` | GitDbb `pull-push` merges into it |
  | tag `class-start` | the as-delivered point the VS Code labs reset to |

  Anything else pushed to the private repository — work-in-progress branches,
  experiments — stays private.

## Publishing a change

1. Commit to the private repository with a **role identity**, not your own
   address. The public history must not carry personal email addresses, and
   `publish.sh` refuses to run if it finds one:

   ```sh
   git config user.name  "Strongback Training"
   git config user.email "training@example.invalid"
   ```

   GitHub `…@users.noreply.github.com` addresses are also accepted.

2. Push to the private repository as usual.
3. Fold your commit into "As delivered", so `main` stays the three teaching
   commits the labs read (`class-start`, then two maintenance commits):

   ```sh
   maintainer/rebuild-history.sh          # rebuild and verify only
   maintainer/rebuild-history.sh --push   # replace the private history
   ```

   It refuses unless the rebuilt `main` has exactly today's files. Without
   it, Strongback's change would appear in the labs' `class-start..main`
   history as if it were class work.
4. Take a backup, run the check, then publish:

   ```sh
   maintainer/backup.sh <backup-folder>
   maintainer/check-public.sh      # what would change
   maintainer/publish.sh --dry-run
   maintainer/publish.sh
   ```

`publish.sh` refuses to publish if any published ref carries a GitHub
workflow, a `.DS_Store`, a token, a private key, an internal host name or a
personal email address — in the tree **or anywhere in its history**.

## Restoring the public repository

If the public copy has been damaged — a mistaken push by an owner, a
compromised key, refs that should not be there:

1. **If the cause is spam** (issues are off, but pull requests and comments
   cannot be), set a temporary interaction limit: **Settings → Moderation
   options → Interaction limits**.
2. Run `maintainer/check-public.sh` to see what differs.
3. Run `maintainer/publish.sh`. It force-pushes every allowlisted ref back to
   the private repository's state and deletes any other branch or tag on the
   public copy. It is the same command as a normal publish.
4. Run `maintainer/check-public.sh` again; it must report no drift.
5. **If a credential was involved**, it was an owner's: have that owner
   revoke their GitHub tokens and SSH keys and sign out other sessions, then
   review the organisation's audit log for anything else it was used for.

**If the private repository is damaged too**, restore it first from the
backup kept outside GitHub (below), then publish from that.

## Backups outside GitHub

Both repositories live in one GitHub organisation, so a problem with the
organisation itself - a compromised owner account, a mistaken deletion - can
reach both. `backup.sh` keeps a copy GitHub cannot touch. Run it from a clone of
the private source repository, pointing at storage outside GitHub:

```sh
maintainer/backup.sh /Volumes/Backups/ClassMaterials
```

Each run refreshes a bare mirror (`class-materials.git`), writes a dated
single-file bundle under `bundles/`, keeps the newest 12
(`CLASSMATERIALS_BACKUP_KEEP` changes that), and checks both against the
private repository before reporting success. A bundle is one ordinary file,
so it can be copied to any storage and restored without the mirror.

**Restoring the private repository**, from the newest bundle:

1. Create a new, empty, private repository in the organisation.
2. Push every branch and tag from the bundle into it:

   ```sh
   git clone --mirror <backup-folder>/bundles/<newest>.bundle restore.git
   cd restore.git
   git push --mirror <new-private-repository-url>
   ```

3. Re-grant the `class-materials-maintainers` team write access, then clone
   it and run `maintainer/check-public.sh` and `maintainer/publish.sh` as for
   any restore.

Customers' forks and mirrors are independent copies. Nothing here touches
them, and nothing that happens to the public repository reaches them.

## Settings the public repository relies on

These are not in the tree, so they are listed here to re-apply if the
repository is ever recreated:

- Issues, Wiki, Projects and Discussions: **off**. Actions: **disabled**.
- Secret scanning and push protection: **on**.
- Ruleset on `main`, `develop`, `release`: block force pushes, block deletion,
  require a pull request. Ruleset on tags `*`: block updates and deletion.
  Bypass: organisation owners only. (The rulesets also list deploy keys as a
  bypass actor; that is inert while the organisation keeps deploy keys off.)
- No team or member has write access. Not a template repository — templates
  drop the history the labs read.
