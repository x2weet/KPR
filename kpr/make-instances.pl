#! /usr/bin/perl

use strict;
use warnings;
use utf8;

my %resource_file_map = (
    'login_form' =>          'login_form.cgi',      
    'menu_form' =>           'menu_form.cgi',       
    'doc_create_form' =>     'doc_create_form.cgi', 
    'doc_delete_form' =>     'doc_delete_form.cgi', 
    'doc_update_form' =>     'doc_update_form.cgi', 
    'dir_create_form' =>     'dir_create_form.cgi', 
    'dir_delete_form' =>     'dir_delete_form.cgi', 
    'dir_update_form' =>     'dir_update_form.cgi', 
);

my $file_templete = <<'__HERE__';
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
        resource => '__RESOURCE__',
    },
);

$kpr->run;
__HERE__

while (my($key, $val) = each %resource_file_map) {
    my $fh;
    open $fh, '>', $val or die $!;
    $_ = $file_templete;
    s/__RESOURCE__/$key/g;
    print $fh $_;
    close $fh;
}
# END
