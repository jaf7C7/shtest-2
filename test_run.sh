. ./run.sh

test_run_executes_test_in_isolation () {
	set_a_to_1 () {
		a=1
	}

	run 'set_a_to_1' >/dev/null

	test -z "$a"
}

run test_run_executes_test_in_isolation
