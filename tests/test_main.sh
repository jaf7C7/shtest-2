. shtest/run.sh
. shtest/main.sh

test_extracts_test_names_from_a_file_and_runs_them () {
	tmp=$(mktemp)

	cat >"$tmp" <<EOF
test_a () {
	return 0
}
EOF

	test "$(main "$tmp")" = "\
$tmp

test_a...ok"
	outcome=$?

	rm "$tmp"

	return "$outcome"
}

test_runs_all_tests_in_each_test_file_specified () {
	tmp1=$(mktemp)
	tmp2=$(mktemp)

	cat >"$tmp1" <<EOF
test_a () {
	return 0
}
EOF
	cat >"$tmp2" <<EOF
test_b () {
	return 0
}
EOF
	test "$(main "$tmp1" "$tmp2")" = "\
$tmp1

test_a...ok

$tmp2

test_b...ok"
	outcome=$?

	rm "$tmp1" "$tmp2"

	return "$outcome"
}

test_runs_each_test_file_in_isolation () {
	tmp1=$(mktemp)
	tmp2=$(mktemp)

	cat >"$tmp1" <<EOF
some_var=1
EOF
	cat >"$tmp2" <<EOF
some_var=2
EOF
	main "$tmp1" "$tmp2" >/dev/null

	test -z "$some_var"
	outcome=$?

	rm "$tmp1" "$tmp2"

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
	test "$(main "$tmp")" = "\
$tmp

test_a...ok"
	outcome=$?

	rm "$tmp"

	return "$outcome"
}

test_runs_each_test_function_in_isolation () {
	tmp=$(mktemp)

	cat >"$tmp" <<\EOF
test_a () {
	a=1
}

test_b () {
	test -z "$a"
}
EOF
	test "$(main "$tmp")" = "\
$tmp

test_a...ok
test_b...ok"
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
	expected="\
$tmp

test_a...ok
test_b...ok
test_c...ok"
	result="$(main "$tmp")"

	test "$result" = "$expected"
	outcome=$?

	if test "$outcome" -ne 0
	then
		printf '\n got: %s\nexpected: %s\n' "$result" "$expected" >&2
	fi

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
	test "$(main "$tmp")" = "\
$tmp

test_this_is_a_real_test_function...ok"
	outcome=$?

	rm "$tmp"

	return "$outcome"
}

run test_extracts_test_names_from_a_file_and_runs_them
run test_runs_all_tests_in_each_test_file_specified
run test_runs_each_test_file_in_isolation
run test_runs_each_test_function_in_isolation
run test_ignores_functions_which_do_not_start_with_test_
run test_also_extracts_function_names_with_different_valid_formatting
run test_only_extracts_names_of_defined_functions
