print () {
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

run () {
	# $1 - name of test function
	printf '%s...' "$1"

	if ( "$1" )
	then
		print '\033[32m%s\033[m\n' 'ok'
	else
		print '\033[1;31m%s\033[m\n' 'FAILED'
	fi
}
