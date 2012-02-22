#!/usr/bin/env perl
#
# KPR instance file

use strict;
use warnings;
use lib qw(./lib);
#use utf8;

use KPR;

my $kpr = KPR->new(
    PARAMS => {
        cfg_file => 'config.txt',
        resource => 'dir_create_form',
    },
);

$kpr->run;
