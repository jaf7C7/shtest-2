. shtest/run.sh
. shtest/get_test_names.sh

test_extracts_all_test_names_from_a_file () {
	tmp=$(mktemp)

	cat >"$tmp" <<EOF
test_a () {
	:
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
	:
}

some_func () {
	:
}
EOF
	test "$(get_test_names "$tmp")" = 'test_a'
	outcome=$?

	rm "$tmp"

	return "$outcome"
}

test_also_extracts_function_names_with_different_valid_formatting () {
	tmp=$(mktemp)

	cat >"$tmp" <<EOF
test_a() {
	:
}

test_b ()
{
	:
}

test_c()
{
	:
}
EOF
	test "$(get_test_names "$tmp")" = 'test_a
test_b
test_c'
	outcome=$?

	rm "$tmp"

	return "$outcome"
}

test_only_extracts_names_of_defined_functions () {
	tmp=$(mktemp)

	cat >"$tmp" <<EOF
test_this_is_a_real_test_function () {
	fake_test_function='
test_looks_like_a_test_function_but_is_not () {
	:
}
'
}
EOF
	test "$(get_test_names "$tmp")" = 'test_this_is_a_real_test_function'
	outcome=$?

	rm "$tmp"

	return "$outcome"
}

run test_extracts_all_test_names_from_a_file
run test_ignores_functions_which_do_not_start_with_test_
run test_also_extracts_function_names_with_different_valid_formatting
run test_only_extracts_names_of_defined_functions
