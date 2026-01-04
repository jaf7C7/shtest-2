_run () {
	# $1 - name of test function
	printf '%s...' "$1"

	if test -t 1
	then
		okfmt='\033[32m%s\033[m\n'
		failfmt='\033[1;31m%s\033[m\n'
	else
		okfmt='%s\n'
		failfmt='%s\n'
	fi

	if ( "$1" )
	then
		printf "$okfmt" 'ok'
	else
		printf "$failfmt" 'FAILED'
	fi
}

_find_test_functions () {
	# $1 - File containing test functions.
	. "$1"
	
	# Search the file for potential test names. That is any words
	# at the beginning of a line which start with "test_" and end in
	# parentheses. Set the argument list the array of these potential test
	# names.
	set -- $(sed -n 's/\(^test_[^ 	]*\)[ 	]*().*/\1/p' "$1")

	# Filter out any names which aren't declared in the file, leaving only
	# real tests.
	for fname in "$@"
	do
		shift
		if command -v "$fname" >/dev/null
		then
			set -- "$@" "$fname"
		fi
	done

	printf '%s\n' "$@"
}

main () {
	for f in "$@"
	do
		(
			. shtest/assert.sh
			. "$f"

			printf '%s\n\n' "$f"

			for t in $(_find_test_functions "$f")
			do
				_run "$t"
			done

			printf '\n'
		)
	done
}
