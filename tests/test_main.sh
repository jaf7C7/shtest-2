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

run test_extracts_test_names_from_a_file_and_runs_them
run test_runs_all_tests_in_each_test_file_specified
run test_runs_each_test_file_in_isolation
