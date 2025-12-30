. ./run.sh
. ./assert_exit_code.sh

test_prints_message_on_failure () {
	return_1 () {
		return 1
	}

	msg="\
expected: '0'
actual: '1'"

	test "$(assert_exit_code 0 'return_1')" = "$msg"
}

test_fails_if_incorrect_exit_code () {
	return_1 () {
		return 1
	}

	assert_exit_code 0 'return_1' >/dev/null

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

run test_prints_message_on_failure
run test_fails_if_incorrect_exit_code
run test_succeeds_if_correct_exit_code
run test_executes_command_in_isolation
