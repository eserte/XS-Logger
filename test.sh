#!/bin/sh

#git proper ||:
rm -f *.[co] *.bs ||:
rm -rf blib

set -e
perl Makefile.PL
# WTF??
PERL_HASH_SEED=1 make
make test
