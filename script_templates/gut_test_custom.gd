extends "res://tests/base_test.gd"

# https://github.com/bitwes/Gut/wiki/Quick-Start

###############################################################################
# Builtin functions                                                           #
###############################################################################

func before_all():
	.before_all()

func before_each():
%TS%pass

func after_each():
%TS%pass

func after_all():
%TS%pass

###############################################################################
# Tests                                                                       #
###############################################################################
