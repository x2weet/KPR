#
# KPR System  -- a compact CMS --
#
#  Author: Ryota Wada
#    Date: Mon Feb  6 13:03:12 2012.
#
# ----

#
# @@ 要修正の箇所多数有り
#
package KPR;
use _CGI;


# Global variables definition section
my $CR = "\x0D";
my $LF = "\x0A";
my $CRLF = $CR.$LF;
my $q = new CGI;
my $site_title = '苺の育成';
my $Header = <<'__HERE__';
<!DOCTYPE html PUBLIC "ISO/IEC 15445:2000//DTD HTML//EN">
<html lang="ja">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=EUC-JP">
  <meta name="description" lang="ja" content="">
  <link rel="stylesheet" type="text/css" href="/css/bsp.css">
  <title>KPR ログイン</title>
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

<h2>ログイン</h2>
<form action="index.cgi" method="POST">
<dl>
	<dt>パスワード</dt>
	<dd><input type="password" name="X"></dd>
	<dd><input type="hidden" name="SECTIONNAME" value="00login">
	<input type="submit" value="ログイン"></dd>
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
<input type="submit" value="ログアウト"></li></ul>
</form>

<h2>作成オブジェクト選択</h2>
<form action="index.cgi" method="POST">
<dl>
	<dt>作成オブジェクト</dt>
	<dd><label><input type="radio" name="OBJTYPE" value="00page" checked>ページ</label></dd>
	<dd><label><input type="radio" name="OBJTYPE" value="00dir">ディレクトリ</label></dd>
	<dd><input type="hidden" name="SECTIONNAME" value="00type">
	<input type="submit" value="詳細入力画面へ"></dd>
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
<input type="submit" value="ログアウト"></li></ul>
</form>

<h2>ページ作成</h2>
<form action="index.cgi" method="POST">
<dl>
	<dt>作成先</dt>
	<dd><input type="text" name="P" value="" size="48"></dd>
	<dt>ページID</dt>
	<dd><input type="text" name="I" value="" size="48">.html</dd>
	<dt>ページタイトル</dt>
	<dd><input type="text" name="S" value="無題ドキュメント" size="48"></dd>
	<dt>内容の要約</dt>
	<dd><input type="text" name="D" value="" size="48"></dd>
	<dt>本文</dt>
	<dd><label><input type="radio" name="C" value="ul" checked>ulとしてマーク付け</label></dd>
	<dd><label><input type="radio" name="C" value="normal">地のSGML</label></dd>
	<dd><textarea rows="16" cols="48" name="B"></textarea></dd>
	<dd><input type="hidden" name="SECTIONNAME" value="00page">
	<input type="submit" value="作成"></dd>
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
<input type="submit" value="ログアウト"></li></ul>
</form>

<h2>ディレクトリ作成</h2>
<form action="index.cgi" method="POST">
<dl>
	<dt>作成先</dt>
	<dd><input type="text" name="P" value="" size="48"></dd>
	<dt>ディレクトリID</dt>
	<dd><input type="text" name="I" value="" size="48">.html</dd>
	<dt>ディレクトリ名</dt>
	<dd><input type="text" name="S" value="新規ディレクトリ" size="48"></dd>
	<dt>内容の要約</dt>
	<dd><input type="text" name="D" value="" size="48"></dd>
	<dd><input type="hidden" name="SECTIONNAME" value="00page">
	<input type="submit" value="作成"></dd>
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
<input type="submit" value="ログアウト"></li></ul>
</form>

<h2>作成成功</h2>
<ul><li>作成作業は正常に終了しました。</li></ul>
__HERE__
    
    $self->output_buffer($str);
}


# HTML文書の生成
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
  <dt>最終更新</dt> 
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

# ディレクトリの生成
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
# インデクス文書の生成
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
		
        if (-d $dir_item) { # win98seにてディレクトリ判定できず(常に偽)
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
    $toc and $toc = <<__HERE__; # 「索引」「内容」「インデクス」「コンテンツ」
<h2>目次</h2>

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
# ナヴィゲーション生成
#
sub get_navi_string {
    my $self = shift;

    my $path = $_[0];                   # "[Dir/]File.html"
    my @items = ();
    my $dummy = $site_id."/".$path;
	
    if ($path ne "index.html") {
        if ($dummy !~ /index\.html$/) { # ファイル
            $dummy =~ s/^(.+)\/.*/$1\/index\.html/ or die($!);
            if ($1 eq $site_id) {
                return '<ul class="navi"><li><a href="./">'.$site_title.'</a></li></ul>';
            } else {
                my ($title, $dsc) = get_title($dummy);
                push @items, '<li><a href="./">'.$title.'</a></li>';
            }
        }
        $dummy =~ s/^(.+)\/.*$/$1/ or die(); # "index.html"削除
		
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
	
    $date_string = sprintf("%d年%d月%d日", $elements[5] + 1970, $elements[4] + 1, $elements[3]);
}
sub get_date_string {
    my $source = $_[0];
    my @elements = localtime($source);
    return sprintf("%d年%d月%d日", $elements[5] + 1970, $elements[4] + 1, $elements[3]);
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
<title>KPRフォーム</title>
</head>
<body>

<h1>KPRフォーム</h1>

<ul>
<li><a href="http://HowToFill.html">作成フォーム記入方法</a></li>
</ul>

<h2>穴埋め</h2>
<form action="kpr.cgi" method="POST">
<fieldset>
	<legend><label><input type="radio" name="T" value="d" checked>文書の作成</label></legend>
	<dl>
	<dt>作成先</dt>
	<dd><input type="text" name="P" value="" size="48"></dd>
	<dt>文書ID</dt>
	<dd><input type="text" name="I" value="" size="48">.html</dd>
	<dt>文書タイトル</dt>
	<dd><input type="text" name="S" value="無題ドキュメント" size="48"></dd>
	<dt>内容の要約</dt>
	<dd><input type="text" name="D" value="" size="48"></dd>
	<dt>本文</dt>
	<dd><label><input type="radio" name="C" value="ul" checked>ulとしてマーク付け</label></dd>
	<dd><label><input type="radio" name="C" value="normal">地のSGML</label></dd>
	<dd><textarea rows="16" cols="48" name="B"></textarea></dd>
</dl>
</fieldset>

<fieldset>
	<legend><label><input type="radio" name="T" value="f">ディレクトリの作成</label></legend>
<dl>
	<dt>作成先</dt>
	<dd><input type="text" name="R" value=""></dd>
	<dt>ディレクトリID</dt>
	<dd><input type="text" name="K" value="">/</dd>
	<dt>ディレクトリタイトル</dt>
	<dd><input type="text" name="L" value="新規ディレクトリ"></dd>
	<dt>ディレクトリの説明文</dt>
	<dd><input type="text" name="N" value=""></dd>
</dl>
</fieldset>

<dl>
	<dt>パスワード</dt><dd><input type="password" name="X"></dd>
	<dt>コマンドの送信</dt><dd><input type="submit" value="作成(送信)"></dd>
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
  
    # アクセサの定義を省いているので直接代入（よろしくない...）
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
# ファイル/ディレクトリ作成作業完了後の
# HTTPレスポンス内容について
#
# このスクリプトのCGIとなるリソースに対する
# GETについては全て同一のサンプルフォームを返す。
#
# POSTを受けて、内部的に行動し、その結果が正常と判断された場合
# HTTPメッセージボディを含まないコード200のレスポンスを返す。# ←!
# その他、POSTメソッドを受けた場合のレスポンスは
# 例外無くHTTPメッセージボディを含まないものとする。

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

&lt;h2&gt;提供&lt;/h2&gt;
&lt;address&gt;&lt;/address&gt;-->


    # EOF

    1;
