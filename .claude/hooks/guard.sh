#!/usr/bin/env bash
# PreToolUse hook that enforces the rules in AGENTS.md.
# Best effort: the written rules apply even where this script can't catch something.
set -euo pipefail

input="$(cat)"
tool="$(jq -r '.tool_name // ""' <<<"$input")"
root="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel)}"

block() {
	echo "Blocked by AGENTS.md: $1" >&2
	exit 2
}

has() { grep -Eq -- "$1" <<<"$2"; }

# Build manifests and IDE settings count as environment, not problem code.
manifest='(^|/)(\.idea|\.vscode)/|(^|/)(\.gitignore|\.ocamlformat|dune|dune-project|go\.(mod|sum)|Cargo\.(toml|lock)|package(-lock)?\.json|package\.yaml|stack\.yaml|tsconfig\.json|deno\.json|[^/]+\.(sln|fsproj|csproj|opam|cabal))$'
inputfile='(^|/)(input[^/]*|test\.[^/]+)$'
cookie='\.adventofcode\.session|ADVENT_OF_CODE_SESSION'

relpath() {
	local p="$1"
	p="${p#"$root"/}"
	echo "${p#./}"
}

is_problem() {
	local rel
	rel="$(relpath "$1")"
	has '^(src|shared)/' "$rel" && ! has "$manifest" "$rel"
}

check_bash() {
	local cmd="$1"

	has 'adventofcode\.com' "$cmd" &&
		block "interact with Advent of Code only through the approved tools, never directly."
	has "$cookie" "$cmd" &&
		block "never read the Advent of Code session cookie."

	# aoc-cli: only `aoc download --input-only`, as a single command.
	if has '(^|[[:space:];&|/])aoc([[:space:]]|$)' "$cmd"; then
		if has '^[[:space:]]*([^[:space:]]*/)?aoc[[:space:]]+(download|d)([[:space:]]|$)' "$cmd" &&
			has '[[:space:]](--input-only|-I)([[:space:]]|$)' "$cmd" &&
			! has '[;&|<>`]|\$\(|--puzzle-file|-p[[:space:]]' "$cmd"; then
			exit 0
		fi
		block "the only approved aoc command is \`aoc download --input-only\`."
	fi

	has '(^|[[:space:]/<'"'"'"])(input([.0-9_-][^[:space:]/'"'"'";|&)]*)?|test\.[[:alnum:]]+)([[:space:]'"'"'";|&)]|$)' "$cmd" &&
		block "never open puzzle inputs or run solutions against them."

	has '(^|[[:space:];&|])(nix[[:space:]]+fmt|treefmt|dune[[:space:]]+(fmt|build[[:space:]]+@fmt)|dotnet[[:space:]]+format|ocamlformat|fantomas|gofmt|go[[:space:]]+fmt|cargo[[:space:]]+fmt|rustfmt|ormolu|fourmolu|prettier)([[:space:]]|$)' "$cmd" &&
		block "never run formatters, they rewrite problem code."

	# Shell writes into problem code. `git mv` is allowed.
	local stripped="${cmd//git mv/git_mv}"
	if has '(^|[[:space:]'"'"'"=])(\./)?(src|shared)/' "$stripped"; then
		has '>[[:space:]]*[^[:space:]]*(src|shared)/' "$stripped" &&
			block "never write into src/ or shared/ from the shell."
		has '(^|[[:space:];&|])(sed|perl|ruby)[[:space:]].*-i' "$stripped" &&
			block "never edit problem code in place."
		has '(^|[[:space:];&|])(tee|cp|rm|mv|truncate|dd|install|rsync|touch|ln|patch|unlink|shred)[[:space:]]' "$stripped" &&
			block "only \`git mv\` may touch problem code from the shell."
		has 'git[[:space:]]+(checkout|restore|reset|stash|apply|am|clean|rm)[[:space:]]' "$stripped" &&
			block "never change problem code through git, other than \`git mv\`."
	fi
	return 0
}

case "$tool" in
Edit | Write | MultiEdit | NotebookEdit)
	path="$(jq -r '.tool_input.file_path // .tool_input.notebook_path // ""' <<<"$input")"
	is_problem "$path" && block "AI must not create or edit problem code ($(relpath "$path"))."
	;;
Read)
	path="$(jq -r '.tool_input.file_path // ""' <<<"$input")"
	has "$inputfile" "$path" && block "never open puzzle inputs."
	has "$cookie" "$path" && block "never read the Advent of Code session cookie."
	;;
Grep)
	target="$(jq -r '[.tool_input.path, .tool_input.glob] | map(select(. != null)) | join(" ")' <<<"$input")"
	has '(^|/|[[:space:]])(input|test\.)' "$target" && block "never search puzzle inputs."
	;;
WebFetch | WebSearch)
	jq -r '.tool_input.url // .tool_input.query // ""' <<<"$input" | grep -Eq 'adventofcode\.com' &&
		block "interact with Advent of Code only through the approved tools, never directly."
	;;
Bash)
	check_bash "$(jq -r '.tool_input.command // ""' <<<"$input")"
	;;
esac

exit 0
