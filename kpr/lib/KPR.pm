#
# KPR System  -- a compact CMS --
#
#  Author: Ryota Wada
#    Date: Mon Feb  6 13:03:12 2012.
#
# ----

#
# @@ �׽����βս�¿��ͭ��
#
package KPR;
use _CGI;


# Global variables definition section
my $CR = "\x0D";
my $LF = "\x0A";
my $CRLF = $CR.$LF;
my $q = new CGI;
my $site_title = '���ΰ���';
my $Header = <<'__HERE__';
<!DOCTYPE html PUBLIC "ISO/IEC 15445:2000//DTD HTML//EN">
<html lang="ja">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=EUC-JP">
  <meta name="description" lang="ja" content="">
  <link rel="stylesheet" type="text/css" href="/css/bsp.css">
  <title>KPR ������</title>
</head>
<body>
__HERE__

#
my $Footer = <<'__HERE__';
</body>
</html>
__HERE__

my $runtime = time();

# 
sub new {
    my $class = shift;
    my $site_id = shift;
    return 
        bless { 
            "site_id" => $site_id,
            "q" => $q,
            "buffer" => [],
            "site_name" => $site_title,
            "header" => $Header,
            "footer" => $Footer,
        },
            $class;
}
# ---


sub cgiq {
    return $_[0]->{q};
}
sub add_buffer {
    my ($self, $contents) = @_;
    push @{$self->{buffer}}, $contents;
}
sub buffer {
    return join "", @{$_[0]->{buffer}};
}
sub clear_buffer {
    my $self = shift;
    $self->{buffer} = [];
}
sub run {
    my $self = shift;
    my $prevsect = $self->cgiq->param("SECTIONNAME");
    if ($prevsect eq "00login") {
        $self->show_create_object_type_routine;
    } elsif ($prevsect eq "00type") {
        my $objtype = $self->cgiq->param("OBJTYPE");
        if ($objtype eq "00page") {
            $self->show_page_form_routine;
        } elsif ($objtype eq "00dir") {
            $self->show_directory_form_routine;
        }
    } elsif ($prevsect eq "00page") {
        $self->show_accept_msg_routine;
    } elsif ($prevsect eq "00dir") {
        $self->show_accept_msg_routine;
    } else {
        $self->show_login_form_routine;
    }
    print $self->buffer;
    return;
}
sub show_login_form_routine {
    my $self = shift;
    my $str = <<'__HERE__';
<h1>KPR</h1>

<h2>������</h2>
<form action="index.cgi" method="POST">
<dl>
	<dt>�ѥ����</dt>
	<dd><input type="password" name="X"></dd>
	<dd><input type="hidden" name="SECTIONNAME" value="00login">
	<input type="submit" value="������"></dd>
</dl>
</form>
__HERE__
    
    $self->output_buffer($str);
    return;
}

sub show_create_object_type_routine {
    my $self = shift;
    my $str = <<'__HERE__';
<h1>KPR</h1>

<form action="index.cgi" method="POST">
<ul><li><input type="hidden" name="KILLSESSION" value="ON">
<input type="submit" value="��������"></li></ul>
</form>

<h2>�������֥�����������</h2>
<form action="index.cgi" method="POST">
<dl>
	<dt>�������֥�������</dt>
	<dd><label><input type="radio" name="OBJTYPE" value="00page" checked>�ڡ���</label></dd>
	<dd><label><input type="radio" name="OBJTYPE" value="00dir">�ǥ��쥯�ȥ�</label></dd>
	<dd><input type="hidden" name="SECTIONNAME" value="00type">
	<input type="submit" value="�ܺ����ϲ��̤�"></dd>
</dl>
</form>
__HERE__
    
    $self->output_buffer($str);
}

sub show_page_form_routine {
    my $self = shift;
    my $str = <<'__HERE__';
<h1>KPR</h1>

<form action="index.cgi" method="POST">
<ul><li><input type="hidden" name="KILLSESSION" value="ON">
<input type="submit" value="��������"></li></ul>
</form>

<h2>�ڡ�������</h2>
<form action="index.cgi" method="POST">
<dl>
	<dt>������</dt>
	<dd><input type="text" name="P" value="" size="48"></dd>
	<dt>�ڡ���ID</dt>
	<dd><input type="text" name="I" value="" size="48">.html</dd>
	<dt>�ڡ��������ȥ�</dt>
	<dd><input type="text" name="S" value="̵��ɥ������" size="48"></dd>
	<dt>���Ƥ�����</dt>
	<dd><input type="text" name="D" value="" size="48"></dd>
	<dt>��ʸ</dt>
	<dd><label><input type="radio" name="C" value="ul" checked>ul�Ȥ��ƥޡ����դ�</label></dd>
	<dd><label><input type="radio" name="C" value="normal">�Ϥ�SGML</label></dd>
	<dd><textarea rows="16" cols="48" name="B"></textarea></dd>
	<dd><input type="hidden" name="SECTIONNAME" value="00page">
	<input type="submit" value="����"></dd>
</dl>
</form>
__HERE__
    
    $self->output_buffer($str);
}

sub show_directory_form_routine {
    my $self = shift;
    my $str = <<'__HERE__';
<h1>KPR</h1>

<form action="index.cgi" method="POST">
<ul><li><input type="hidden" name="KILLSESSION" value="ON">
<input type="submit" value="��������"></li></ul>
</form>

<h2>�ǥ��쥯�ȥ����</h2>
<form action="index.cgi" method="POST">
<dl>
	<dt>������</dt>
	<dd><input type="text" name="P" value="" size="48"></dd>
	<dt>�ǥ��쥯�ȥ�ID</dt>
	<dd><input type="text" name="I" value="" size="48">.html</dd>
	<dt>�ǥ��쥯�ȥ�̾</dt>
	<dd><input type="text" name="S" value="�����ǥ��쥯�ȥ�" size="48"></dd>
	<dt>���Ƥ�����</dt>
	<dd><input type="text" name="D" value="" size="48"></dd>
	<dd><input type="hidden" name="SECTIONNAME" value="00page">
	<input type="submit" value="����"></dd>
</dl>
</form>
__HERE__
    
    $self->output_buffer($str);
}

sub show_accept_msg_routine {
    my $self = shift;

    if ($self->cgiq->param('SECTIONNAME') eq '00page') {
        #
        #
    } elsif ($self->cgiq->param('SECTIONNAME') eq '00dir') {
        #
        #
    }
    my $str = <<'__HERE__';
<h1>KPR</h1>

<form action="index.cgi" method="POST">
<ul><li><input type="hidden" name="KILLSESSION" value="ON">
<input type="submit" value="��������"></li></ul>
</form>

<h2>��������</h2>
<ul><li>������Ȥ�����˽�λ���ޤ�����</li></ul>
__HERE__
    
    $self->output_buffer($str);
}


# HTMLʸ�������
sub create_file {
    my $self = shift;
    my $fileid = shift;
    my $path = shift;

    my $date_str = get_date_string($runtime);
    my $navi_str = get_navi_string($dir_string.$file_identifier.".html");
	
    my $body = "";
    if ($self->cgiq->param('C') eq 'ul') {
        my @lines = split /(\x0D\x0A){2,}|\x0D{2,}|\x0A{2,}/, $self->cgiq->param('B');
        foreach my $line (@lines) {
            $line =~ s/$CR|$LF//g;
            next unless $line;
            $body .= "<li>$line</li>";
        }
        $body = "<ul>" . $body . "</ul>";
    } elsif ($q->param('C') eq 'normal') {
        $body = $self->cgiq->param('B');
    } else {
        die("");
    }

    my $buff = <<"__HERE__";
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html lang="ja">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=Shift_JIS">
	<meta name="description" lang="ja" content="$description">
    $stylesheet_string
    $relational_documents
    <link rev="made" href="$Email_Add">
    <title>$title</title>
</head>
<body>

$navi_str

<h1>$title</h1>

<dl class="status">
  <dt>�ǽ�����</dt> 
  <dd>$date_str</dd>
</dl>

$body

$document_footer
</body>
</html>
__HERE__

    #jcode::euc2sjis(\$buff);
    {
        local *DOCUMENT;
        open DOCUMENT, ">". "$site_id/$dir_string$file_identifier.html" or die($!);
        binmode DOCUMENT;
        print DOCUMENT $buff;
        close DOCUMENT;
    }
	
    $self->create_toc($dir_string."index.html"); # ex."/index.html"
    return;
}

# �ǥ��쥯�ȥ������
sub create_dir {
    my $self = shift;
    my $site_id = $self->{site_id};
	
    unless (-e "./websites/$site_id/$dir_path$dir_id") {
        mkdir "./websites/$site_id/$dir_path$dir_id", 0777 or die($!);
    }
	
    $self->create_toc($dir_path.$dir_id."/index.html");
    #$S++;#?
    $self->create_toc($dir_path."index.html");
    return;
}




#
# ����ǥ���ʸ�������
#
sub create_toc {
    my $self = shift;
    my $path = shift;                   # "[BaseDir/]Dir/index.html"
    my $navi_str = $self->get_navi_string($path);
    my $site_id = $self->{site_id};
    #my $tree = set_toc_value($site_id."/".$path);
	
    my $dummy = $site_id."/".$path;
    $dummy =~ s/^(.+)\/.*$/$1/;
	
    my $site_header;
    my $title_str;
    my $dsc;
    if ($dummy eq "$site_id") {
        $site_header = $Site_Header;
        $title_str = $site_title;
        $dsc = "";                      # new $Site_Dsc?
    } else {
        $site_header = "";
        if ($q->param("T") eq "f") {
            unless ($S) {
                $title_str = $dir_title;
                $dsc = $User_Param_N;
            } else {
                ($title_str, $dsc) = get_title($site_id."/".$path);
            }
        } else {
            ($title_str, $dsc) = get_title($site_id."/".$path);
        }
    }
	
    my $toc = "";
    local *DIR;
    opendir DIR, $dummy or die($!.$dummy);
    my $dir_item;
    while ($dir_item = readdir DIR) {
        next if $dir_item eq ".html" || $dir_item eq "index.html" || $dir_item eq "." || $dir_item eq "..";
        my($ttl, $dsc);
		
        if (-d $dir_item) { # win98se�ˤƥǥ��쥯�ȥ�Ƚ��Ǥ���(��˵�)
            ($ttl, $dsc) = get_title("$dummy/$dir_item/index.html");
            $toc .= qq@<dt><a href="$dir_item/">$ttl</a></dt>\n@;
            $dsc and $toc .= "<dd>$dsc</dd>\n";
        } elsif ($dir_item =~ /.*\.html?$/) {
            ($ttl, $dsc) = get_title("$dummy/$dir_item");
            $toc .= qq@<dt><a href="$dir_item">$ttl</a></dt>\n@;
            $dsc and $toc .= "<dd>$dsc</dd>\n";
        } else {
            #
            ($ttl, $dsc) = get_title("$dummy/$dir_item/index.html");
            $toc .= qq@<dt><a href="$dir_item/">$ttl</a></dt>\n@;
            $dsc and $toc .= "<dd>$dsc</dd>\n";
        }
    } 
    $toc and $toc = <<__HERE__; # �ֺ����ס����ơס֥���ǥ����ס֥���ƥ�ġ�
<h2>�ܼ�</h2>

<dl>
$toc
</dl>
__HERE__

    my $tree = $toc;                    # copy
	
    my $buff = <<"__HERE__";
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html lang="ja">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=Shift_JIS">
	<meta name="description" lang="ja" content="$dsc">
$stylesheet_string$relational_documents	<link rev="made" href="$Email_Add">
	<title>$title_str</title>
</head>
<body>

$navi_str

<h1>$title_str</h1>

$site_header$tree

$document_footer
</body>
</html>
__HERE__

    jcode::euc2sjis(\$buff);
  
    local *TOC;
    open TOC, ">". "$dummy/index.html" or die($!);
    binmode TOC;
    print TOC $buff;
    close TOC;
	
    return 1;
}



#
# �ʥ����������������
#
sub get_navi_string {
    my $self = shift;

    my $path = $_[0];                   # "[Dir/]File.html"
    my @items = ();
    my $dummy = $site_id."/".$path;
	
    if ($path ne "index.html") {
        if ($dummy !~ /index\.html$/) { # �ե�����
            $dummy =~ s/^(.+)\/.*/$1\/index\.html/ or die($!);
            if ($1 eq $site_id) {
                return '<ul class="navi"><li><a href="./">'.$site_title.'</a></li></ul>';
            } else {
                my ($title, $dsc) = get_title($dummy);
                push @items, '<li><a href="./">'.$title.'</a></li>';
            }
        }
        $dummy =~ s/^(.+)\/.*$/$1/ or die(); # "index.html"���
		
        my $c = 0;
        while ($dummy =~ s/^(.+)\/.*$/$1/) {
            last if $dummy eq $site_id;
            my ($title, $dsc) = get_title("$dummy/index.html");
            unshift @items, '<li><a href="'.('../' x ++$c).'">'.$title.'</a></li>';
        }
        unshift @items, '<li><a href="'.('../' x ++$c).'">'.$site_title.'</a></li>';
        my $buff = join("", @items);
        return $buff ? '<ul class="navi">'.$buff.'</ul>' : "";
    }
    return;
}


#
#
# @_[0]: file name
sub get_title {
    my $self = shift;
    my $fileid = shift;

    {
        local *FILE;
        open FILE, "<". $fileid or die($!.$fileid);
        my $buff;
        {
            local $/ = "</head>";
            $buff = <FILE>;
        }
        $buff =~ /<meta name="description" lang="ja" content="(.*)?">/ or die($fileid.$buff);
        my $dsc = $1;
        $buff =~ /<title>(.*)<\/title>/ or die($fileid.$buff);
    }
    return $1, $dsc;
}

sub set_date_string {
    my $source = $_[0] ? $_[0] : $runtime;
    my @elements = localtime($source);
	
    $date_string = sprintf("%dǯ%d��%d��", $elements[5] + 1970, $elements[4] + 1, $elements[3]);
}
sub get_date_string {
    my $source = $_[0];
    my @elements = localtime($source);
    return sprintf("%dǯ%d��%d��", $elements[5] + 1970, $elements[4] + 1, $elements[3]);
}

sub reply_form {
    my $q = $_[0];
    my $buff = <<"__HERE__";
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=Shift_JIS">
<meta name="description" lang="ja" content="">
<link rel="stylesheet" type="text/css" href="/css/bsp.css">
<title>KPR�ե�����</title>
</head>
<body>

<h1>KPR�ե�����</h1>

<ul>
<li><a href="http://HowToFill.html">�����ե����൭����ˡ</a></li>
</ul>

<h2>�����</h2>
<form action="kpr.cgi" method="POST">
<fieldset>
	<legend><label><input type="radio" name="T" value="d" checked>ʸ��κ���</label></legend>
	<dl>
	<dt>������</dt>
	<dd><input type="text" name="P" value="" size="48"></dd>
	<dt>ʸ��ID</dt>
	<dd><input type="text" name="I" value="" size="48">.html</dd>
	<dt>ʸ�񥿥��ȥ�</dt>
	<dd><input type="text" name="S" value="̵��ɥ������" size="48"></dd>
	<dt>���Ƥ�����</dt>
	<dd><input type="text" name="D" value="" size="48"></dd>
	<dt>��ʸ</dt>
	<dd><label><input type="radio" name="C" value="ul" checked>ul�Ȥ��ƥޡ����դ�</label></dd>
	<dd><label><input type="radio" name="C" value="normal">�Ϥ�SGML</label></dd>
	<dd><textarea rows="16" cols="48" name="B"></textarea></dd>
</dl>
</fieldset>

<fieldset>
	<legend><label><input type="radio" name="T" value="f">�ǥ��쥯�ȥ�κ���</label></legend>
<dl>
	<dt>������</dt>
	<dd><input type="text" name="R" value=""></dd>
	<dt>�ǥ��쥯�ȥ�ID</dt>
	<dd><input type="text" name="K" value="">/</dd>
	<dt>�ǥ��쥯�ȥ꥿���ȥ�</dt>
	<dd><input type="text" name="L" value="�����ǥ��쥯�ȥ�"></dd>
	<dt>�ǥ��쥯�ȥ������ʸ</dt>
	<dd><input type="text" name="N" value=""></dd>
</dl>
</fieldset>

<dl>
	<dt>�ѥ����</dt><dd><input type="password" name="X"></dd>
	<dt>���ޥ�ɤ�����</dt><dd><input type="submit" value="����(����)"></dd>
</dl>

</form>
</body>
</html>
__HERE__
    jcode::euc2sjis(\$buff);
    return $q->header(-type=>"text/html", -charset=>"Shift_JIS")
        . $buff;
}

sub output_buffer {
    my $self = shift;
    my $str = shift;
    $self->add_buffer($self->cgiq->header(-type => "text/html", -charset => "EUC-JP"));
    $self->add_buffer($self->{header});
    $self->add_buffer($str);
    $self->add_buffer($self->{footer});
    return;
}

1;
__END__





my (
    $description,
    $title,
    $date_string,
    $dir_string,
    $file_identifier,
    $document_body,
    $stylesheet_string,
    $relational_documents,
    $dir_path,
    $dir_id,
    $dir_title,
    $toc,
    $navi,
    $User_Param_N,
    $S,
);

# --
#
#
sub set_user_params {
    my $self = $_[0];
  
    # ���������������ʤ��Ƥ���Τ�ľ�������ʤ�����ʤ�...��
    #
    $self->{'dir_string'} = $self->cgiq->param("P");
    $self->{'dir_string'} and $self->{'dir_string'} .= "/"; #
    $file_identifier = $self->cgiq->param("I");
	
    $description = $self->cgiq->param("D");
    jcode::sjis2euc(\$description);
	
    $document_body = $self->cgiq->param("B");
    jcode::sjis2euc(\$document_body);
	
    $title = $self->cgiq->param("S");
    jcode::sjis2euc(\$title);
	
    $relational_documents = qq(\t<link rel="index" href="./">\n\t<link rel="stylesheet" type="text/css" href="/kpr/objects/kprmain.css">\n);

    $dir_path  = $self->cgiq->param("R");         # || ".";
    $dir_path and $dir_path .= "./websites/";     #
    $dir_id    = $self->cgiq->param("K");
    $dir_title = $self->cgiq->param("L");
    jcode::sjis2euc(\$dir_title);
	
    $User_Param_N = $self->cgiq->param("N");
    jcode::sjis2euc(\$User_Param_N);
    return;
}








# --------------------------------------------
# �ե�����/�ǥ��쥯�ȥ������ȴ�λ���
# HTTP�쥹�ݥ����ƤˤĤ���
#
# ���Υ�����ץȤ�CGI�Ȥʤ�꥽�������Ф���
# GET�ˤĤ��Ƥ�����Ʊ��Υ���ץ�ե�������֤���
#
# POST������ơ�����Ū�˹�ư�������η�̤������Ƚ�Ǥ��줿���
# HTTP��å������ܥǥ���ޤޤʤ�������200�Υ쥹�ݥ󥹤��֤���# ��!
# ����¾��POST�᥽�åɤ���������Υ쥹�ݥ󥹤�
# �㳰̵��HTTP��å������ܥǥ���ޤޤʤ���ΤȤ��롣

=comment

sub reply_http() {
  my $buff;
  
  if ($ENV{"REQUEST_METHOD"} eq "POST") {
    $buff = "HTTP/1.1 200 OK" . $CRLF x 2;
  }
  elsif ($ENV{"REQUEST_METHOD"} eq "GET") {
    $buff = reply_form();
  }
  else {
    $buff = "";
  }
  print $buff;
}

=cut


__END__

<!--


&lt;hr&gt;

&lt;h2&gt;��&lt;/h2&gt;
&lt;address&gt;&lt;/address&gt;-->


    # EOF

    1;
