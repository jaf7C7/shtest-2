. shtest/main.sh

test_extracts_test_names_from_a_file_and_runs_them () {
	test_file=$(mktemp)

	cat >"$test_file" <<EOF
test_a () {
	return 0
}
EOF

	test "$(main "$test_file")" = "\
$test_file

test_a...ok"

	result=$?
	rm "$test_file"

	return "$result"
}

test_runs_all_tests_in_each_test_file_specified () {
	test_file1=$(mktemp)
	test_file2=$(mktemp)

	cat >"$test_file1" <<EOF
test_a () {
	return 0
}
EOF

	cat >"$test_file2" <<EOF
test_b () {
	return 0
}
EOF

	test "$(main "$test_file1" "$test_file2")" = "\
$test_file1

test_a...ok

$test_file2

test_b...ok"

	result=$?
	rm "$test_file1" "$test_file2"

	return "$result"
}

test_runs_each_test_file_in_isolation () {
	test_file1=$(mktemp)
	test_file2=$(mktemp)

	cat >"$test_file1" <<EOF
some_var=1
EOF
	cat >"$test_file2" <<EOF
some_var=2
EOF
	main "$test_file1" "$test_file2" >/dev/null

	test -z "$some_var"

	result=$?
	rm "$test_file1" "$test_file2"

	return "$result"
}

test_ignores_functions_which_do_not_start_with_test_ () {
	test_file=$(mktemp)

	cat >"$test_file" <<EOF
test_a () {
	return 0
}

some_func () {
	return 0
}
EOF

	test "$(main "$test_file")" = "\
$test_file

test_a...ok"

	result=$?
	rm "$test_file"

	return "$result"
}

test_runs_each_test_function_in_isolation () {
	test_file=$(mktemp)

	cat >"$test_file" <<\EOF
test_a () {
	a=1
}

test_b () {
	test -z "$a"
}
EOF
	test "$(main "$test_file")" = "\
$test_file

test_a...ok
test_b...ok"
	result=$?

	rm "$test_file"

	return "$result"
}

test_also_extracts_function_names_with_different_valid_formatting () {
	test_file=$(mktemp)

	cat >"$test_file" <<EOF
test_a() {
	return 0
}

test_b ()
{
	return 0
}

test_c()
{
	return 0
}
EOF
	test "$(main "$test_file")" = "\
$test_file

test_a...ok
test_b...ok
test_c...ok"

	result=$?
	rm "$test_file"

	return "$result"
}

test_only_extracts_names_of_defined_functions () {
	test_file=$(mktemp)

	cat >"$test_file" <<EOF
test_this_is_a_real_test_function () {
	fake_test_function='
test_looks_like_a_test_function_but_is_not () {
	return 0
}
'
}
EOF

	test "$(main "$test_file")" = "\
$test_file

test_this_is_a_real_test_function...ok"

	result=$?
	rm "$test_file"

	return "$result"
}
