. ./run.sh
. ./assert.sh

test_prints_message_on_failure () {
	cmd='false'
	msg='false returned nonzero!'

	test "$(assert "$cmd" "$msg")" = "$msg"
}

test_does_not_print_message_on_success () {
	cmd='true'
	msg='this should not be printed'

	test "$(assert "$cmd" "$msg")" = ''
}

test_does_not_throw_error_if_command_contains_whitespace () {
	cmd='true and some args'
	msg='this should not be printed'

	test "$(assert "$cmd" "$msg")" = ''
}

run test_prints_message_on_failure
run test_does_not_print_message_on_success
run test_does_not_throw_error_if_command_contains_whitespace
