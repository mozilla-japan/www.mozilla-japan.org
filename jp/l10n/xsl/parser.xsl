<?xml version="1.0" encoding="UTF-8"?>

<!-- 		parser.xsl  グローバルパーサ
   -
   -	apply-templates を受けての、出力生成処理本体部
   -	このパーサスタイルシートでは TransTools 名前空間の要素を解析しつつ HTML を出力する
   -	ここで定義されているテンプレートなどはグローバルなものとして任意テンプレートから使用してよい
   -	逆にここ以外で定義されるテンプレートなどは依存関係や名前空間などに注意して使用しなければならない
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

<xsl:strip-space elements="tt:stripspace"/>
<xsl:preserve-space elements="tt:htmlheader html:pre html:code"/>


<!-- テンプレートファイル処理中にも各ページファイルを参照できるようにする -->
<xsl:variable name="contents"	select="/tt:contents"/>
<xsl:variable name="page"		select="/tt:contents/tt:page"/>
<!-- 各ファイルのディレクトリ階層を調べる手段はないのでファイル中に記録して使用 -->
<xsl:variable name="pathtoroot" select="normalize-space(/tt:contents/tt:page/@pathtoroot)"/>
<!-- ページ情報 -->
<xsl:variable name="meta" select="/tt:contents/tt:page/tt:meta"/>

<!-- 設定ファイル -->
<xsl:variable name="config"				select="document('../config.xml')"/>
<xsl:variable name="config-property"	select="$config/properties/property"/>
<xsl:key name="config" match="property" use="@name"/>

<!-- tt:include で使用する置き換え HTML 断片定義ファイル -->
<xsl:variable name="fragmentdb"				select="document('../db/fragmentdb.xml')"/>
<xsl:variable name="fragmentdb-fragment"	select="$fragmentdb/tt:database/tt:fragment"/>
<xsl:key name="fragmentdb" match="fragment" use="@id"/>

<!-- url 置き換えなどに使うサイト定義ファイル -->
<xsl:variable name="sitedb"					select="document('../db/sitedb.xml')"/>
<xsl:key name="sitedb-url" match="*[@id]" use="@id | @anotherid"/>

<xsl:variable name="newline" xml:space="preserve">
</xsl:variable>

<!-- * 実体参照代替要素 * -->
<!-- DTD を読み込めないパーサで (XML 標準では定義されていない) &copy; や &nbsp; を使う -->
<xsl:template match="tt:copy">
	<xsl:value-of select="'&#xA9;'"/>
</xsl:template>
<xsl:template match="tt:nbsp">
	<xsl:value-of select="'&#xA0;'"/>
</xsl:template>

<!-- * デフォルト処理定義 * -->
<!-- 未定義要素ではそのまま中身を処理 -->
<xsl:template match="tt:*">
	<xsl:apply-templates/>
</xsl:template>

<!-- 未定義属性は名前空間を破棄して出力 -->
<xsl:template match="@tt:*">
	<xsl:attribute name="{local-name()}">
		<xsl:value-of select="."/>
	</xsl:attribute>
</xsl:template>

<!-- 埋め込み HTML はそのままコピーして中身を処理 -->
<xsl:template match="html:*">
	<xsl:copy>
		<xsl:copy-of select="@*[namespace-uri()='']"/><!-- 名前空間 URI が null である属性をコピー(属性にはデフォルト名前空間がない) -->
		<xsl:apply-templates select="@tt:*"/>
		<xsl:apply-templates select="child::node()"/>
	</xsl:copy>
</xsl:template>

<!-- URL 属性値をパース処理 -->
<xsl:template match="html:a | html:link">
	<xsl:copy>
		<xsl:if test="@href">
			<xsl:attribute name="href">
				<xsl:call-template name="url-filter">
					<xsl:with-param name="url" select="@href"/>
				</xsl:call-template>
			</xsl:attribute>
		</xsl:if>
		<xsl:copy-of select="@*[local-name() != 'href' and namespace-uri()='']"/>
		<xsl:apply-templates select="@tt:*"/>
		<xsl:apply-templates select="child::node()"/>
	</xsl:copy>
</xsl:template>
<xsl:template match="html:img | html:script">
	<xsl:copy>
		<xsl:if test="@src">
			<xsl:attribute name="src">
				<xsl:call-template name="url-filter">
					<xsl:with-param name="url" select="@src"/>
				</xsl:call-template>
			</xsl:attribute>
		</xsl:if>
		<xsl:copy-of select="@*[local-name() != 'src' and namespace-uri()='']"/>
		<xsl:apply-templates select="@tt:*"/>
		<xsl:apply-templates select="child::node()"/>
	</xsl:copy>
</xsl:template>





<!-- * 条件分岐出力(現在使用休止中) * -->
<!-- <xsl:template match="tt:if">
	<xsl:choose>
		<xsl:when test="@format"><!- - @format は空白区切りで複数指定可 - ->
			<xsl:if test="contains(concat(' ', @format, ' '), $format)">
				<xsl:copy-of select="@*[namespace-uri()='']"/>
				<xsl:apply-templates select="child::node()"/>
			</xsl:if>
		</xsl:when>
		<xsl:when test="@lang"><!- - @lang は空白区切りで複数指定可 - ->
			<xsl:if test="contains(concat(' ', @lang, ' '), $lang)">
				<xsl:copy-of select="@*[namespace-uri()='']"/>
				<xsl:apply-templates select="child::node()"/>
			</xsl:if>
		</xsl:when>
		<xsl:otherwise>
			<xsl:copy-of select="@*[namespace-uri()='']"/>
			<xsl:apply-templates select="child::node()"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template> -->


<!-- * include fragment * -->
<!-- <tt:include id="" parsed="yes|no"/> を fragmentdb で定義した値に置き換える -->
<xsl:template match="tt:include" name="include">
	<xsl:param name="id" select="@idref"/>
	<xsl:variable name="fragment" select="$fragmentdb-fragment[@id = $id]">
		<xsl:for-each select="$fragmentdb">
			<xsl:value-of select="key('fragmentdb', $id)"/>
		</xsl:for-each>
	</xsl:variable>
	<!-- <xsl:variable name="fragment" select="$fragmentdb-fragment[@id = $id]"/> -->
	
	<xsl:if test="not($fragment)">
		<p>XSL 出力エラー: XML fragment がデータベース中に存在しません。<br/>
			fragmentid: <xsl:value-of select="$id"/></p>
	</xsl:if>
	<xsl:choose>
		<xsl:when test="$fragment/@parsed = 'no'">
			<xsl:copy-of select="$fragment/html:*"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates select="$fragment"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>





<!-- * URL 関連処理 * -->
<!-- <tt:url idref="url.id" type="text|link"/>URL 変数要素 -->
<xsl:template match="tt:url">
	<xsl:variable name="url">
		<xsl:call-template name="url-filter">
			<xsl:with-param name="url" select="concat('@@', @idref, '@@')"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:choose>
		<xsl:when test="@type = 'link'">
			<a href="{$url}"><xsl:value-of select="$url"/></a>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$url"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- URL の書き換え -->
<xsl:template name="url-filter">
	<xsl:param name="url"/>
	<xsl:variable name="normalizedurl" select="normalize-space($url)"/>
	<xsl:variable name="targeturl">
		<xsl:choose>
			<!-- "${url.id}" と "@@url.id@@" は sitedb を元に置き換える -->
			<xsl:when test="starts-with($normalizedurl , '${') and substring($normalizedurl, string-length($normalizedurl) , 1)='}'">
				<xsl:for-each select="$sitedb">
					<xsl:value-of select="key('sitedb-url', substring-before(substring-after($url, '${'), '}'))/@url"/>
				</xsl:for-each>
				<!-- 遅い: <xsl:value-of select="$sitedb//*[@id = substring-before(substring-after($url, '${'), '}')]/@url"/> -->
			</xsl:when>
			<xsl:when test="starts-with($normalizedurl , '@@') and substring($normalizedurl, string-length($normalizedurl)-1 , 2)='@@'">
				<xsl:for-each select="$sitedb">
					<xsl:value-of select="key('sitedb-url', substring-before(substring-after($url, '@@'), '@@'))/@url"/>
				</xsl:for-each>
				<!-- 遅い: <xsl:value-of select="$sitedb//*[@id = substring-before(substring-after($url, '@@'), '@@')]/@url"/> -->
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$normalizedurl"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="config.site.url.root">
		<xsl:for-each select="$config">
			<xsl:value-of select="key('config', 'site.url.root')/@value"/>
		</xsl:for-each>
	</xsl:variable>
	<!-- 遅い: <xsl:variable name="config.site.url.root" select="$config-property[@name='site.url.root']/@value"/> -->
	
	<xsl:if test="$pathtoroot != ''">
		<xsl:choose>
			<!-- ルートに対するリンク(ルート直下ファイルからのリンクが空文字列にならないためにも別処理) -->
			<xsl:when test="$targeturl = $config.site.url.root"><xsl:value-of select="$pathtoroot"/></xsl:when>
			<!-- サイト内リンクを相対リンクに変換 -->
			<xsl:when test="starts-with($targeturl, $config.site.url.root)">
				<xsl:value-of select="concat($pathtoroot, substring-after($targeturl, $config.site.url.root))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$targeturl"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
</xsl:template>

<!-- URL の分解 -->
<xsl:template name="url-parser">
	<xsl:param name="url"/><!-- 解析対象 URL -->
	<xsl:param name="part"/><!-- protocol/host/port/path/file/query -->
	
	<xsl:choose>
		<xsl:when test="$part = 'protocol'">
			<xsl:value-of select="substring-before($url, '://')"/>
		</xsl:when>
		<xsl:when test="$part = 'host'">
			<xsl:variable name="hostport" select="substring-before(substring-after($url, '://'), '/')"/>
			<xsl:choose>
				<xsl:when test="contains($hostport, ':')">
					<xsl:value-of select="substring-before($hostport, ':')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$hostport"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:when test="$part = 'port'">
			<xsl:variable name="hostport" select="substring-before(substring-after($url, '://'), '/')"/>
			<xsl:choose>
				<xsl:when test="contains($hostport, ':')">
					<xsl:value-of select="substring-after($hostport, ':')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="protocol2port">
						<xsl:with-param name="protocol" select="substring-before($url, '://')"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:when test="$part = 'path'">
			<xsl:variable name="pathfile" select="substring-after(substring-after($url, '://'), '/')"/>
			<xsl:call-template name="url-parser-filepath">
				<xsl:with-param name="path">
					<xsl:choose>
						<xsl:when test="contains($pathfile, '?')">
							<xsl:value-of select="substring-before($pathfile, '?')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$pathfile"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="$part = 'file'">
			<xsl:variable name="pathfile" select="substring-after(substring-after($url, '://'), '/')"/>
			<xsl:call-template name="url-parser-filename">
				<xsl:with-param name="path">
					<xsl:choose>
						<xsl:when test="contains($pathfile, '?')">
							<xsl:value-of select="substring-before($pathfile, '?')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$pathfile"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="$part = 'query'">
			<xsl:value-of select="substring-after($url, '?')"/>
		</xsl:when>
	</xsl:choose>
</xsl:template>
<xsl:template name="protocol2port">
	<xsl:param name="protocol"/>
	<xsl:choose>
		<xsl:when test="$protocol = 'http'">	<xsl:value-of select="'80'"/></xsl:when>
		<xsl:when test="$protocol = 'https'">	<xsl:value-of select="'443'"/></xsl:when>
		<xsl:when test="$protocol = 'ftp'">		<xsl:value-of select="'21'"/></xsl:when>
		<xsl:when test="$protocol = 'pop3'">	<xsl:value-of select="'110'"/></xsl:when>
		<xsl:when test="$protocol = 'smtp'">	<xsl:value-of select="'25'"/></xsl:when>
		<xsl:when test="$protocol = 'dns'">		<xsl:value-of select="'53'"/></xsl:when>
		<xsl:when test="$protocol = 'ssh'">		<xsl:value-of select="'22'"/></xsl:when>
		<xsl:when test="$protocol = 'telnet'">	<xsl:value-of select="'23'"/></xsl:when>
		<xsl:when test="$protocol = 'irc'">		<xsl:value-of select="'194'"/></xsl:when>
		<xsl:when test="$protocol = 'echo'">	<xsl:value-of select="'7'"/></xsl:when>
		<xsl:when test="$protocol = 'time'">	<xsl:value-of select="'37'"/></xsl:when>
	</xsl:choose>
</xsl:template>
<xsl:template name="url-parser-filepath">
	<xsl:param name="path"/>
	
	<xsl:if test="contains($path, '/')">
		<xsl:choose>
			<xsl:when test="starts-with($path, '/')">
				<xsl:value-of select="'/'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat('/', substring-before($path, '/'))"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:call-template name="url-parser-filepath">
			<xsl:with-param name="path" select="substring-after($path, '/')"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>
<xsl:template name="url-parser-filename">
	<xsl:param name="path"/>
	
	<xsl:choose>
		<xsl:when test="contains($path, '/')">
			<xsl:call-template name="url-parser-filename">
				<xsl:with-param name="path" select="substring-after($path, '/')"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$path"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>



</xsl:stylesheet>
