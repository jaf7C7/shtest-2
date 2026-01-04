get_test_names () {
	# $1 - File containing test functions
	sed -n 's/\(^test_[^ 	]*\)[ 	]*().*/\1/p' "$1"
}
