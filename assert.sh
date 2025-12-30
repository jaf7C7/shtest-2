assert () {
	# $1 - command to be executed
	# $2 - message to print if command fails
	eval "$1"

	if test $? -ne 0
	then
		printf '%s\n' "$2"
		return 1
	fi
}
