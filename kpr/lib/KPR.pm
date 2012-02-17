# 
# KPR.pm
#
#   Author: Ryota Wada
#     Date: Wed Feb 15 23:19:15 2012. (JST)
#
package KPR;
use strict;
use warnings;
use base 'CGI::Application';

sub setup {
    my $c = shift;

    $c->start_mode('login_form');
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
    $c->mode_param("r");
}
sub x_form { 
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

# http://digit.que.ne.jp/work/index.cgi?Perl%E3%83%A1%E3%83%A2%2FCGI%3A%3AApplication%E3%83%A2%E3%82%B8%E3%83%A5%E3%83%BC%E3%83%AB
sub cgiapp_postrun {
    my $self = shift;
    my $bodyref = shift;
    # my $charset = uc($self->param('charset'));
    # my $charmap = { 'ISO-2022-JP' => 'jis', 'SHIFT_JIS' => 'sjis', 'EUC-JP' => 'euc', 'UTF-8' => 'utf8' };
    # if (defined($charset) and defined($charmap->{$charset})) {
    #     $self->header_add('-charset', $self->param('charset'));
    #     my $encode = $charmap->{$charset};
    #     my @lines = map { Jcode->new($_)->$encode } split(/\n/, $$bodyref);
    #     $$bodyref = join("\n", @lines);
    # }
    $self->header_add( -type => 'text/html; charset=UTF-8' );
}
1;
