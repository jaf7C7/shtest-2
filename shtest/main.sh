. shtest/run.sh
. shtest/get_test_names.sh

main () {
	for f in "$@"
	do
		(
			. "$f"
			for t in $(get_test_names "$f")
			do
				printf '%s\n\n' "$f"
				run "$t"
				printf '\n'
			done
		)
	done
}
