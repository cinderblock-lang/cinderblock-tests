#! /bin/bash

errors=false;

run_code() {
  dir=$PWD;
  cd $1;
  cinderblock compile
  eval "./bin/linux/$2"
  echo $?

  if [ $? -ne $3 ]; then
    errors=true;
    echo "Unexpected result from $1";
  fi

  cd $dir;
}

run_code 'hello-world' 'hello_world' 0
run_code 'simple-maths' 'simple_maths' 4

if [ $errors ]; then
  echo "You had some errors. Check the logs above.";
  exit 1;
fi