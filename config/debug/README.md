# IBM Z Open Debug configuration notes

The debug modules (`debug-profiles`, `cobol-debug-fundamentals`,
`code-coverage`) need z/OS Debugger host components.

## Host prerequisites (instructor / sysprog)

- z/OS Debugger installed and licensed (part of IDzEE / ADFz).
- **Debug Profile Service** started task up and reachable
  (default port 8143; record the real value in HOST-SETUP.md).
- Programs compiled with debug options: `TEST(...)` plus
  `LIST,MAP,XREF,SOURCE` — the class compile JCL
  (`src/jcl/COMPILE.jcl`) already carries them for the
  EBUD/WARDRPT lab programs.
- For code coverage: IBM Compiled Code Coverage feature enabled.

## Student-side settings (taught in the debug-profiles lab)

- VS Code settings: `zopendebug.connection.serverUrl` =
  `https://<HOSTNAME>:<DEBUG-PROFILE-SERVICE-PORT>`.
- The **Debug Profiles** view (IBM Z Open Debug) is where profiles are
  created and activated; launching uses the standard VS Code Run and
  Debug panel.
- Batch labs launch `EBUD00` under the debugger via the profile +
  submitted JCL; the profile's load-module and program masks must match
  `EBUD*`.

Full documentation: search "Remote debugging with IBM Z Open Debug" in the
IBM Developer for z/OS 17.0.x documentation.
