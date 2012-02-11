#!/usr/bin/perl
#
# KPR instance sample file
#
#  Author: Ryota Wada
#    Date: Sat Feb 11 17:42:07 2012.

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
    resource => 'dir-delete-form',
);
$k->run();

# EOF
