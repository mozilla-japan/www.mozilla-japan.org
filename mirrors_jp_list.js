
/*********

mirrors_jp_list.js

mirrors_jp.html 40���� 2004.03.09 chado

2004.03.13  chado
            �ǥ��쥯�ȥ�ꥹ�Ȥ� Camino ��꡼�� �˥��ߤ��ĤäƤ��Τ���
            �ߥ顼�ꥹ�Ȥ� ��꡼���ڡ����Ǥ�������� ring.riken.go.jp ���ɲá�
*********/

/*****  make mirrors list  *****/

var mirrors = new Array;
var aid = 0;

/***
     mirrors[aid++] = '�ߥ顼�����ȴ��ǥ��쥯�ȥ�,';
***/

mirrors[aid++] = 'ftp://ring.riken.go.jp/archives/net/www/mozilla/'; // 2004.03.13 �ɲ�
mirrors[aid++] = 'http://ring.riken.go.jp/archives/net/www/mozilla/'; // 2004.03.13 �ɲ�
mirrors[aid++] = '-'; // ���ڤ���
mirrors[aid++] = 'ftp://ftp.cin.nihon-u.ac.jp/pub/net/www/mozilla/'; // checked 2004.03.09
mirrors[aid++] = 'ftp://ring.exp.fujixerox.co.jp/pub/net/www/mozilla/'; // checked 2004.03.09
mirrors[aid++] = 'ftp://ring.so-net.ne.jp/pub/net/www/mozilla/'; // checked 2004.03.09
//mirrors[aid++] = 'ftp://ftp.jaist.ac.jp/pub/Mozilla/'; // ��������Ƥʤ� 2004.03.09
mirrors[aid++] = 'ftp://ring.aist.go.jp/pub/net/www/mozilla/'; // checked 2004.03.09
mirrors[aid++] = 'ftp://ftp.lab.kdd.co.jp/Mozilla/'; // checked 2004.03.09
mirrors[aid++] = '-'; // ���ڤ���
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
//mirrors[aid++] = 'ftp://ring.k-opti.com/pub/net/www/mozilla/'; // ftp soft �ʤ�Ĥʤ��� 2004.03.09
//mirrors[aid++] = 'ftp://ring.sbp-shimane.net/pub/net/www/mozilla/'; // mo1.7a �ʤ���l10n �Ϥ��롣max 20 user 2004.03.09
mirrors[aid++] = 'ftp://ring.maffin.ad.jp/pub/net/www/mozilla/'; // checked 2004.03.09
//mirrors[aid++] = 'http://mirror.nucba.ac.jp/mirror/mozilla/mozilla.org/'; // ��Ȥ��ʤ� 2004.03.09
//mirrors[aid++] = 'ftp://mirror.nucba.ac.jp/mirror/mozilla/'; // connection refused 2004.03.09
mirrors[aid++] = '-'; // ���ڤ���
mirrors[aid++] = 'ftp://download.mozilla.org/pub/mozilla.org/'; // checked 2004.03.09
mirrors[aid++] = 'http://download.mozilla.org/pub/mozilla.org/'; // checked 2004.03.09
//mirrors[aid++] = 'ftp://ftp.mozilla.org/pub/mozilla.org/'; // ftp soft �ʤ�Ĥʤ��� 2004.03.09
mirrors[aid++] = 'http://ftp.mozilla.org/pub/mozilla.org/'; // checked 2004.03.09


/*****  make directories list  *****/

var mdirs = new Array;
aid = 0;

/***
     mdirs[aid++] = 'ɽ��̾::���ǥ��쥯�ȥ꤫�������';
***/
mdirs[aid++] = 'Mozilla 1.7rc1::mozilla/releases/mozilla1.7rc1/';
mdirs[aid++] = 'Mozilla 1.7rc1 ���ܸ���::mozilla/l10n/lang/moz1.7rc1/';

mdirs[aid++] = 'Mozilla 1.7b::mozilla/releases/mozilla1.7b/';
mdirs[aid++] = 'Mozilla 1.7b ���ܸ���::mozilla/l10n/lang/moz1.7beta/';

mdirs[aid++] = 'Mozilla 1.7a::mozilla/releases/mozilla1.7a/';
mdirs[aid++] = 'Mozilla 1.7a ���ܸ���::mozilla/l10n/lang/moz1.7alpha/';

mdirs[aid++] = 'Mozilla 1.6::mozilla/releases/mozilla1.6/';
mdirs[aid++] = 'Mozilla 1.6 ���ܸ���::mozilla/l10n/lang/moz1.6/';

/***
mdirs[aid++] = 'Mozilla 1.5::mozilla/releases/mozilla1.5/';
mdirs[aid++] = 'Mozilla 1.5 ���ܸ���::mozilla/l10n/lang/moz1.5/';
mdirs[aid++] = 'Mozilla 1.5.1��Mac �Τߡ�::mozilla/releases/mozilla1.5.1/';
mdirs[aid++] = 'Mozilla 1.5.1 ���ܸ��ǡ�Mac �Τߡ�::mozilla/l10n/lang/moz1.51/';
***/

mdirs[aid++] = 'Mozilla ��꡼��::mozilla/releases/';
mdirs[aid++] = 'Mozilla �ʥ��ȥ꡼::mozilla/nightly/';
mdirs[aid++] = 'Mozilla �ǿ��ȥ��::mozilla/nightly/latest-trunk/';

mdirs[aid++] = 'Mozilla Firefox 0.8::firefox/releases/0.8/';
mdirs[aid++] = 'Mozilla Firefox 0.8 ���ܸ���::firefox/releases/0.8/contrib-localized/';

mdirs[aid++] = 'Mozilla Firefox ��꡼��::firefox/releases/';
mdirs[aid++] = 'Mozilla Firefox �ʥ��ȥ꡼::firefox/nightly/';
mdirs[aid++] = 'Mozilla Firefox �ǿ��ȥ��::firefox/nightly/latest-trunk/';

/***
mdirs[aid++] = 'Mozilla Firebird 0.7 ���ܸ���::firebird/releases/0.7/contrib-localized/';
mdirs[aid++] = 'Mozilla Firebird 0.7.1��Mac �Τߡ�::firebird/releases/0.7.1/';
***/

mdirs[aid++] = 'Mozilla Thunderbird 0.6::thunderbird/releases/0.65/';
mdirs[aid++] = 'Mozilla Thunderbird 0.6 ���ܸ���::thunderbird/releases/0.6/contrib-localized/';

mdirs[aid++] = 'Mozilla Thunderbird 0.5::thunderbird/releases/0.5/';
mdirs[aid++] = 'Mozilla Thunderbird 0.5 ���ܸ���::thunderbird/releases/0.5/contrib-localized/';

/***
mdirs[aid++] = 'Mozilla Thunderbird 0.4::thunderbird/releases/0.4/';
mdirs[aid++] = 'Mozilla Thunderbird 0.4 ���ܸ���::thunderbird/releases/0.4/contrib-localized/';
***/

mdirs[aid++] = 'Mozilla Thunderbird ��꡼��::thunderbird/releases/';
mdirs[aid++] = 'Mozilla Thunderbird �ʥ��ȥ꡼::thunderbird/nightly/';
mdirs[aid++] = 'Mozilla Thunderbird �ǿ��ȥ��::thunderbird/nightly/latest-trunk/';

mdirs[aid++] = 'Camino ��꡼��::camino/releases/';
mdirs[aid++] = 'Camino �ʥ��ȥ꡼::camino/nightly/';
mdirs[aid++] = 'Camino �ǿ��ʥ��ȥ꡼::camino/nightly/latest/';

