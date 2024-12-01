#!/bin/bash
set -eum

root="$(git rev-parse --show-toplevel)"
# year="$(date '+%Y')"
year="${YEAR:-$(date '+%Y')}"
langs=(
	fsharp
	csharp
	haskell
	rust
	ocaml
	typescript
	go
	elixir
	java
	scala
	julia
)

for day in $(seq -f "%02g" 1 25); do
	echo "Creating $year Day$day..."
	for lang in "${langs[@]}"; do
		dir="$root/src/$year/Day$day/$lang"
		[ ! -d "$dir" ] && mkdir -p "$dir"
	done
	echo "# $year Day $((10#$day))" > "$root/src/$year/Day$day/README.md"
done
