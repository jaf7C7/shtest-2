. shtest/assert_exit_code.sh

return_1 () {
	return 1
}

test_prints_message_on_failure () {
	msg="\
expected: '0'
actual: '1'\
"
	result=$(assert_exit_code 0 'return_1')

	test "$result" = "$msg"
}

test_does_not_print_message_on_success () {
	msg=''
	result=$(assert_exit_code 1 'return_1')

	test "$result" = "$msg"
}

test_fails_if_incorrect_exit_code () {
	assert_exit_code 0 'return_1' >/dev/null

	test $? -eq 1
}

test_succeeds_if_correct_exit_code () {
	assert_exit_code 1 'return_1'

	test $? -eq 0
}

test_executes_command_in_isolation () {
	set_foo_equal_to_bar () {
		foo=bar
	}

	assert_exit_code 0 'set_foo_equal_to_bar'

	test -z "$foo"
}

test_does_not_throw_error_if_command_contains_whitespace () {
	assert_exit_code 1 '
		: do stuff
		return_1
	'

	test $? -eq 0
}

test_does_not_throw_error_if_command_contains_quotes () {
	assert_exit_code 0 'test "'\''" = \'\'''

	test $? -eq 0
}
