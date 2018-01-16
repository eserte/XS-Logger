#!/bin/sh

#git proper ||:
rm -f *.[co] *.bs ||:
rm -rf blib
rm -f /tmp/my-test

set -e
perl Makefile.PL
make
make test
