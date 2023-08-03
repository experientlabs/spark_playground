#!/bin/bash

build() {
  docker-compose build
}

run() {
  docker-compose up -d
}

build_and_run() {
  build
  run
}

# Check the command-line argument
if [[ $# -eq 0 ]]; then
  echo "Usage: start.sh [build | run | build_and_run]"
  exit 1
fi

# Execute the requested function based on the command-line argument
case $1 in
  "build") build ;;
  "run") run ;;
  "build_and_run") build_and_run ;;
  *) echo "Invalid argument: $1. Usage: start.sh [build | run | build_and_run]" ;;
esac
