. ./run.sh
. ./assert_equal.sh

test_fails_if_strings_are_not_equal () {
	assert_equal 'string' 'different string'

	test $? -eq 1
}

test_succeeds_if_strings_are_equal () {
	assert_equal 'string' 'string'

	test $? -eq 0
}

run test_fails_if_strings_are_not_equal
run test_succeeds_if_strings_are_equal
