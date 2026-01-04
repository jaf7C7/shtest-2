assert_equal () {
	# $1, $2 - strings to compare
	if test "$1" != "$2"
	then
		printf "expected: '%s'\nactual: '%s'\n\n" "$1" "$2"
		return 1
	fi
}

assert_exit_code () {
	# $1 - expected exit code
	# $2 - command to be executed
	( eval "$2" )

	set -- "$@" $?  # $3 - actual exit code of command

	if test "$3" -ne "$1"
	then
		printf "expected: '%s'\nactual: '%s'\n" "$1" "$3"
		return 1
	fi
}
