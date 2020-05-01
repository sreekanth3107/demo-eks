#!/bin/bash

rm -f cookiecutter-base-java.zip
zip cookiecutter-base-java -r hooks/* \{\{cookiecutter.func_name\}\}/*

