#!/bin/sh

#git proper ||:
rm -f *.[co] *.bs ||:
rm -rf blib

set -e
perl Makefile.PL
make
make test
