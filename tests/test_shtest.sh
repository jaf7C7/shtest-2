test_extracts_test_names_from_a_file_and_runs_them () {
	test_file=$(mktemp)

	cat >"$test_file" <<EOF
test_a () {
	return 0
}
EOF
	result=$(shtest "$test_file")
	expected="\
$test_file

test_a...ok"

	test "$result" = "$expected"
	exit_code=$?

	rm "$test_file"

	return "$exit_code"
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

	result=$(shtest "$test_file1" "$test_file2")
	expected="\
$test_file1

test_a...ok

$test_file2

test_b...ok"

	test "$result" = "$expected"
	exit_code=$?

	rm "$test_file1" "$test_file2"

	return "$exit_code"
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
	shtest "$test_file1" "$test_file2" >/dev/null

	test -z "$some_var"
	exit_code=$?

	rm "$test_file1" "$test_file2"

	return "$exit_code"
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

	result=$(shtest "$test_file")
	expected="\
$test_file

test_a...ok"

	test "$result" = "$expected"
	exit_code=$?

	rm "$test_file"

	return "$exit_code"
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
	result=$(shtest "$test_file")
	expected="\
$test_file

test_a...ok
test_b...ok"

	test "$result" = "$expected"
	exit_code=$?

	rm "$test_file"

	return "$exit_code"
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
	result=$(shtest "$test_file")
	expected="\
$test_file

test_a...ok
test_b...ok
test_c...ok"

	test "$result" = "$expected"
	exit_code=$?

	rm "$test_file"

	return "$exit_code"
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
	result=$(shtest "$test_file")
	expected="\
$test_file

test_this_is_a_real_test_function...ok"

	test "$result" = "$expected"
	exit_code=$?

	rm "$test_file"

	return "$exit_code"
}

test_assertions_are_available_in_tests () {
	test_file=$(mktemp)

	cat >"$test_file" <<EOF
test_assert_equal_is_defined () {
	command -v assert_equal >/dev/null
}

test_assert_exit_code_is_defined () {
	command -v assert_exit_code >/dev/null
}
EOF
	
	result=$(shtest "$test_file")
	expected="\
$test_file

test_assert_equal_is_defined...ok
test_assert_exit_code_is_defined...ok"

	test "$result" = "$expected"
	exit_code=$?

	rm "$test_file"

	return "$exit_code"
}

test_stderr_received_during_test_execution_displayed_after_result () {
	test_file=$(mktemp)

	cat >"$test_file" <<EOF
test_a () {
	echo 'Something went wrong.' >&2
	return 1
}

test_b () {
	return 0
}
EOF
	
	result=$(shtest "$test_file")
	expected="\
$test_file

test_a...FAILED
Something went wrong.
test_b...ok"

	test "$result" = "$expected"
	exit_code=$?

	rm "$test_file"

	return "$exit_code"
}

test_recurses_into_directories_passed_as_arguments () {
	test_dir=$(mktemp -d)
	test_file=$(mktemp -p "$test_dir")

	cat >"$test_file" <<EOF
test_a () {
	return 0
}
EOF

	result=$(shtest "$test_dir")
	expected="\
$test_file

test_a...ok"

	test "$result" = "$expected"
	exit_code=$?

	rm -r "$test_file" "$test_dir"

	return "$exit_code"
}
