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
	exit_code=$?

	if test "$exit_code" -eq 0
	then
		printf "$okfmt" 'ok'
	else
		printf "$failfmt" 'FAILED'

		if test -n "$errors"
		then
			printf "$errfmt" "$errors"
		fi
	fi

	return "$exit_code"
}

_extract_tests () {
	# $1 - File containing test functions.
	
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
	# $1 - file containing tests to run
	# $2 - results file to read/write results
	. "$1"
	. "$2"

	printf '%s\n\n' "$1"

	for test in $(_extract_tests "$1")
	do
		if ( _run_test "$test" )
		then
			passed=$((passed + 1))
		else
			failed=$((failed + 1))
		fi

		total=$((total + 1))
	done

	cat >"$2" <<EOF
total=$total
passed=$passed
failed=$failed
EOF
	printf '\n'
}

main () {
	for path in "$@"
	do
		if test -d "$path"
		then
			shift
			# Strip trailing slashes to avoid double slash in resulting path.
			set -- "${path%%/}"/* "$@"
			continue
		fi
	done

	results_file=$(mktemp)
	
	cat >"$results_file" <<EOF
total=0
passed=0
failed=0
EOF

	for file in "$@"
	do
		( _run_all_tests "$file" "$results_file" )
	done

	. "$results_file"
	rm "$results_file"

	if test -t 1
	then
		passedfmt="\033[1;32m%s\033[m\n"
		failedfmt="\033[1;31m%s\033[m\n"
	else
		passedfmt='%s\n'
		failedfmt='%s\n'
	fi

	printf 'ran %s test(s)\n' "$total"

	if test "$passed" -gt 0
	then
		printf "$passedfmt" "passed: $passed"
	fi

	if test "$failed" -gt 0
	then
		printf "$failedfmt" "FAILED: $failed"
	fi

	printf '\n'
}
