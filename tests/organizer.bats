#!/usr/bin/env bats

setup() {
    TEST_DIR="$(mktemp -d)"
    touch "$TEST_DIR/file1.txt"
    touch "$TEST_DIR/file2.jpg"
    touch "$TEST_DIR/file with space.txt"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "organize by extension" {
    run ./filesort.sh organize "$TEST_DIR" --mode extension
    [ "$status" -eq 0 ]
    [ -f "$TEST_DIR/txt/file1.txt" ]
    [ -f "$TEST_DIR/jpg/file2.jpg" ]
    [ -f "$TEST_DIR/txt/file with space.txt" ]
}

@test "organize by category" {
    run ./filesort.sh organize "$TEST_DIR" --mode category
    [ "$status" -eq 0 ]
    [ -f "$TEST_DIR/Documents/file1.txt" ]
    [ -f "$TEST_DIR/Images/file2.jpg" ]
    [ -f "$TEST_DIR/Documents/file with space.txt" ]
}
