get_test_names () {
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
