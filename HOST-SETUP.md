# Host setup for the IDz on VS Code class

Instructor-facing checklist for preparing the training LPAR and each
student id. Replace the tokens everywhere they appear:

| Token | Meaning |
|-------|---------|
| `<HOSTNAME>` | Training LPAR host name |
| `<TSOID>` | Student TSO user id |
| `<ACCOUNT>` | TSO account number for the class |
| `<DEBUG-PROFILE-SERVICE-PORT>` | Debug Profile Service port (default 8143) |

The Git modules need one more piece of preparation, on the Git side rather
than the host: the customer's fork of the class materials, referred to as
`<CLASS-REPO-URL>`. See `CLASS-REPO-SETUP.md`.

## 1. Connection endpoints

At least one of (both preferred — the labs teach both profile types):

- **z/OSMF** reachable over HTTPS (default port 443).
- **RSE API** server (required for the licensed advanced-capability
  modules: `zos-resources-view`, `remote-connection-emulator`, activation
  by server). Default port 6800.
- TN3270 port for the Remote Connection Emulator module.

Update `config/zowe.config.json` with the real host and ports; students
copy it during the `zowe-connection` lab and store credentials in the
secure credential store.

## 2. Per-student data sets

Allocate (or let the `mvs-datasets` lab allocate) per student:

| Data set | DCB | Purpose |
|----------|-----|---------|
| `<TSOID>.CLASS.COBOL` | PDS-E, FB 80 | COBOL programs |
| `<TSOID>.CLASS.COPYLIB` | PDS-E, FB 80 | Copybooks |
| `<TSOID>.CLASS.JCL` | PDS-E, FB 80 | Compile/run JCL |
| `<TSOID>.CLASS.REXX` | PDS-E, FB 80 | REXX execs |
| `<TSOID>.CLASS.LOAD` | PDS-E, U | Load modules |

The `mvs-datasets` lab uploads `src/cobol|copy|jcl|rexx` into
these data sets with Zowe Explorer. `src/data/*.tdat` are sample
fixed-length records that `editor-configuration` opens in the Line Hex
Editor; they stay on the workstation. None of the run or debug labs reads a
data set: `EBUD00` takes its input as a PARM (`src/jcl/EBUDRUN.jcl`).

## 3. Compile/link and run

- The labs compile with two jobs that use the Enterprise COBOL `IGYWCL`
  procedure: `src/jcl/COBCOMP.jcl` (one program - `COBLOAN` in the
  remote compile lab) and `src/jcl/EBUDCMP.jcl` (`EBUD00`-`EBUD03` for the
  debugger and coverage labs, which also needs `CEE.SCEESAMP`). Check both
  names against your site before the class, and that each student has a
  `<TSOID>.CLASS.LOAD` PDS-E.
- `COMPILE.jcl` (a C++ compile) and `SAMCMPLK.jcl` (another site's COBOL
  compile) are editing material for the JCL editor labs. They are not
  meant to be submitted as they stand.
- COBOL 6.x compiler available; debug labs need `TEST(...)` options (see
  `config/debug/README.md`).

## 4. Optional host components (module-by-module)

| Module | Needs |
|--------|-------|
| `cobol-user-build` | DBB toolkit + USS sandbox (`config/userbuild/README.md`) |
| `debug-profiles`, `cobol-debug-fundamentals` | z/OS Debugger + Debug Profile Service |
| `code-coverage` | IBM Compiled Code Coverage |
| `zcodescan` | ZCodeScan rule sets / entitlement |
| `agent-mode` | Agent Mode / AI entitlement |
| `zos-resources-view`, `remote-connection-emulator` | RSE API server + IDzEE activation |

## 5. Validation dry run

Before the first delivery, walk one student id through:
`zowe-connection` → `mvs-datasets` (upload) → `jes-jobs`
(`JESDEMO.jcl`) → `cobol-remote-compile` (`COBLOAN.cbl`) →
`cobol-debug-fundamentals` (`EBUD00`). All other labs depend only on
these paths plus the local workspace.
