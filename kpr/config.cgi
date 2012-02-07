use strict;
use warnings;

# -*- Mode: Perl -*-
#
# 1. Configure section
#
my $Password = 'password';
my $site_title = "新規ウェブサイト";
my $site_id    = "SAMPLE1";
my $Email_Add = 'master@domain';
my $Site_Header = <<'__HERE__';
<ul><li></li></ul>
<h2>主な記事</h2>
<dl>
  <dt>KPRの紹介</dt>
  <dd>ディレクトリ指向のウェブサイト構築システム「KPR」の配布。「ブログ」との比較。</dd>
</dl>
__HERE__

my $document_footer = <<'__HERE__';
__HERE__

#
# END of the configure section
# 
