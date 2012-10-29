<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=euc-jp">
    <title>404 Not Found</title>
    <style type="text/css" media="screen,tv">
      body { margin: 0; padding: 0; height: 100%; overflow: hidden; font-size: 100%; background: #fff url(/images/body_back.gif) repeat-x; }
      * { font: small/160% Verdana, Arial, sans-serif; }
      #desc { margin: 20px; width: 200px; }
      h1 { font-size: 140%; border-bottom: 1px solid #ccc; }
      ul { margin-left: 0; padding-left: 2em; }
      a { color: #039; background-color: transparent; }
      #view { position: absolute; top: 0; right: 0; left: 240px; width: auto; height: 100%; border-left: 1px solid #ccc; }
      iframe { margin: 0; width: 100%; height: 100%; display: block; }
      /* IE/Win Hacks \*/
       * html { overflow: hidden; }
       * html #view { padding-right: 0; padd\ing-right: 240px; }
      /* */
    </style>
  </head>
  <body id="www-mozilla-japan-org">
<?php
  $path = htmlspecialchars($_SERVER['REQUEST_URI'],ENT_QUOTES);
  if (preg_match("/^\/products\/(firefox|thunderbird)\/(.*)/", $path, $matches)) {
    $original = "http://www.mozilla.com/en-US/".$matches[1]."/".$matches[2];
  } else if (preg_match("/^\/(about|add-ons|developers|legal|press|products)\//", $path)) {
    $original = "http://www.mozilla.com/en-US".$path;
  } else if (preg_match("/^\/lxr\/(.*)/", $path, $matches)) {
    $original = "http://lxr.mozilla.org/".$matches[1];
  } else {
    $original = "http://www.mozilla.org".$path;
  }
?>
    <div id="desc">
      <h1>404 Not Found</h1>
      <p>���Υɥ�����Ȥϡ�¸�ߤ��ʤ������ꥸ�ʥ�ɥ�����Ȥ��ޤ���������Ƥ��ʤ����Τ����줫�Ǥ����ޤ� URL �˴ְ㤤���ʤ����ɤ����򤴳�ǧ������������󥯥ߥ��Ȼפ�����ϡ���󥯸������Ȥδ����Ԥ�Ϣ���Ƥ���������</p>
      <p>���Υե졼��˱�ʸ�Υ��ꥸ�ʥ�ɥ�����Ȥ�ɽ������Ƥ��ơ�����������ɬ�פʾ��ϡ�Mozilla Japan ��������Ǽ����դ��Ƥ��� <a href="http://forums.firehacks.org/trans/viewforum.php?f=6">�����ꥯ������</a> �����Ѥ����������Ǥ����������˾�˱����������������ޤ���</p>
      <p>��������Ǥ������˶��Ϥ��Ƥ�������ܥ��ƥ������������罸���Ƥ��ޤ��������Ȥ��������Ƥߤ����Ȥ������ϡ�<a href="/jp/td/">��������</a> �Υ����Ȥǻ�����ˡ�ʤɤ�������������</p>
      <ul>
        <li><a href="<?php echo $original ?>">�ե졼��򳰤��ƥ��ꥸ�ʥ�ɥ�����Ȥ�ɽ������</a></li>
        <li><a href="/">Mozilla Japan �ȥåץڡ��������</a></li>
      </ul>
    </div>
    <div id="view">
      <iframe src="<?php echo $original ?>" frameborder="0"></iframe>
    </div>
  </body>
</html>
