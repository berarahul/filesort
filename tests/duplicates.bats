#!/usr/bin/env bats

setup() {
    TEST_DIR="$(mktemp -d)"
    echo "hello" > "$TEST_DIR/file1.txt"
    echo "hello" > "$TEST_DIR/file2.txt"
    echo "world" > "$TEST_DIR/file3.txt"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "find duplicates" {
    run ./filesort.sh duplicates "$TEST_DIR"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "file1.txt" ]]
    [[ "$output" =~ "file2.txt" ]]
    # Should not report file3 since no duplicate
    [[ ! "$output" =~ "file3.txt" ]]
}
