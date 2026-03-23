#!/bin/tcsh

# Rui ("Ray") Xu
# Nov 2021
# CISL @ Columbia, Kinget Group
# Genus: run_genus.tcsh

# This script must be sourced to read proper environment variable $PATH to genus executable 

genus -no_gui -batch -files ../scripts/run_all.tcl
