. ./run.sh

assert_equal () {
	# $1, $2 - strings to compare
	test "$1" = "$2"
}


test_assert_equal_fails_if_strings_are_not_equal () {
	assert_equal 'string' 'different string'

	test $? -eq 1
}

run test_assert_equal_fails_if_strings_are_not_equal
