#! /bin/bash

errors=false;

run_code() {
  dir=$PWD;
  cd "$1" || exit;
  cinderblock compile
  stdout=$(eval "./bin/linux/$2")

  resp=$?;

  if [ "$resp" != "$3" ]; then
    errors=true;
    echo "Unexpected result from $1";
  fi

  if [ "$stdout" != "$4" ]; then
    errors=true;
    printf "Unexpected stdout from %s\nExpected:\n%s\nReceived:\n%s\n" "$1" "$4" "$stdout"
  fi

  cd "$dir" || exit;
}

run_code 'hello-world' 'hello_world' 0 ""
run_code 'simple-maths' 'simple_maths' 4 ""
run_code 'externals' 'externals' 12 "Hello world"
run_code 'lambdas' 'lambdas' 20 "This is in a lambda"

if [ $errors = true ]; then
  echo "You had some errors. Check the logs above.";
  exit 1;
fi