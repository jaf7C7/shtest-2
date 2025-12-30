. ./run.sh
. ./get_test_names.sh

test_extracts_all_test_names_from_a_file () {
	tmp=$(mktemp)

	cat >"$tmp" <<EOF
test_a () {
}
EOF
	test "$(get_test_names "$tmp")" = 'test_a'

	rm "$tmp"
}

run test_extracts_all_test_names_from_a_file
