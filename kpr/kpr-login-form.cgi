#!/usr/bin/perl
#
# KPR instance sample file
#
#  Author: Ryota Wada
#    Date: Fri Feb 10 18:49:45 2012.


use lib qw(./lib);

use strict;
use warnings;

use KPR;
require 'config.cgi';
$ENV{TZ} = "JST-9";
$| = 1;

my $k = KPR->load(
    resource => 'login-form',
);
$k->run();

# EOF
