#!/usr/bin/perl
#
# KPR instance sample file
#
#  Author: Ryota Wada
#    Date: Sat Feb 11 15:11:02 2012.

BEGIN {
    unshift @INC, './lib', './site-lib';
}
use strict;
use warnings;

use KPR;
require 'config.cgi';
$ENV{TZ} = "JST-9";
$| = 1;

my $k = KPR->load(
    resource => 'menu-form',
);
$k->run();

# EOF
