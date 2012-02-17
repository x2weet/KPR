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
        resource => 'doc_create_form',
    },
);

$kpr->run;
