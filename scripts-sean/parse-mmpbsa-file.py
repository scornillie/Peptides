#!/usr/bin/python2.6
import os
import sys
import re

results = open("FINAL.dat", "r")

for line in results:
    if re.match("(.*)DELTA TOTAL(.*)", line):
        print line.split()[2]
