. shtest/run.sh
. shtest/get_test_names.sh

main () {
	for f in "$@"
	do
		(
			. "$f"

			printf '%s\n\n' "$f"

			for t in $(get_test_names "$f")
			do
				run "$t"
			done

			printf '\n'
		)
	done
}
