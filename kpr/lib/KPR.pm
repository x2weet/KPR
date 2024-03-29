# 
# KPR.pm
#
#   Author: Ryota Wada
#     Date: Wed Mar 21 15:56:44 2012. (JST)
#
package KPR;
use strict;
use warnings;
use feature qw/say switch/;
use base 'CGI::Application';

use Carp qw/carp croak/;

use CGI::Application::Plugin::ConfigAuto (qw/cfg/);
use CGI::Application::Plugin::Session;
use CGI::Application::Plugin::Redirect;
# use DateTime;
# use DateTime::Format::ISO8601;
# use DateTime::Format::W3CDTF;
use POSIX qw/strftime/;
use File::Spec::Functions qw/catfile splitdir catdir/;

use KPR::Document;

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

my %run_modes = (
    'login_form' => \&kpr_login,
    'menu_form' => \&kpr_menu,
    'doc_create_form' => \&kpr_doc_create,
    'doc_delete_form' => \&kpr_doc_delete,
    'doc_update_form' => \&kpr_doc_update,
    'dir_create_form' => \&kpr_dir_create,
    'dir_delete_form' => \&x_form,
    'dir_update_form' => \&x_form,
);
sub setup {
    my $self = shift;

    $self->run_modes(%run_modes);
    $self->mode_param('resource');
    $self->query->param('resource', $self->param('resource') );# overriding 
    $self->tmpl_path($self->cfg('TemplateDirectory'));
    $self->param('WebsiteDirectory', $self->cfg('WebsiteDirectory'));
}

sub kpr_login {
    my $self = shift;
    my $errs = shift;
    
    my $q = $self->query;

    given ($q->param('MODE')) {
        when ('logout') {
            if (defined $q->param('PASSWORD') and $q->param('PASSWORD') eq 'qwerty') {
                $self->session->delete;
            } else {
                # certification error routine
            }
        }
        when ('login') {
            if (defined $q->param('PASSWORD') and $q->param('PASSWORD') eq 'qwerty') {
                $self->session->new;
                $self->redirect('menu_form.cgi');
            } else {
                # certification error routine
            }
        }
        default {
            my $t = $self->load_tmpl;
            $t->param($errs) if $errs;
            return $t->output;
        }
    }
}
sub kpr_menu {
    my $self = shift;
    my $errs = shift;

    my $q = $self->query;

    given ($q->param('MODE')) {
        when ("command") {
            if (defined $run_modes{$q->param('KPRCOMMAND')}) {
                $self->redirect($q->param('KPRCOMMAND') . '.cgi');
            }
            else {
                # error routine
            }
        }
        default {
            my $t = $self->load_tmpl;
            $t->param($errs) if $errs;
            return $t->output;
        }
    }
}
#
# Document
#
sub kpr_doc_create {
    my $self = shift;
    my $errs = shift;

    my $q = $self->query;

    given ($q->param('MODE')) {
        when ("command") {
            $self->create_document();
            $self->redirect('menu_form.cgi');
        }
        default {
            my $t = $self->load_tmpl;
            $t->param($errs) if $errs;
            return $t->output;
        }
    }
}
sub kpr_doc_update {
    my $self = shift;
    my $errs = shift;

    my $q = $self->query;

    given ($q->param('MODE')) {
        when ("command") {
            $self->create_document();
            $self->redirect('menu_form.cgi');
        }
        when ("input") {
            my $t = $self->load_tmpl('doc_update_form.input.html');
            my %data = $self->parse_document();
            $data{FULLNAME} = $q->param('FULLNAME');
            foreach my $key ('FULLNAME', 'TITLE', 'DESC', 'BODY') {
                $t->param($key, $data{$key});
            }
            return $t->output;
        }
        defalut {
            my $t = $self->load_tmpl('doc_update_form.html');
            $t->param($errs) if $errs;
            return $t->output;
        }
    }
}
sub kpr_doc_delete {
    my $self = shift;
    my $errs = shift;

    my $q = $self->query;

    given ($q->param('MODE')) {
        when ("command") {
            my $file_path = $self->cfg('WebsiteDirectory') . $self->cfg('SiteID').'/'. $q->param('ID') . '.html';

            unlink $file_path
                or croak $!;
            $self->redirect('menu_form.cgi');
        }
        default {
            my $t = $self->load_tmpl;
            $t->param($errs) if $errs;
            return $t->output;
        }
    }
}
#
# Directory
#
sub kpr_dir_create {
    my $self = shift;
    my $errs = shift;

    my $q = $self->query;

    if ($q->param('MODE') eq "command") {
        my $dir_path = $self->cfg('WebsiteDirectory') . $self->cfg('SiteID').'/'. $q->param('ID');
        
        mkdir $dir_path
            or croak $!;
        $self->redirect('menu_form.cgi');
    }
    else { # default
        my $t = $self->load_tmpl;
        $t->param($errs) if $errs;
        return $t->output;
    }
}
sub kpr_dir_delete { }
sub kpr_dir_update { }

sub create_document {
    my $self = shift;
    
    my $q = $self->query;

    my $file_path; 
    if ($q->param('ID')) {
        $file_path = catfile(
            splitdir($self->cfg('WebsiteDirectory')), $self->cfg('SiteID'), splitdir($q->param('PATH')), $q->param('ID').'.html');
    }
    else {
        $file_path = catfile(
            splitdir($self->cfg('WebsiteDirectory')), $self->cfg('SiteID'), splitdir($q->param('FULLNAME').'.html'));
    }
    my $author = $self->cfg('Author');
    my $desc = $q->param('DESC');
    my $keywords = "";# $q->param('KEYWORDS')
    my $title = $q->param('TITLE');
    my $body = $q->param('BODY');
    my $navi = "";
    my $css = q(  ).qq(<link rel="stylesheet" href=").$self->cfg('SiteStylesheet').qq(" type="text/css" />).qq(\n);
    my $links = "";
    #    my $f = DateTime::Format::ISO8601->new();
    my $date = strftime('%Y-%m-%d', localtime());
    my $status = <<__HERE__;
<dl class="status">
  <dt>最終更新</dt>
  <dd>$date</dd>
</dl>

__HERE__

    my $fh;
    open $fh, '>', $file_path 
        or croak $! . $file_path;
    print $fh <<__HERE__;
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja" lang="ja">
<head>
  <meta name="author" content="$author" />
  <meta name="description" content="$desc" />
  <meta name="keywords" content="$keywords" />
$links$css  <title>$title</title>
</head>
<body>

$navi<h1>$title</h1>

$status$body

</body>
</html>
__HERE__
    close $fh;
    return;
}
sub parse_document {
    my $self = shift;
    
    my $q = $self->query;

    my $file_path = 
        catfile(
            splitdir($self->cfg('WebsiteDirectory')), $self->cfg('SiteID'), splitdir($q->param('FULLNAME').'.html')
        );

    my $d = KPR::Document->new();
    my $doc = "";
    my $fh;
    open $fh, '<', $file_path
        or croak $!;
    while (my $line = <$fh>) {
        $doc .= $line;
    }
    close $fh;
    
    $d->parse($doc);
    $d->eof;

    my $cgi = CGI->new;
    $cgi->charset('utf-8');
    
    my %data;
    $data{TITLE} = $d->findnodes('/html/head/title')->to_literal;
    $data{AUTHOR} = $d->findnodes('/html/head/meta[@name="author"]/@content')->to_literal;
    $data{DESC} = $d->findnodes('/html/head/meta[@name="description"]/@content')->to_literal;
    $data{BODY} = $cgi->escapeHTML(
        join "", map {$_->as_HTML} $d->findnodes('/html/body/h1/following-sibling::*[@class!="status"]'));
    $data{LASTMF} = $d->findnodes('/html/body//dl[@class="status"]/dd')->to_literal;

    return %data;
}

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

1;
