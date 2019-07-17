#!/bin/bash

# dos2unix remove bom
find . -regex '.*\.h\|.*\.hpp\|.*\.cpp\|.*\.c' !-type d -exec dos2unix -r {} \;
# iconv to utf-8 encoding
find . -regex '.*\.h\|.*\.hpp\|.*\.cpp\|.*\.c' !-type d -exec bash -c 'iconv -t UTF8 "$0" > /tmp/e && mv /tmp/e "$0"'  {} \;
# replace tab with 4 space
find . -regex '.*\.h\|.*\.hpp\|.*\.cpp\|.*\.c' !-type d -exec bash -c 'expand -t 4 "$0" > /tmp/e && mv /tmp/e "$0"' {} \;
