#!/bin/bash
# Xiang Wang(ramwin@qq.com)

rm -r _build
sphinx-autobuild -j auto --port 18001 . _build/html/
