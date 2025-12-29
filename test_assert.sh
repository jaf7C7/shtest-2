assert_exit_code () {
	# $1 - expected exit code
	# $2 - command to be executed
	( eval "$2" )
	test $? -eq "$1"
}

test_fails_if_incorrect_exit_code () {
	return_1 () {
		return 1
	}

	assert_exit_code 0 'return_1'

	test $? -eq 1
}

test_succeeds_if_correct_exit_code () {
	return_0 () {
		return 0
	}

	assert_exit_code 0 'return_0'

	test $? -eq 0
}

test_executes_command_in_isolation () {
	set_foo_equal_to_bar () {
		foo=bar
	}

	assert_exit_code 0 'set_foo_equal_to_bar'

	test -z "$foo"
}

run () {
	# $1 - name of test function
	printf '%s...' "$1"

	if "$1"
	then
		printf 'ok\n'
	else
		printf 'FAILED\n'
	fi
}

run test_fails_if_incorrect_exit_code
run test_succeeds_if_correct_exit_code
run test_executes_command_in_isolation
