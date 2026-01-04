. shtest/run.sh
. shtest/assert_equal.sh

test_fails_if_strings_are_not_equal () {
	assert_equal 'string' 'different string' >/dev/null

	test $? -eq 1
}

test_succeeds_if_strings_are_equal () {
	assert_equal 'string' 'string'

	test $? -eq 0
}

test_prints_message_if_strings_are_not_equal () {
	string='a'
	other_string='b'
	msg="\
expected: '$string'
actual: '$other_string'\
"

	result=$(assert_equal "$string" "$other_string")

	test "$result" = "$msg"
}

test_does_not_print_message_if_strings_are_equal () {
	string='a'

	result=$(assert_equal "$string" "$string")

	test "$result" = ""
}

run test_fails_if_strings_are_not_equal
run test_succeeds_if_strings_are_equal
run test_prints_message_if_strings_are_not_equal
run test_does_not_print_message_if_strings_are_equal
