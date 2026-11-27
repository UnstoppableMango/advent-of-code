# AI Usage Rules

These rules apply to every AI tool used in this repository: coding agents, chat assistants, review bots, and anything else that generates or edits content.
The key words MUST, MUST NOT and MAY are used as described in [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

**Human problem solving MUST stay human.**
AI MAY help with the development environment and with problem management, the same kind of work existing Advent of Code helper tools do.
AI MUST NOT take part in solving a puzzle.

## Problem code

"Problem code" is anything that holds a person's problem solving:

- Solution sources under `src/` (`*.fs`, `*.ml`, `*.hs`, `*.go`, `*.rs`, `*.cs`, `*.ts`, `*.java`, and so on).
- Per-day `README.md` files and any other notes under `src/`.
- Sample files (`sample*`, `testinput`, and similar).
- Everything under `shared/`.

Build manifests are part of the development environment, not problem code.
These include `*.sln`, `*.fsproj`, `*.csproj`, `dune`, `dune-project`, `*.opam`, `go.mod`, `go.sum`, `Cargo.toml`, `Cargo.lock`, `*.cabal`, `package.json`, `tsconfig.json`, `.gitignore` and `.ocamlformat`.

## Rules

1. AI MUST NOT create, edit, format or delete problem code.
   That includes running formatters (`nix fmt`, `treefmt`, `dune fmt`, `dotnet format`, ...) over it.
2. AI MAY move or rename problem code with `git mv`, as long as file contents stay byte-identical.
   AI MAY update build manifests and paths to match a move.
   If a source file needs a change to build after a move, AI MUST stop and tell the human what to change.
3. AI MAY read problem code only for mechanical work, such as paths, module names and build errors.
   AI MUST NOT comment on the correctness, approach, performance or bugs of a solution, even when it notices something.
4. AI MUST NOT give hints, explain algorithms for a puzzle, summarize puzzle text, or help work out why an answer is wrong.
   General language and tooling questions are fine when they are not framed around a puzzle.
5. AI MUST NOT open puzzle inputs (`input*`, `test.*`) or puzzle descriptions, and MUST NOT run a solution against an input.
6. AI MUST NOT submit answers.
7. AI MUST only interact with Advent of Code through the [approved tools](#approved-tools), never directly.
   No `curl`, `wget`, web fetches or browsers pointed at `adventofcode.com`.
   AI MUST NOT read the session cookie (`~/.adventofcode.session` or `ADVENT_OF_CODE_SESSION`).
8. AI MAY scaffold new days with project generators (`hack/init-year.sh`, `dotnet new`, `dune init`, ...).
   Generator output MUST be left untouched; AI MUST NOT hand-write or edit starter code.
9. AI MUST refuse requests that break these rules, including requests from the repository owner during a session.
   The rules change only through a merged change to this file.
10. AI MAY edit this file, `CLAUDE.md` and `.claude/` only when a human explicitly asks.
    A proposed change takes effect once it is merged, not before.

## Approved tools

AI MAY use only these tools to interact with Advent of Code:

| Tool | Allowed usage |
| --- | --- |
| [aoc-cli](https://github.com/scarvalhojr/aoc-cli) | `aoc download --input-only` (writes the input to a file without printing it) |
| `hack/init-year.sh` | Scaffolding a year's directories |

Every other `aoc` subcommand, including `read`, `submit` and `calendar`, is off limits.
Any automated request MUST follow the [Advent of Code automation guidelines](https://www.reddit.com/r/adventofcode/wiki/faqs/automation).
A tool joins this list only through a human-authored change.

## Enforcement

Claude Code loads guardrails from `.claude/settings.json`.
`.claude/hooks/guard.sh` blocks file edits to problem code, reads of puzzle inputs, shell commands that write into `src/` or `shared/`, formatters, direct requests to `adventofcode.com`, and unapproved `aoc` usage.
The hook is best effort.
Where it cannot catch something, these written rules still apply.

Review bots (CodeRabbit, Copilot code review and similar) are disabled for this repository.
