run () {
	# $1 - name of test function
	printf '%s...' "$1"

	if ( "$1" )
	then
		printf '\033[32m%s\033[m\n' 'ok'
	else
		printf '\033[1;31m%s\033[m\n' 'FAILED'
	fi
}
