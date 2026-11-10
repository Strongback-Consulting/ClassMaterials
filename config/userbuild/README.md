# IBM User Build (DBB) configuration notes

The `cobol-user-build` module needs IBM Dependency Based Build on the host.
The workspace `zapp.yaml` already carries the `zBuilder-userbuild` profile
(DBB v3 zBuilder lifecycle `user`).

## Host prerequisites (instructor / sysprog)

- DBB v2 or v3 toolkit installed; note `$DBB_HOME` (e.g. `/usr/lpp/dbb/v3r0`).
- A USS build sandbox per student, e.g. `/u/<TSOID>/dbb-build`.
- DBB v3 zBuilder: confirm `dbb build` works from a USS shell for a class id.
- Record the values in HOST-SETUP.md when validating the LPAR.

## Student-side settings (taught in the lab)

VS Code `settings.json` keys used by the lab:

```json
{
    "zopeneditor.userbuild.userSettings": {
        "dbbHlq": "<TSOID>.DBB",
        "dbbWorkspace": "/u/<TSOID>/dbb-build"
    }
}
```

- DBB v3 zBuilder also expects a `dbb-app.yaml` at the application root;
  the lab creates a minimal one next to the COBOL sources.
- Build output lands in the VS Code Problems view (advanced error
  reporting requires the IDzEE licence/activation).

Full documentation: search "User build with IBM Dependency Based Build" in
the IBM Developer for z/OS 17.0.x documentation.
