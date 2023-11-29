#! /bin/bash

errors=false;

run_code() {
  printf "Running test for $1\n"
  dir=$PWD;
  cd "$1" || exit;

  rm -rf ./bin
  cinderblock compile -c
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
run_code 'simple-maths' 'simple_maths' 4 ""
run_code 'externals' 'externals' 0 "Hello world"
run_code 'functions' 'functions' 24 "This is from a function"
run_code 'lambdas' 'lambdas' 20 "This is in a lambda"
run_code 'loops' 'loops' 55 "Performing a loop Performing a loop Performing a loop "
run_code 'loop-concatination' 'loop_concatination' 73 "Performing a loop Performing a loop Performing a loop Performing a loop "
run_code 'partial-invokation' 'partial_invokation' 12 "Hello world"

if [ $errors = true ]; then
  echo "You had some errors. Check the logs above.";
  exit 1;
fi