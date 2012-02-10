#!/usr/bin/perl
#
# KPR instance sample file
#
#  Author: Ryota Wada
#    Date: Wed Feb  8 08:23:13 2012.

BEGIN {
    unshift @INC, './lib/', './site-lib/';
}
use strict;
use warings;

use KPR;
require 'config.cgi';
$ENV{TZ} = "JST-9";
$| = 1;

my $k = new KPR;
$k->run();

# EOF
