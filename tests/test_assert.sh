. shtest/assert.sh

test_returns_0_if_string_comparison_succeeds () {
	assert 'a' = 'a'

	test $? -eq 0
}

test_returns_1_if_string_comparison_fails () {
	assert 'a' != 'a'

	test $? -eq 1
}

test_prints_message_if_string_comparison_fails () {
	test "$(assert 'a' != 'a')" = 'assertion failed: a != a'
}

test_failure_message_adds_quotes_to_arguments_containing_whitespace () {
	test "$(assert ' x' = 'x')" = "assertion failed: ' x' = x"
}
	
