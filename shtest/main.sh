_run_test () {
	# $1 - name of test function
	printf '%s...' "$1"

	if test -t 1
	then
		okfmt='\033[32m%s\033[m\n'
		failfmt='\033[1;31m%s\033[m\n'
		errfmt='\033[31m%s\033[m\n'
	else
		okfmt='%s\n'
		failfmt='%s\n'
		errfmt='%s\n'
	fi

	errors=$("$1" 2>&1)

	if test $? -eq 0
	then
		printf "$okfmt" 'ok'
	else
		printf "$failfmt" 'FAILED'

		if test -n "$errors"
		then
			printf "$errfmt" "$errors"
		fi
	fi
}

_extract_tests () {
	# $1 - File containing test functions.
	. "$1"
	
	# Search the file for potential test names. That is any words
	# at the beginning of a line which start with "test_" and end in
	# parentheses. Set the argument list the array of these potential test
	# names.
	set -- $(sed -n 's/\(^test_[^ 	]*\)[ 	]*().*/\1/p' "$1")

	# Filter out any names which aren't declared in the file, leaving only
	# real tests.
	for name in "$@"
	do
		shift
		if command -v "$name" >/dev/null
		then
			set -- "$@" "$name"
		fi
	done

	printf '%s\n' "$@"
}

_run_all_tests () {
	# $1 - file containing tests to be run
	. "$1"

	printf '%s\n\n' "$1"

	for test in $(_extract_tests "$1")
	do
		_run_test "$test"
	done

	printf '\n'
}

main () {
	for path in "$@"
	do
		if test -d "$path"
		then
			shift
			set -- "${path%%/}"/* "$@"
			continue
		fi
	done

	for file in "$@"
	do
		( _run_all_tests "$file" )
	done
}
