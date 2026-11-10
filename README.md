# ClassMaterials

> **Which repository is this?** `Strongback-Consulting/ClassMaterials` is the
> **public** copy that classes clone and customers fork. Strongback maintains it
> from a private source repository and publishes to it with
> [`maintainer/publish.sh`](maintainer/README.md); nobody commits to the public
> copy directly, so a pull request here will not be merged.

Sample source and workspace for Strongback Consulting's IBM Developer for z/OS
courses — the same folder serves both clients:

| Course | Client | How you open it |
|--------|--------|-----------------|
| IDz on VS Code | VS Code with IBM Z Open Editor | Open `ClassMaterials.code-workspace` |
| IDz (Eclipse) | IBM Developer for z/OS | **File → Import → Existing Projects into Workspace**, select this folder — the project is named **ClassMaterials** |
| Git and DBB with IDz | IBM Developer for z/OS + EGit | Clone in the Git Repositories view, then import the **ClassMaterials** project |

## Getting a copy for your class

Your Strongback instructor will usually have arranged this before the class.
In short:

- **GitHub** — fork this repository into your organisation.
- **GitHub Enterprise, GitLab, Bitbucket or Azure DevOps** — mirror it:

  ```sh
  git clone --bare https://github.com/Strongback-Consulting/ClassMaterials.git
  cd ClassMaterials.git
  git push --mirror <YOUR-NEW-EMPTY-REPOSITORY-URL>
  ```

- **No Git provider at all** — download the ZIP (**Code → Download ZIP**) and
  run `git-bootstrap.sh` (macOS/Linux) or `git-bootstrap.ps1` (Windows) inside
  it to build the same starting history locally.

Fork or mirror rather than copy the files: the labs read this repository's
history, so a copy without it will not work. The full instructions, for
students and for whoever prepares your fork, are in
[`CLASS-REPO-SETUP.md`](CLASS-REPO-SETUP.md).

## What the history contains

| Ref | Used by |
|-----|---------|
| `main` | Every lab. Ends with two maintenance commits on `src/cobol/SANDBOX.cbl` that the history and blame labs read. |
| tag `class-start` | The as-delivered state — the point "start over" returns to. |
| `release` | Git and DBB: the branch the pull/push lab merges into. Starts at `class-start`. |
| `develop` | Git and DBB: the branch the user-build lab clones. |

## Layout

```
ClassMaterials.code-workspace   VS Code workspace (settings, recommended extensions)
zapp.yaml                       Z Open Editor property groups (copybook resolution)
.project  .settings/  …         IDz Eclipse project definition
.gitattributes  .gitignore      how git treats z/OS source; what stays out — both are taught
CLASS-REPO-SETUP.md             forking, mirroring and the offline fallback
HOST-SETUP.md                   what the z/OS side of a class needs
LICENSE                         MIT
MANIFEST.md                     every sample member, its language and target data set
config/                         Zowe, debug and user-build templates (placeholders only)
git-bootstrap.sh / .ps1         build the teaching history without a Git provider
src/<language>/                 the sample source
maintainer/                     Strongback-only publishing and restore tooling
```

Connection templates under `config/` carry `<HOSTNAME>`, `<TSOID>` and
`<ACCOUNT>` placeholders. Never commit them filled in — `.gitignore` explains
how Zowe keeps your own values out of the repository.

## License

Released under the [MIT License](LICENSE).

A few sample programs were written by others and carry their authors' own
notices in their header comments — the IBM-authored samples, for example.
Those notices still apply to those files.
