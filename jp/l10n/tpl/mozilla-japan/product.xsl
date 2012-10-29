<?xml version="1.0" encoding="UTF-8"?>

<!--		parser.product.xsl  製品データ用パーサ
   -
   -	productdb.xml データを使用するための拡張パーサ
   -
   -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:tt="http://dynamis.jp/2003/TransTools"
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns="http://www.w3.org/1999/xhtml"
	version="1.0"
	xml:lang="ja-JP">

<!-- <xsl:include href="parser.xsl"/> -->


<xsl:variable name="productdb"			select="document('../../db/productdb.xml') | document('../../db/productdb.firefox.xml') | document('../../db/productdb.thunderbird.xml') | document('../../db/productdb.mozilla.xml')"/>
<xsl:variable name="productdb-product"	select="$productdb/tt:database/tt:product"/>
<xsl:variable name="productdb-server"	select="$productdb/tt:database/tt:server"/>
<xsl:variable name="persondb"			select="document('../../db/persondb.xml')"/>
<xsl:variable name="persondb-person"	select="$persondb/tt:database/tt:person"/>
<xsl:variable name="sitedb"				select="document('../../db/sitedb.xml')"/>
<xsl:variable name="sitedb-site"		select="$sitedb/tt:database/tt:site"/>
<xsl:variable name="sitedb-mj"			select="$sitedb/tt:database/tt:site[@id = 'mozilla-japan']"/>



<!-- * interface * -->
<!-- <tt:packagetable product="foo" version="X.X.x" server="bar" lastonly="yes|no" excludeplatform="win linux mac ..." excludefiletype="installer zip ..." format=""/> -->
<xsl:template match="tt:packagetable">
	<xsl:variable name="pid" select="@product"/>
	<xsl:variable name="ver" select="@version"/>
	<xsl:variable name="product-version" select="$productdb-product[@id=$pid]/tt:version[@full=$ver or $ver='']"/>
	
	<xsl:if test="not($product-version)">
		<p>XSL 出力エラー: 指定の製品はデータベース中に存在しません。<br/>
			製品ID: <xsl:value-of select="$pid"/><br/>
			バージョン番号: <xsl:value-of select="$ver"/><br/>
			このエラーをサイト管理者までご連絡頂ければ幸いです。</p>
	</xsl:if>
	<xsl:call-template name="packagetable-product">
		<xsl:with-param name="version" select="$product-version"/>
		<xsl:with-param name="server" select="@server"/>
		<xsl:with-param name="without-thead" select="true()"/><!--  -->
		<xsl:with-param name="last-only" select="@lastonly = 'yes'"/><!-- yes: package レベルで複数あるものは最新のもののみ -->
		<xsl:with-param name="ex-platform" select="@excludeplatform"/>
		<xsl:with-param name="ex-type" select="@excludefiletype"/>
	</xsl:call-template>
</xsl:template>


<!-- 指定 version の各 pacakge をリスト出力 -->
<!-- <tt:packagelist product="foo" version="X.X.x" server="bar" lastonly="yes|no" format="linkonly"/> -->
<xsl:template match="tt:packagelist">
	<xsl:variable name="pid" select="@product"/>
	<xsl:variable name="ver" select="@version"/>
	<xsl:variable name="server" select="@server"/>
	<xsl:variable name="format" select="@format"/><!-- linkonly を指定すると [YYYY/MM/DD] を省略 -->
	<xsl:variable name="last-only" select="@lastonly = 'yes'"/><!-- 真偽値 -->
	<ul class="packagelist">
		<xsl:for-each select="$productdb-product[@id=$pid]/tt:version[@full=$ver or $ver='']/tt:package[tt:file/@serverid=$server or $server='']">
			<li>
				<xsl:if test="string($format) != 'linkonly' and @date">
					<xsl:value-of select="concat('[', @date, '] ')"/>
				</xsl:if>
				<xsl:call-template name="packagelink">
					<xsl:with-param name="package" select="."/>
				</xsl:call-template>
				<span class="note">
					<xsl:value-of select="concat(' (rev.', @revision, ') ')"/>
					<xsl:if test="../tt:md5list/tt:file[@serverid=$server]">
						<a href="{../tt:md5list/tt:file[@serverid=$server]/@url}">md5</a>
					</xsl:if>
				</span>
				<xsl:if test="string($format) != 'linkonly' and tt:note">
					<br/>
					<xsl:value-of select="'&#xA0;&#xA0;'"/>
					<span class="note"><xsl:apply-templates select="tt:note"/></span>
				</xsl:if>
			</li>
		</xsl:for-each>
	</ul>
</xsl:template>


<!-- 指定 product の各 package を version 毎にリスト出力 -->
<!-- <tt:versionlist product="foo"/> -->
<xsl:template match="tt:versionlist">
	<xsl:variable name="pid" select="@product"/>
	<xsl:variable name="server" select="@server"/>
	<xsl:variable name="format" select="@format"/><!-- linkonly を指定すると [YYYY/MM/DD] を省略 -->
	<ul class="versionlist">
		<xsl:for-each select="$productdb-product[@id=$pid]/tt:version">
			<xsl:sort select="@major" data-type="number" order="descending"/>
			<xsl:sort select="@minor" data-type="number" order="descending"/>
			<xsl:sort select="@micro" data-type="number" order="descending"/>
			<xsl:sort select="@date"  data-type="text"   order="descending"/>
			<li>
				<xsl:if test="string($format) != 'linkonly' and @date">
					<xsl:value-of select="concat('[', @date, '] ')"/>
				</xsl:if>
				<xsl:call-template name="packagelist">
					<xsl:with-param name="version" select="."/>
					<xsl:with-param name="delimiter">
						<xsl:choose>
							<xsl:when test="@delimiter"><xsl:value-of select="@delimiter"/></xsl:when>
							<xsl:otherwise>, </xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:if test="string($format) != 'linkonly' and tt:note">
					<br/>
					<xsl:value-of select="'&#xA0;&#xA0;'"/>
					<span class="note"><xsl:apply-templates select="tt:note"/></span>
				</xsl:if>
			</li>
		</xsl:for-each>
	</ul>
</xsl:template>



<!-- * file list of package * -->
<!-- file|mirror のリンクを出力 -->
<xsl:template name="filelink">
	<xsl:param name="file" select="."/><!-- file|mirror 要素 -->
	<xsl:param name="text" select="$file/@serverid"/><!-- デフォルトリンクテキストはサーバID -->
	<xsl:param name="title"/>
	<xsl:param name="url"><!-- URL 文字列(通常省略) -->
		<xsl:choose>
			<xsl:when test="local-name($file) = 'file'">
				<xsl:value-of select="$file/@url"/>
			</xsl:when>
			<xsl:when test="local-name($file) = 'mirror' and starts-with($file/../@url, $productdb-server[@id = $file/../@serverid]/@baseurl)">
				<xsl:value-of select="concat($productdb-server[@id = $file/@serverid]/@baseurl, substring-after($file/../@url, $productdb-server[@id = $file/../@serverid]/@baseurl))"/>
			</xsl:when>
		</xsl:choose>
	</xsl:param>
	
	<a href="{$url}">
		<xsl:if test="$title != ''"><xsl:attribute name="title"><xsl:value-of select="$title"/></xsl:attribute></xsl:if>
		<xsl:value-of select="$text"/>
	</a>
</xsl:template>
<!-- package 配下の file|mirror へのリンクを delimiter 区切りで出力 -->
<xsl:template name="filelist">
	<xsl:param name="package" select="."/><!-- package 要素 -->
	<xsl:param name="delimiter" select="', '"/>
	
	<xsl:choose><!-- ファイル登録があるかどうか -->
		<xsl:when test="count($package/tt:file[@url != '']) != 0">
			<!-- | を使用したノードセットによる for-each ループ中で last() 関数を使うとループ部が一度最初の要素のみで実行されるようになる…
				何故かはよく分からないけど XSLT パーサのバグではないかと思われる。取りあえず count($nodeset) で last() を代用した。
			<xsl:for-each select="$package/tt:file[@url != ''] | $package/tt:file[@url != '']/tt:mirror[@serverid != '']">
				<xsl:call-template name="filelink"/>
				<xsl:if test="position() != last()"><xsl:value-of select="$delimiter"/></xsl:if>
			</xsl:for-each> -->
			
			<xsl:variable name="nodeset" select="$package/tt:file[@url != ''] | $package/tt:file[@url != '']/tt:mirror[@serverid != '']"/>
			<xsl:for-each select="$package/tt:file[@url != ''] | $package/tt:file[@url != '']/tt:mirror[@serverid != '']">
				<xsl:call-template name="filelink"/>
				<xsl:if test="position() != count($nodeset)"><xsl:value-of select="$delimiter"/></xsl:if>
			</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="'n.a.'"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>



<!-- * package list * -->
<!-- package 種別に応じたラベルを出力 -->
<xsl:template name="platform-name">
	<xsl:param name="platform" select="@platform"/>
	
	<xsl:choose>
		<xsl:when test="$platform = 'all'">全 OS 対応 </xsl:when>
		<xsl:when test="$platform = 'win+linux'">Win/Linux 用 </xsl:when>
		<xsl:when test="$platform = 'win'">Windows 用 </xsl:when>
		<xsl:when test="$platform = 'linux'">Linux 用 </xsl:when>
		<xsl:when test="$platform = 'mac'">MacOS X 用 </xsl:when>
	</xsl:choose>
</xsl:template>
<xsl:template name="type-name">
	<xsl:param name="type" select="@type"/>
	
	<xsl:choose>
		<xsl:when test="$type = 'installer'">インストーラ</xsl:when>
		<xsl:when test="$type = 'xpi'">XPI パッケージ</xsl:when>
		<xsl:when test="$type = 'source'">ソースコード</xsl:when>
		<xsl:when test="$type = 'jar'">実行可能 JAR</xsl:when>
		<xsl:otherwise><xsl:value-of select="concat(' ', $type, ' アーカイブ')"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>
<xsl:template name="package-label">
	<xsl:param name="package" select="."/><!-- package 要素 -->
	
	<xsl:call-template name="platform-name">
		<xsl:with-param name="platform" select="$package/@platform"/>
	</xsl:call-template>
	<xsl:call-template name="type-name">
		<xsl:with-param name="type" select="$package/@type"/>
	</xsl:call-template>
</xsl:template>
<!-- package からファイルを1つ選んで URL を出力 -->
<xsl:template name="package-url">
	<xsl:param name="package" select="."/><!-- package 要素 -->
	<xsl:param name="server"/><!-- サーバを ID 文字列で指定 -->
	
	<xsl:choose>
		<xsl:when test="$server != ''">
			<xsl:if test="$package/tt:file[@serverid = $server and @url != '']"><!-- 指定サーバのファイルがないときは出力しない -->
				<xsl:value-of select="$package/tt:file[@serverid = $server]/@url"/>
			</xsl:if>
		</xsl:when>
		<!-- 以下、サーバの優先順位を定義… -->
		<xsl:when test="$package/tt:file[@serverid = 'mozilla-japan' and @url != '']">
			<xsl:value-of select="$package/tt:file[@serverid = 'mozilla-japan']/@url"/>
		</xsl:when>
		<xsl:when test="$package/tt:file[@serverid = 'www.ring.gr.jp' and @url != '']">
			<xsl:value-of select="$package/tt:file[@serverid = 'www.ring.gr.jp']/@url"/>
		</xsl:when>
		<xsl:when test="$package/tt:file[@serverid = 'moz.skillup.jp' and @url != '']">
			<xsl:value-of select="$package/tt:file[@serverid = 'moz.skillup.jp']/@url"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$package/tt:file[@url != ''][1]/@url"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
<!-- package のリンクを出力(デフォルトサーバの file のみ) -->
<xsl:template name="packagelink">
	<xsl:param name="package" select="."/><!-- package 要素 -->
	<xsl:param name="server"/><!-- サーバを ID 文字列で指定 -->
	<xsl:param name="text"><!-- デフォルトリンクテキストは package-label テンプレートによる -->
		<xsl:call-template name="package-label">
			<xsl:with-param name="package" select="$package"/>
		</xsl:call-template>
	</xsl:param>
	<xsl:param name="title"/>
	<xsl:variable name="url">
		<xsl:call-template name="package-url">
			<xsl:with-param name="package" select="$package"/>
			<xsl:with-param name="server" select="$server"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:if test="$url != ''">
		<a href="{$url}">
			<xsl:if test="$title != ''"><xsl:attribute name="title"><xsl:value-of select="$title"/></xsl:attribute></xsl:if>
			<xsl:value-of select="$text"/>
		</a>
	</xsl:if>
</xsl:template>
<!-- version 配下の package へのリンクを delimiter 区切りで出力 -->
<xsl:template name="packagelist">
	<xsl:param name="version" select="."/><!-- version 要素 -->
	<xsl:param name="delimiter" select="', '"/>
	
	<xsl:choose><!-- ファイル登録があるかどうか -->
		<xsl:when test="count($version/tt:package[tt:file/@url != '']) != 0">
			<!-- count($nodeset) で last() を代用しているのは上述の filelist 同様の理由 -->
			<xsl:variable name="nodeset" select="$version/tt:package[tt:file/@url != '']"/>
			<xsl:for-each select="$version/tt:package[tt:file/@url != '']">
				<xsl:call-template name="packagelink"/>
				<xsl:if test="position() != count($nodeset)"><xsl:value-of select="$delimiter"/></xsl:if>
			</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="'n.a.'"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>





<!-- * 指定 version の package の一覧表を出力 * -->
<!-- 各 package の出力(リスト出力用) -->
<xsl:template name="packagetable-list-item">
	<xsl:param name="package" select="."/><!-- package 要素 -->
	<xsl:param name="server"/>

	<tr>
		<td class="center">
			<xsl:choose>
				<xsl:when test="$package/@platform = 'win+linux'">
					<img src="${l10n-icon-os-win}" alt="" class="osicon"/>
					<img src="${l10n-icon-os-linux}" alt="" class="osicon"/>
				</xsl:when>
				<xsl:when test="$package/@platform = 'win'">
					<img src="${l10n-icon-os-win}" alt="" class="osicon"/>
				</xsl:when>
				<xsl:when test="$package/@platform = 'linux'">
					<img src="${l10n-icon-os-linux}" alt="" class="osicon"/>
				</xsl:when>
				<xsl:when test="$package/@platform = 'mac'">
					<img src="${l10n-icon-os-mac}" alt="" class="osicon"/>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="'&#xA0;'"/></xsl:otherwise><!-- 空要素防止 -->
			</xsl:choose>
		</td>
		<td>
			<xsl:if test="$package/@date">
				<xsl:value-of select="concat('[', $package/@date, '] ')"/>
			</xsl:if>
			<xsl:call-template name="packagelink">
				<xsl:with-param name="package" select="."/>
			</xsl:call-template>
		</td>
		<td class="note">
			<xsl:choose>
				<xsl:when test="$package/@revision">
					<xsl:value-of select="concat('(rev.', $package/@revision, ')')"/>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="'&#xA0;'"/></xsl:otherwise><!-- 空要素防止 -->
			</xsl:choose>
		</td>
		<td class="note">
			<xsl:for-each select="$package/../tt:checksum/tt:file[@serverid=$server]">
				<xsl:if test="position() != 1"><xsl:value-of select="'&#xA0;'"/></xsl:if>
				<xsl:variable name="type" select="@type"/>
				<a href="{@url}" title="{$package/@*[name() = $type]}"><xsl:value-of select="@type"/></a>
			</xsl:for-each>
			<xsl:if test="not($package/../tt:checksum/tt:file[@serverid=$server])"><xsl:value-of select="'&#xA0;'"/></xsl:if><!-- 空要素防止 -->
		</td>
	</tr>
	<xsl:if test="tt:note != ''">
		<tr>
			<td colspan="4" class="note">
				<xsl:value-of select="'&#xA0;&#xA0;'"/>
				<xsl:apply-templates select="tt:note"/>
			</td>
		</tr>
	</xsl:if>
</xsl:template>
<!-- プラットフォームおよびパッケージ種でソートして出力 -->
<xsl:template name="packagetable-list-sort">
	<xsl:param name="packages" select="/.."/><!-- package 要素リスト -->
	<xsl:param name="last-only"/><!-- 真偽値 -->
	<xsl:param name="server"/>
	
	<xsl:if test="$packages">
		<xsl:variable name="platform" select="$packages[1]/@platform"/>
		<xsl:variable name="type" select="$packages[1]/@type"/>
		
		<xsl:for-each select="$packages[@platform = $platform and @type = $type]">
			<xsl:if test="position() = last() or not($last-only)">
				<xsl:call-template name="packagetable-list-item">
					<xsl:with-param name="server" select="$server"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>
		<xsl:call-template name="packagetable-list-sort">
			<xsl:with-param name="packages" select="$packages[@platform != $platform or @type != $type]"/>
			<xsl:with-param name="last-only" select="$last-only"/>
			<xsl:with-param name="server" select="$server"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>


<!-- 各 package の出力(プラットフォーム別出力用) -->
<xsl:template name="packagetable-platform-item">
	<xsl:param name="package" select="."/><!-- package 要素 -->
	<xsl:param name="server"/>

	<xsl:choose>
		<xsl:when test="$package">
			<xsl:variable name="type-name">
				<xsl:call-template name="type-name">
					<xsl:with-param name="type" select="$package/@type"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:call-template name="packagelink">
				<xsl:with-param name="package" select="$package"/>
				<xsl:with-param name="text" select="$type-name"/>
			</xsl:call-template>
			<span class="note">
				<xsl:if test="$package/@date">
					<xsl:attribute name="title">
						<xsl:value-of select="concat('作成日: ', $package/@date)"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="$package/@revision">
					<xsl:value-of select="concat('(rev.', $package/@revision, ')')"/>
				</xsl:if>
			</span>
		</xsl:when>
		<xsl:otherwise>
			<xsl:attribute name="class">none</xsl:attribute>
			<xsl:value-of select="'&#xA0;'"/>
		</xsl:otherwise><!-- 空要素防止 -->
	</xsl:choose>
	<!-- このフォーマットではパッケージ別のコメントは無視される -->
</xsl:template>
<!-- プラットフォーム別に -->
<xsl:template name="packagetable-platform">
	<xsl:param name="packages" select="/.."/><!-- package 要素リスト -->
	<xsl:param name="platform" select="$packages/@platform"/><!-- package 要素リスト -->
	<xsl:param name="xpi-packages"			select="$packages[@type = 'xpi']"/>
	<xsl:param name="installer-packages"	select="$packages[@type = 'installer']"/>
	<xsl:param name="source-packages"		select="$packages[@type = 'source']"/>
	<xsl:param name="jar-packages"			select="$packages[@type = 'jar']"/>
	<xsl:param name="misc-packages"			select="$packages[@type != 'xpi' and @type != 'installer' and @type != 'source' and @type != 'jar']"/>
	<xsl:param name="last-only"/><!-- 真偽値 -->
	<xsl:param name="server"/>
	
	<xsl:variable name="first-packages" select="$xpi-packages[1] | $installer-packages[1] | $source-packages[1] | $jar-packages[1] | $misc-packages[1]"/>
	<xsl:variable name="left-packages" select="$xpi-packages[position()!=1] | $installer-packages[position()!=1] | $source-packages[position()!=1] | $jar-packages[position()!=1] | $misc-packages[position()!=1]"/>

	<tr>
		<td class="xpi">
			<xsl:call-template name="packagetable-platform-item">
				<xsl:with-param name="package" select="$xpi-packages[1]"/>
				<xsl:with-param name="server" select="$server"/>
			</xsl:call-template>
		</td>
		<td class="installer">
			<xsl:call-template name="packagetable-platform-item">
				<xsl:with-param name="package" select="$installer-packages[1]"/>
				<xsl:with-param name="server" select="$server"/>
			</xsl:call-template>
		</td>
		<td class="source">
			<xsl:call-template name="packagetable-platform-item">
				<xsl:with-param name="package" select="$source-packages[1]"/>
				<xsl:with-param name="server" select="$server"/>
			</xsl:call-template>
		</td>
		<td class="jar">
			<xsl:call-template name="packagetable-platform-item">
				<xsl:with-param name="package" select="$jar-packages[1]"/>
				<xsl:with-param name="server" select="$server"/>
			</xsl:call-template>
		</td>
		<td class="misc">
			<xsl:call-template name="packagetable-platform-item">
				<xsl:with-param name="package" select="$misc-packages[1]"/>
				<xsl:with-param name="server" select="$server"/>
			</xsl:call-template>
		</td>
	</tr>

	<xsl:if test="$left-packages and not($last-only)">
		<xsl:call-template name="packagetable-platform">
			<xsl:with-param name="packages" select="$left-packages"/>
			<xsl:with-param name="server" select="$server"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>

<!-- プラットフォーム別にまとめて出力 -->
<xsl:template name="packagetable-group-by-platform">
	<xsl:param name="packages" select="/.."/><!-- package 要素リスト -->
	<xsl:param name="last-only"/><!-- 真偽値 -->
	<xsl:param name="server"/>
	
	<xsl:if test="$packages">
		<xsl:variable name="platform" select="$packages[1]/@platform"/>
		
		<tbody class="{$packages/@platform}">
			<tr>
				<th colspan="5">
					<xsl:choose>
						<xsl:when test="$platform = 'win'">
							<img src="${l10n-icon-os-win}" alt="" class="osicon"/>
						</xsl:when>
						<xsl:when test="$platform = 'linux'">
							<img src="${l10n-icon-os-linux}" alt="" class="osicon"/>
						</xsl:when>
						<xsl:when test="$platform = 'mac'">
							<img src="${l10n-icon-os-mac}" alt="" class="osicon"/>
						</xsl:when>
					</xsl:choose>
					<!-- <xsl:value-of select="'&#xA0;'"/> -->
					<xsl:call-template name="platform-name">
						<xsl:with-param name="platform" select="$platform"/>
					</xsl:call-template>
					<xsl:if test="$packages/../tt:md5list/tt:file[@serverid=$server]">
						<a href="{$packages/../tt:md5list/tt:file[@serverid=$server]/@url}" title="gnu md5sum によるチェックサムリスト" class="note">[md5]</a>
					</xsl:if>
				</th>
			</tr>
			<xsl:call-template name="packagetable-platform">
				<xsl:with-param name="packages" select="$packages[@platform = $platform]"/>
				<xsl:with-param name="last-only" select="$last-only"/>
				<xsl:with-param name="server" select="$server"/>
			</xsl:call-template>
		</tbody>
		<xsl:call-template name="packagetable-group-by-platform">
			<xsl:with-param name="packages" select="$packages[@platform != $platform]"/>
			<xsl:with-param name="last-only" select="$last-only"/>
			<xsl:with-param name="server" select="$server"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>


<!-- 製品の package リスト -->
<xsl:template name="packagetable-product">
	<xsl:param name="version" select="/.."/><!-- version 要素必須 -->
	<xsl:param name="server"/><!-- サーバ ID 文字列 -->
	<xsl:param name="without-thead"/><!-- 真偽値 -->
	<xsl:param name="without-tfoot"/><!-- 真偽値 -->
	<xsl:param name="last-only"/><!-- 真偽値 -->
	<xsl:param name="ex-platform"/><!-- プラットフォーム名文字列 -->
	<xsl:param name="ex-type"/><!-- パッケージ種名文字列 -->
	
	<xsl:variable name="packages" select="$version/tt:package[
		(tt:file/@url != '')
		and (tt:file/@serverid=$server or $server='')
		and not(contains(concat($ex-platform, ' '), concat(@platform, ' ')))
		and not(contains(concat($ex-type, ' '), concat(@type, ' ')))
		]"/>
	
	<xsl:choose>
		<xsl:when test="$packages">
			<table class="packagetable">
				<xsl:if test="not($without-thead)">
					<thead><tr>
						<th colspan="5"><xsl:value-of select="concat($version/../@name, ' ', $version/@full)"/></th>
					</tr></thead>
				</xsl:if>
				<!-- <xsl:call-template name="packagetable-group-by-platform"> -->
				<xsl:call-template name="packagetable-list-sort">
					<xsl:with-param name="packages" select="$packages"/>
					<xsl:with-param name="last-only" select="$last-only"/>
					<xsl:with-param name="server" select="$server"/>
				</xsl:call-template>
			</table>
			<!-- tfoot で出力するとテーブルの幅を100%にしてしまい、隙間だらけの表になる… -->
			<xsl:if test="contains($version/@stage, 'development')">
				<xsl:choose>
					<xsl:when test="contains($version/@full, '+')">
						<p class="note"><xsl:value-of select="concat($version/../@shortname, ' ', translate($version/@full, '+', ''))"/> リリース後に次のリリースへ向けての準備として作成した開発リリースです。動作確認などは殆どしておりませんので、ご利用になる場合には十分にご注意ください。</p>
					</xsl:when>
					<xsl:when test="contains($version/@full, '-')">
						<p class="note"><xsl:value-of select="concat($version/../@shortname, ' ', translate($version/@full, '-', ''))"/> リリースへ向けての準備として作成した開発リリースです。動作確認などは殆どしておりませんので、ご利用になる場合には十分にご注意ください。</p>
					</xsl:when>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="not($without-tfoot) and $version/tt:note != ''">
				<xsl:for-each select="$version/tt:note[. != '']">
					<p class="note"><xsl:apply-templates select="."/></p>
				</xsl:for-each>
			</xsl:if>
		</xsl:when>
		<xsl:otherwise>
			<p>現在 <xsl:value-of select="concat($version/../@shortname, ' ', translate($version/@full, '+', ''))"/> は準備中です。</p>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>




</xsl:stylesheet>
