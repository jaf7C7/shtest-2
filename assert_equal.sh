assert_equal () {
	# $1, $2 - strings to compare
	if test "$1" != "$2"
	then
		printf "expected: '%s'\nactual: '%s'\n\n" "$1" "$2"
		return 1
	fi
}
