. ./run.sh
. ./get_test_names.sh

test_extracts_all_test_names_from_a_file () {
	tmp=$(mktemp)

	cat >"$tmp" <<EOF
test_a () {
}
EOF
	test "$(get_test_names "$tmp")" = 'test_a'
	outcome=$?

	rm "$tmp"

	return "$outcome"
}

test_ignores_functions_which_do_not_start_with_test_ () {
	tmp=$(mktemp)

	cat >"$tmp" <<EOF
test_a () {
}

some_func () {
}
EOF
	test "$(get_test_names "$tmp")" = 'test_a'
	outcome=$?

	rm "$tmp"

	return "$outcome"
}

run test_extracts_all_test_names_from_a_file
run test_ignores_functions_which_do_not_start_with_test_
