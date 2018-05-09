#!/usr/bin/env bash

set -e

pushd "${BASH_SOURCE%/*}/../../Source/LexerParser" > /dev/null

for lexer in            \
    CommandArgument     \
    DependsJava         \
    Expr                \
    Fortran
do
    cxx_file=cm${lexer}Lexer.cxx
    h_file=cm${lexer}Lexer.h
    in_file=cm${lexer}Lexer.in.l

    echo "Generating Lexer ${lexer}"
    flex --nounistd -DFLEXINT_H --noline --header-file=${h_file} -o${cxx_file} ${in_file}
    sed -i 's/\s*$//'                       ${h_file} ${cxx_file}   # remove trailing whitespaces
    sed -i '${/^$/d;}'                      ${h_file} ${cxx_file}   # remove blank line at the end
    sed -i '1i#include "cmStandardLexer.h"' ${cxx_file}             # add cmStandardLexer.h include
done


# these lexers (at the moment only the ListFileLexer) are compiled as C and do not generate a header
for lexer in ListFile
do
    c_file=cm${lexer}Lexer.c
    in_file=cm${lexer}Lexer.in.l

    echo "Generating Lexer ${lexer}"
    flex --nounistd -DFLEXINT_H --noline -o${c_file} ${in_file}
    sed -i 's/\s*$//'                       ${c_file}   # remove trailing whitespaces
    sed -i '${/^$/d;}'                      ${c_file}   # remove blank line at the end
    sed -i '1i#include "cmStandardLexer.h"' ${c_file}   # add cmStandardLexer.h include

done

popd > /dev/null
