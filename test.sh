#! /bin/bash
cinderblock="${CINDERBLOCK:-cinderblock}"
errors=false;

run_code() {
  printf "Running test for $1\n"
  dir=$PWD;
  cd "$1" || exit;

  rm -rf ./.cinder_cache || true
  rm -rf ./bin || true
  stdout=""
  if [ "$4" == "test" ]; then
    eval "$cinderblock test"
    stdout=$(eval "./bin/linux/app_tests")
  else
    eval "$cinderblock compile -c -d"
    stdout=$(eval "./bin/linux/app")
  fi
  

  resp=$?;

  if [ "$resp" != "$2" ]; then
    errors=true;
    printf "Unexpected result from %s\nExpected %s\nReceived: %s\n\n" "$1" "$2" "$resp";
  fi

  if [ "$stdout" != "$3" ]; then
    errors=true;
    printf "Unexpected stdout from %s\nExpected:\n%s\nReceived:\n%s\n\n" "$1" "$3" "$stdout"
  fi

  cd "$dir" || exit;
  printf "\n\n\n"
}

run_code 'hello-world' 0 ""
run_code 'chained-operators' 0 ""
run_code 'if-expressions' 5 ""
run_code 'else-if' 0 ""
run_code 'simple-maths' 4 ""
run_code 'externals' 0 "Hello world"
run_code 'utf8-strings' 0 "私のお読さんは美しです"
run_code 'functions' 24 "This is from a function"
run_code 'function-overloading' 0 "This is from a struct
This is a string"
run_code 'lambdas' 20 "This is in a lambda"
run_code 'loops' 55 "Performing a loop Performing a loop Performing a loop "
run_code 'none-int-loops' 55 "Performing a loop Performing a loop Performing a loop "
run_code 'loop-concatination' 73 "Performing a loop Performing a loop Performing a loop Performing a loop "
run_code 'partial-invokation' 12 "Hello world"
run_code 'tests' 1 "Running test: This test passes
Test Passed


Running test: This test fails
Test Failed


You had some failues." test
run_code 'enums' 0 "Test Name
Test Full Name"


run_code 'specific-examples/string-equals' 0 ""
run_code 'specific-examples/reduce' 0 "Running test: std.iterable.reduce Aggregates simply
Test Passed


All tests passed!" test

if [ $errors = true ]; then
  echo "You had some errors. Check the logs above.";
  exit 1;
fi