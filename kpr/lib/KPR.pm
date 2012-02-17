# 
# KPR.pm
#
#   Author: Ryota Wada
#     Date: Sat Feb 18 00:35:13 2012. (JST)
#
package KPR;
use strict;
use warnings;
use base 'CGI::Application';

use CGI::Application::Plugin::ConfigAuto (qw/cfg/);

sub setup {
    my $c = shift;

    $c->run_modes(
        'login_form' => \&x_form,
        'menu_form' => \&x_form,
        'doc_create_form', => \&x_form,
        'doc_delete_form', => \&x_form,
        'doc_update_form', => \&x_form,
        'dir_create_form', => \&x_form,
        'dir_delete_form', => \&x_form,
        'dir_update_form', => \&x_form,
    );
    $c->mode_param('resource');
    $c->query->param('resource', $c->param('resource') );

    $c->tmpl_path($c->cfg('TemplateDirectory'));

    # debug
    # open my $fh, '>', 'test.txt' or die $!;
    # my %d = $c->cfg;
    # print $fh $c->tmpl_path();
    # close $fh;

}

sub x_form { 
    my $self = shift;
    my $errs = shift;

    my $t = $self->load_tmpl;
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

sub cgiapp_prerun {
}
# http://digit.que.ne.jp/work/index.cgi?Perl%E3%83%A1%E3%83%A2%2FCGI%3A%3AApplication%E3%83%A2%E3%82%B8%E3%83%A5%E3%83%BC%E3%83%AB
sub cgiapp_postrun {
    my $self = shift;
    $self->header_add( -type => 'text/html; charset=UTF-8' );
}

1;
