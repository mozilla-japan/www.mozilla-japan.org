
/*********

mirrors_jp_list.js

mirrors_jp.html 40版用 2004.03.09 chado

2004.03.13  chado
            ディレクトリリストの Camino リリース にゴミが残ってたのを除去。
            ミラーリストに リリースページでおすすめの ring.riken.go.jp を追加。
*********/

/*****  make mirrors list  *****/

var mirrors = new Array;
var aid = 0;

/***
     mirrors[aid++] = 'ミラーサイト基準ディレクトリ,';
***/

mirrors[aid++] = 'ftp://ring.riken.go.jp/archives/net/www/mozilla/'; // 2004.03.13 追加
mirrors[aid++] = 'http://ring.riken.go.jp/archives/net/www/mozilla/'; // 2004.03.13 追加
mirrors[aid++] = '-'; // 区切り線
mirrors[aid++] = 'ftp://ftp.cin.nihon-u.ac.jp/pub/net/www/mozilla/'; // checked 2004.03.09
mirrors[aid++] = 'ftp://ring.exp.fujixerox.co.jp/pub/net/www/mozilla/'; // checked 2004.03.09
mirrors[aid++] = 'ftp://ring.so-net.ne.jp/pub/net/www/mozilla/'; // checked 2004.03.09
//mirrors[aid++] = 'ftp://ftp.jaist.ac.jp/pub/Mozilla/'; // 更新されてない 2004.03.09
mirrors[aid++] = 'ftp://ring.aist.go.jp/pub/net/www/mozilla/'; // checked 2004.03.09
mirrors[aid++] = 'ftp://ftp.lab.kdd.co.jp/Mozilla/'; // checked 2004.03.09
mirrors[aid++] = '-'; // 区切り線
mirrors[aid++] = 'ftp://ftp.kddlabs.co.jp/Mozilla/'; // checked 2004.03.09
mirrors[aid++] = 'http://ftp.t.ring.gr.jp/pub/net/www/mozilla/'; // checked 2004.03.09
mirrors[aid++] = 'ftp://ring.asahi-net.or.jp/pub/net/www/mozilla/'; // checked 2004.03.09
mirrors[aid++] = 'ftp://ring.crl.go.jp/pub/net/www/mozilla/'; // checked 2004.03.09
mirrors[aid++] = 'ftp://ring.astem.or.jp/pub/net/www/mozilla/'; // checked 2004.03.09
mirrors[aid++] = 'ftp://ring.ip-kyoto.ad.jp/pub/net/www/mozilla/'; // checked 2004.03.09
mirrors[aid++] = 'ftp://ring.shibaura-it.ac.jp/pub/net/www/mozilla/'; // checked 2004.03.09
mirrors[aid++] = 'ftp://ring.pwd.ne.jp/pub/net/www/mozilla/'; // checked 2004.03.09
mirrors[aid++] = 'ftp://ring.tains.tohoku.ac.jp/pub/net/www/mozilla/'; // checked 2004.03.09
mirrors[aid++] = 'ftp://ring.toyama-ix.net/pub/net/www/mozilla/'; // checked 2004.03.09
mirrors[aid++] = 'ftp://ring.edogawa-u.ac.jp/pub/net/www/mozilla/'; // checked 2004.03.09
mirrors[aid++] = 'ftp://ring.data-hotel.net/pub/net/www/mozilla/'; // checked 2004.03.09
mirrors[aid++] = 'ftp://ring.nihon-u.ac.jp/pub/net/www/mozilla/'; // checked 2004.03.09
mirrors[aid++] = 'ftp://ring.hosei.ac.jp/pub/net/www/mozilla/'; // checked 2004.03.09
mirrors[aid++] = 'ftp://ring.wakwak.com/pub/net/www/mozilla/'; // checked 2004.03.09
mirrors[aid++] = 'ftp://ring.qgpop.net/pub/net/www/mozilla/'; // checked 2004.03.09
mirrors[aid++] = 'ftp://ring.csi.ad.jp/pub/net/www/mozilla/'; // checked 2004.03.09
//mirrors[aid++] = 'ftp://ring.atr.jp/pub/net/www/mozilla/'; // notfound 2004.03.09
mirrors[aid++] = 'ftp://ring.shizuoka.ac.jp/pub/net/www/mozilla/'; // checked 2004.03.09
mirrors[aid++] = 'ftp://ring.airnet.ne.jp/pub/net/www/mozilla/'; // checked 2004.03.09
//mirrors[aid++] = 'ftp://ring.k-opti.com/pub/net/www/mozilla/'; // ftp soft ならつながる 2004.03.09
//mirrors[aid++] = 'ftp://ring.sbp-shimane.net/pub/net/www/mozilla/'; // mo1.7a ない。l10n はある。max 20 user 2004.03.09
mirrors[aid++] = 'ftp://ring.maffin.ad.jp/pub/net/www/mozilla/'; // checked 2004.03.09
//mirrors[aid++] = 'http://mirror.nucba.ac.jp/mirror/mozilla/mozilla.org/'; // 中身がない 2004.03.09
//mirrors[aid++] = 'ftp://mirror.nucba.ac.jp/mirror/mozilla/'; // connection refused 2004.03.09
mirrors[aid++] = '-'; // 区切り線
mirrors[aid++] = 'ftp://download.mozilla.org/pub/mozilla.org/'; // checked 2004.03.09
mirrors[aid++] = 'http://download.mozilla.org/pub/mozilla.org/'; // checked 2004.03.09
//mirrors[aid++] = 'ftp://ftp.mozilla.org/pub/mozilla.org/'; // ftp soft ならつながる 2004.03.09
mirrors[aid++] = 'http://ftp.mozilla.org/pub/mozilla.org/'; // checked 2004.03.09


/*****  make directories list  *****/

var mdirs = new Array;
aid = 0;

/***
     mdirs[aid++] = '表示名::基準ディレクトリからの相対';
***/
mdirs[aid++] = 'Mozilla 1.7rc1::mozilla/releases/mozilla1.7rc1/';
mdirs[aid++] = 'Mozilla 1.7rc1 日本語版::mozilla/l10n/lang/moz1.7rc1/';

mdirs[aid++] = 'Mozilla 1.7b::mozilla/releases/mozilla1.7b/';
mdirs[aid++] = 'Mozilla 1.7b 日本語版::mozilla/l10n/lang/moz1.7beta/';

mdirs[aid++] = 'Mozilla 1.7a::mozilla/releases/mozilla1.7a/';
mdirs[aid++] = 'Mozilla 1.7a 日本語版::mozilla/l10n/lang/moz1.7alpha/';

mdirs[aid++] = 'Mozilla 1.6::mozilla/releases/mozilla1.6/';
mdirs[aid++] = 'Mozilla 1.6 日本語版::mozilla/l10n/lang/moz1.6/';

/***
mdirs[aid++] = 'Mozilla 1.5::mozilla/releases/mozilla1.5/';
mdirs[aid++] = 'Mozilla 1.5 日本語版::mozilla/l10n/lang/moz1.5/';
mdirs[aid++] = 'Mozilla 1.5.1（Mac のみ）::mozilla/releases/mozilla1.5.1/';
mdirs[aid++] = 'Mozilla 1.5.1 日本語版（Mac のみ）::mozilla/l10n/lang/moz1.51/';
***/

mdirs[aid++] = 'Mozilla リリース::mozilla/releases/';
mdirs[aid++] = 'Mozilla ナイトリー::mozilla/nightly/';
mdirs[aid++] = 'Mozilla 最新トランク::mozilla/nightly/latest-trunk/';

mdirs[aid++] = 'Mozilla Firefox 0.8::firefox/releases/0.8/';
mdirs[aid++] = 'Mozilla Firefox 0.8 日本語版::firefox/releases/0.8/contrib-localized/';

mdirs[aid++] = 'Mozilla Firefox リリース::firefox/releases/';
mdirs[aid++] = 'Mozilla Firefox ナイトリー::firefox/nightly/';
mdirs[aid++] = 'Mozilla Firefox 最新トランク::firefox/nightly/latest-trunk/';

/***
mdirs[aid++] = 'Mozilla Firebird 0.7 日本語版::firebird/releases/0.7/contrib-localized/';
mdirs[aid++] = 'Mozilla Firebird 0.7.1（Mac のみ）::firebird/releases/0.7.1/';
***/

mdirs[aid++] = 'Mozilla Thunderbird 0.6::thunderbird/releases/0.65/';
mdirs[aid++] = 'Mozilla Thunderbird 0.6 日本語版::thunderbird/releases/0.6/contrib-localized/';

mdirs[aid++] = 'Mozilla Thunderbird 0.5::thunderbird/releases/0.5/';
mdirs[aid++] = 'Mozilla Thunderbird 0.5 日本語版::thunderbird/releases/0.5/contrib-localized/';

/***
mdirs[aid++] = 'Mozilla Thunderbird 0.4::thunderbird/releases/0.4/';
mdirs[aid++] = 'Mozilla Thunderbird 0.4 日本語版::thunderbird/releases/0.4/contrib-localized/';
***/

mdirs[aid++] = 'Mozilla Thunderbird リリース::thunderbird/releases/';
mdirs[aid++] = 'Mozilla Thunderbird ナイトリー::thunderbird/nightly/';
mdirs[aid++] = 'Mozilla Thunderbird 最新トランク::thunderbird/nightly/latest-trunk/';

mdirs[aid++] = 'Camino リリース::camino/releases/';
mdirs[aid++] = 'Camino ナイトリー::camino/nightly/';
mdirs[aid++] = 'Camino 最新ナイトリー::camino/nightly/latest/';

