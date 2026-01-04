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
	
	# Set argument list to array of potential test names.
	set -- $(sed -n 's/\(^test_[^ 	]*\)[ 	]*().*/\1/p' "$1")

	# Filter out any names which aren't declared in the file, leaving only
	# real tests.
	for test in "$@"
	do
		shift
		if command -v "$test" >/dev/null
		then
			set -- "$@" "$test"
		fi
	done

	printf '%s\n' "$@"
}

main () {
	for f in "$@"
	do
		(
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
