_print () {
	# Behaves like `printf` but does not print escape sequences if stdout
	# is not a terminal. Assumes the format string is just '%s\n' wrapped
	# in colour escapes, and might give unexpected results if that's not
	# the case.
	if ! test -t 1
	then
		shift
		set -- '%s\n' "$@"
	fi
	printf "$@"
}

_run () {
	# $1 - name of test function
	printf '%s...' "$1"

	if ( "$1" )
	then
		_print '\033[32m%s\033[m\n' 'ok'
	else
		_print '\033[1;31m%s\033[m\n' 'FAILED'
	fi
}

_get_test_names () {
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

			for t in $(_get_test_names "$f")
			do
				_run "$t"
			done

			printf '\n'
		)
	done
}
