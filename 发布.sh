#!/bin/bash
# Xiang Wang(ramwin@qq.com)

make html && rm -r /var/www/github/python-reference/ && mv _build/html /var/www/github/python-reference/
