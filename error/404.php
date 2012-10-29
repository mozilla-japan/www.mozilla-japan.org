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
      <p>このドキュメントは、存在しないかオリジナルドキュメントがまだ和訳されていないかのいずれかです。まず URL に間違いがないかどうかをご確認ください。リンクミスと思われる場合は、リンク元サイトの管理者に連絡してください。</p>
      <p>右のフレームに英文のオリジナルドキュメントが表示されていて、その和訳が必要な場合は、Mozilla Japan 翻訳部門で受け付けている <a href="http://forums.firehacks.org/trans/viewforum.php?f=6">和訳リクエスト</a> をご利用ください。できるだけご要望に応じて和訳いたします。</p>
      <p>翻訳部門では和訳に協力してくださるボランティアの方々を募集しています。ご自身で和訳してみたいという方は、<a href="/jp/td/">翻訳部門</a> のサイトで参加方法などをご覧ください。</p>
      <ul>
        <li><a href="<?php echo $original ?>">フレームを外してオリジナルドキュメントを表示する</a></li>
        <li><a href="/">Mozilla Japan トップページへ戻る</a></li>
      </ul>
    </div>
    <div id="view">
      <iframe src="<?php echo $original ?>" frameborder="0"></iframe>
    </div>
  </body>
</html>
