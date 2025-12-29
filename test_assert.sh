assert_exit_code () {
	# $1 - expected exit code
	# $2 - command to be executed
	( eval "$2" )
	test $? -eq "$1"
}

test_assert_exit_code_fails_if_incorrect_exit_code () {
	assert_exit_code 0 'false'

	test $? -eq 1
}

test_assert_exit_code_succeeds_if_correct_exit_code () {
	assert_exit_code 0 'true'

	test $? -eq 0
}

test_assert_exit_code_executes_command_in_isolation () {
	set_foo_equal_to_bar () {
		foo=bar
	}

	assert_exit_code 0 'set_foo_equal_to_bar'

	test -z "$foo"
}

run () {
	printf '%s...' "$1"

	if "$1"
	then
		printf 'ok\n'
	else
		printf 'FAILED\n'
	fi
}

run test_assert_exit_code_fails_if_incorrect_exit_code
run test_assert_exit_code_succeeds_if_correct_exit_code
run test_assert_exit_code_executes_command_in_isolation
