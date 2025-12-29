assert () {
	"$1"
}

test_assert_fails_if_given_command_fails () {
	printf 'test_assert_fails_if_given_command_fails...'

	if assert 'false'
	then
		! printf 'FAILED\n'
	else
		printf 'ok\n'
	fi
}

test_assert_fails_if_given_command_fails
