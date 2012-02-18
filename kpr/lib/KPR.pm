# 
# KPR.pm
#
#   Author: Ryota Wada
#     Date: Sat Feb 18 20:17:19 2012. (JST)
#
package KPR;
use strict;
use warnings;
use base 'CGI::Application';

use CGI::Application::Plugin::ConfigAuto (qw/cfg/);
use CGI::Application::Plugin::Session;
use CGI::Application::Plugin::Redirect;

sub cgiapp_init {
    my $self = shift;
    $self->SUPER::cgiapp_init(@_);
    $self->session_config(
        CGI_SESSION_OPTIONS => [ "driver:File", $self->query, { Directory => './session' }, ],
        COOKIE_PARAMS       => { -path   => '/',
                                -expires => '+2h', },
        SEND_COOKIE         => 1,
    );
}
sub setup {
    my $self = shift;

    $self->run_modes(
        'login_form' => \&kpr_login,
        'menu_form' => \&kpr_menu,
        'doc_create_form' => \&kpr_doc_create,
        'doc_delete_form' => \&x_form,
        'doc_update_form' => \&x_form,
        'dir_create_form' => \&kpr_dir_create,
        'dir_delete_form' => \&x_form,
        'dir_update_form' => \&x_form,
    );
    $self->mode_param('resource');
    $self->query->param('resource', $self->param('resource') );# overriding 
    $self->tmpl_path($self->cfg('TemplateDirectory'));

    $self->param('WebsiteDirectory', $self->cfg('WebsiteDirectory'));
    # debug
    # open my $fh, '>', 'test.txt' or die $!;
    # my %d = $self->cfg;
    # print $fh $self->tmpl_path();
    # close $fh;

}

sub kpr_login {
    my $self = shift;
    my $errs = shift;
    
    my $q = $self->query;

    if ($q->param('MODE') eq 'logout') {
        if (defined $q->param('PASSWORD') and $q->param('PASSWORD') eq 'qwerty') {
            $self->session->delete;
        }
        else {
            # certification error routine
        }
    }
    elsif ($q->param('MODE') eq 'login') {
        if (defined $q->param('PASSWORD') and $q->param('PASSWORD') eq 'qwerty') {
            $self->session->new;
            $self->redirect('menu_form.cgi');
        }
        else {
            # certification error routine
        }
    }
    else { # default
        my $t = $self->load_tmpl;
        $t->param($errs) if $errs;
        return $t->output;
    }
}
sub kpr_menu {
    my $self = shift;
    my $errs = shift;

    my $q = $self->query;

    if ($q->param('MODE') eq "command") {
        if (defined $self->run_modes($q->param('KPRCOMMAND'))) {
            $self->redirect($q->param('KPRCOMMAND') . '.cgi');
        }
        else {
            # error routine
        }
    }
    else { # default
        my $t = $self->load_tmpl;
        $t->param($errs) if $errs;
        return $t->output;
    }
}
sub kpr_doc_create {
    my $self = shift;
    my $errs = shift;

    my $q = $self->query;

    if ($q->param('MODE') eq "command") {
        my $file_path = $self->cfg('WebsiteDirectory') . $self->cfg('SiteID').'/'. $q->param('ID') . '.html';

        my $desc = $q->param('DESC');
        my $title = $q->param('TITLE');
        my $fh;
        open $fh, '>', $file_path 
            or die $!;
        print $fh <<__HERE__;
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html lang="ja">
<head>
  <meta name="author" content="">
  <meta name="description" content="$desc">
  <meta name="keyword" content="">
  <link rel="stylesheet" href="" type="text/css">
  <title>$title</title>
</head>
<body>

<h1>$title</h1>

__HERE__
        print $fh $q->param('BODY');
        print $fh <<__HERE__;
</body>
</html>
__HERE__
        $self->redirect('menu_form.cgi');
    }
    elsif ($q->param('MODE') eq "confirm") {
        # confirm routine
    }
    else { # default
        my $t = $self->load_tmpl;
        $t->param($errs) if $errs;
        return $t->output;
    }
}
sub kpr_dir_create {
    my $self = shift;
    my $errs = shift;

    my $q = $self->query;

    if ($q->param('MODE') eq "command") {
        my $dir_path = $self->cfg('WebsiteDirectory') . $self->cfg('SiteID').'/'. $q->param('ID');
        
        mkdir $dir_path
            or die $!;
        $self->redirect('menu_form.cgi');
    }
    elsif ($q->param('MODE') eq "confirm") {
        # confirm routine
    }
    else { # default
        my $t = $self->load_tmpl;
        $t->param($errs) if $errs;
        return $t->output;
    }
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
    my $self = shift;
 
    # Redirect to login, if necessary
    unless (
        1
        # $self->session->param('logged_in')
    ) {
        $self->redirect('login_form.cgi');
    }
    else {
        $self->header_add( -type => 'text/html; charset=UTF-8' );
    }
}

sub cgiapp_postrun {
    my $self = shift;

}

1;
