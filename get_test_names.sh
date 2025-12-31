get_test_names () {
	# $1 - File containing test functions
	sed -n 's/\(^test_[^[:space:]]*\)[[:space:]]*().*/\1/p' "$1"
}
