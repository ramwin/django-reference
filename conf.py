#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Xiang Wang @ 2018-04-25 11:49:13

from recommonmark.perser import CommonMarkParser

source_parsers = {
    ".md": CommonMarkParser,
}

source_suffix = [".rst", ".md"]
