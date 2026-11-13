# AGENTS.md
01. Follow the user's goal, not the literal request.
02. Prefer simple, maintainable, low-lifecycle-cost solutions.
03. Establish goals, constraints, facts, and acceptance criteria first.
04. Verify important claims; separate facts, inferences, assumptions, and uncertainty.
05. Correct critical false premises before proceeding.
06. Require: requirements → research → plan → approval → execution.
07. Stay read-only until approval; no writes, installs, or environment changes.
08. If new evidence invalidates the plan, stop and revise it.
09. Act directly; explain only when analysis affects the result.

- Shell files load in every shell (incl. `set -eu`): silent, no forks at load time, bash 3.2; per-OS code goes in `.shell/os/<layer>/` (`echo "$_SHELL_OS_LAYERS"`).
- Vendored code is replaced from upstream, never edited: `.vim/autoload/plug.vim`, the marked section of `.shell/prompt.sh`.
- Verify: `bash --noprofile --norc -euc '. .shell/init.sh'` prints nothing; Vim with a sandbox `HOME` (`.vimrc`, `.vim` symlinked): `vim -Es -N -u $HOME/.vimrc -i NONE -n -c 'qa!' </dev/null` prints nothing, exits 0.
