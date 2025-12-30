assert () {
	# $1 - command to be executed
	# $2 - message to print if command fails
	if ! ( eval "$1" )
	then
		printf '%s\n' "$2"
		return 1
	fi
}
