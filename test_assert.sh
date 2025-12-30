. ./run.sh

assert () {
	# $1 - command to be executed
	# $2 - message to print if command fails
	"$1"

	if test $? -ne 0
	then
		printf '%s\n' "$2"
	fi
}

test_prints_message_on_failure () {
	cmd='false'
	msg='false returned nonzero!'

	test "$(assert "$cmd" "$msg")" = "$msg"
}

run test_prints_message_on_failure
