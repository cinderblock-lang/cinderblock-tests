#! /bin/bash
cinderblock="${CINDERBLOCK:-cinderblock}"
errors=false;

run_code() {
  printf "Running test for $1\n"
  dir=$PWD;
  cd "$1" || exit;

  rm -rf ./.cinder_cache || true
  rm -rf ./bin || true
  if [ "$5" == "test" ]; then
    eval "$cinderblock test"
  else
    eval "$cinderblock compile -c"
  fi
  stdout=$(eval "./bin/linux/$2")

  resp=$?;

  if [ "$resp" != "$3" ]; then
    errors=true;
    printf "Unexpected result from %s\nExpected %s\nReceived: %s\n\n" "$1" "$3" "$resp";
  fi

  if [ "$stdout" != "$4" ]; then
    errors=true;
    printf "Unexpected stdout from %s\nExpected:\n%s\nReceived:\n%s\n\n" "$1" "$4" "$stdout"
  fi

  cd "$dir" || exit;
  printf "\n\n\n"
}

run_code 'hello-world' 'hello_world' 0 ""
run_code 'chained-operators' 'chained_operators' 0 ""
run_code 'if-expressions' 'if_expressions' 5 ""
run_code 'simple-maths' 'simple_maths' 4 ""
run_code 'externals' 'externals' 0 "Hello world"
run_code 'utf8-strings' 'utf_8_strings' 0 "こんにちは世界"
run_code 'functions' 'functions' 24 "This is from a function"
run_code 'lambdas' 'lambdas' 20 "This is in a lambda"
run_code 'loops' 'loops' 55 "Performing a loop Performing a loop Performing a loop "
run_code 'loop-concatination' 'loop_concatination' 73 "Performing a loop Performing a loop Performing a loop Performing a loop "
run_code 'partial-invokation' 'partial_invokation' 12 "Hello world"
run_code 'tests' 'tests_tests' 1 "Running test: This test passes
Test Passed


Running test: This test fails
Test Failed


You had some failues." test
run_code 'enums' 'enums' 0 "Test Name
Test Full Name"


run_code 'specific-examples/string-equals' 'string_equals' 0 ""

if [ $errors = true ]; then
  echo "You had some errors. Check the logs above.";
  exit 1;
fi