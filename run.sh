run () {
	# $1 - name of test function
	printf '%s...' "$1"

	if "$1"
	then
		printf 'ok\n'
	else
		printf 'FAILED\n'
	fi
}
