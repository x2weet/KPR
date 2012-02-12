#!/usr/bin/perl
#
# KPR instance sample file
#
#  Author: Ryota Wada
#    Date: Sat Feb 11 17:41:42 2012.


use lib qw(./lib);

use strict;
use warnings;

use KPR;
require 'config.cgi';
$ENV{TZ} = "JST-9";
$| = 1;

my $k = KPR->load(
    resource => 'dir-create-form',
);
$k->run();

# EOF
