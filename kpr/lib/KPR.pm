# 
# KPR.pm
#
#   Author: Ryota Wada
#     Date: Mon Feb 13 17:41:36 2012. (JST)
#
package KPR;
use strict;
use warnings;
use base 'CGI::Application';

sub setup {
    my $c = shift;

    $c->start_mode('login_form');
    $c->run_modes([qw/
                         login_form
                         menu_form
                         doc_create_form
                         doc_delete_form
                         doc_update_form
                         dir_create_form
                         dir_delete_form
                         dir_update_form
                     /]);
    $c->mode_param("r");
}
sub login_form { 
    my $c = shift;
    my $errs = shift;

    my $t = $c->load_tmpl;
    $t->param($errs) if $errs;
    return $t->output;
}
sub form_process {
    my $c = shift;

    # Validate the form against a profile. If it fails validation, re-display
    # the form for the user with their data pre-filled and the errors highlighted. 
    my ($results, $err_page) = $c->check_rm('form_display','_form_profile');
    return $err_page if $err_page; 

    return $c->forward('form_success');   
}

# Return a Data::FormValidator profile
sub _form_profile {
    my $c = shift;
    return {
        required => 'email',
    };
}

sub form_success { } 

1;
