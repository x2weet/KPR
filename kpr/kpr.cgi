#!/usr/bin/perl
#
# KPR instance sample file
#
#  Author: Ryota Wada
#    Date: Sun Oct 23 19:41:35 2011.

BEGIN {
    unshift @INC, './lib/', './site-lib/';
}
use strict;
use KPR;
require 'config.cgi';
$ENV{TZ} = "JST-9";
$| = 1;

my $k = new KPR;
$k->run();

# EOF
