#!/usr/bin/perl
#
# KPR instance file

use strict;
use warnings;
use lib qw(./lib);
#use utf8;

use KPR;

my $kpr = KPR->new(
    TMPL_PATH => 'skeleton/',
    PARAMS => {
        resource => 'menu_form',
    },
);

$kpr->run;
