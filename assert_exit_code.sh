assert_exit_code () {
	# $1 - expected exit code
	# $2 - command to be executed
	( eval "$2" )
	test $? -eq "$1"
}
