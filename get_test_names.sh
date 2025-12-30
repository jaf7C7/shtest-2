get_test_names () {
	# $1 - File containing test functions
	grep '^test_' "$1"
}
