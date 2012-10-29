<?xml version="1.0" encoding="UTF-8"?>
<!-- <!DOCTYPE stylesheet [ <!ENTITY copy CDATA "&#xA9;"> ] > -->

<!--		page.xsl  基本テンプレート集
   -
   -	ページ中の基本的な要素を生成する TransTools 要素の処理
   -	これ以外の処理については各テンプレート側で定義する
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


<!-- TransTools パーサの読み込み -->
<!-- required -->
<xsl:include href="parser.xsl"/>
<!-- optional -->
<!-- <xsl:include href="product.xsl"/> -->
<!-- <xsl:include href="faq.xsl"/> -->
<!-- <xsl:include href="term.xsl"/> -->
<!-- <xsl:include href="breadcrumbs.xsl"/> -->

<!-- * tt:meta * -->
<xsl:template match="tt:meta"/>

<xsl:template match="tt:meta[normalize-space(@mode)='title']">
	<xsl:apply-templates select="$page/tt:meta" mode="title"/>
</xsl:template>
<xsl:template match="tt:meta" mode="title">
	<xsl:if test="normalize-space(dc:title) != ''">
		<xsl:value-of select="dc:title"/>
	</xsl:if>
</xsl:template>

<xsl:template match="tt:meta[normalize-space(@mode)='creator']">
	<xsl:apply-templates select="$page/tt:meta" mode="creator"/>
</xsl:template>
<xsl:template match="tt:meta" mode="creator">
	<xsl:if test="normalize-space(dc:creator) != ''">
		<xsl:value-of select="dc:creator"/>
	</xsl:if>
</xsl:template>

<xsl:template match="tt:meta[normalize-space(@mode)='audience']">
	<xsl:apply-templates select="$page/tt:meta" mode="audience"/>
</xsl:template>
<xsl:template match="tt:meta" mode="audience">
	<xsl:if test="normalize-space(dcterms:audience) != ''">
		<xsl:value-of select="dcterms:audience"/>
	</xsl:if>
</xsl:template>


<xsl:template match="tt:meta[normalize-space(@mode)='address']">
	<xsl:apply-templates select="$page/tt:meta" mode="address"/>
</xsl:template>
<xsl:template match="tt:meta" mode="address">
	<xsl:if test="dc:creator | dcterms:audience">
		<address>
			<xsl:if test="$meta/dc:creator">
				<xsl:text>author: </xsl:text>
				<xsl:for-each select="$meta/dc:creator">
					<dc:creator><xsl:value-of select="."/></dc:creator>
					<xsl:if test="position() != last()">, </xsl:if>
				</xsl:for-each>
				<br/><xsl:value-of select="$newline"/>
			</xsl:if>
			<xsl:if test="$meta/dcterms:audience">
				<xsl:text>target: </xsl:text>
				<xsl:for-each select="$meta/dcterms:audience">
					<dcterms:audience><xsl:value-of select="."/></dcterms:audience>
					<xsl:if test="position() != last()">, </xsl:if>
				</xsl:for-each>
			</xsl:if>
		</address>
	</xsl:if>
</xsl:template>



<!-- * tt:htmlheader * -->
<xsl:template match="tt:htmlheader">
	<xsl:apply-templates select="node()"/>
	<xsl:if test="not(title) and ../tt:meta/dc:title">
		<title><xsl:value-of select="concat($config-property[@name='site.name']/@value, ' - ', normalize-space(../tt:meta/dc:title))"/></title>
	</xsl:if>
</xsl:template>
<xsl:template match="html:html//tt:htmlheader">
	<xsl:apply-templates select="$page/tt:htmlheader"/>
</xsl:template>



<!-- * tt:htmlbody * -->
<xsl:template match="html:html//tt:htmlbody">
	<xsl:apply-templates select="$page/tt:htmlbody"/>
</xsl:template>
<xsl:template match="tt:htmlbody">
	<xsl:apply-templates select="node()"/>
</xsl:template>



<!-- * page toc * -->
<xsl:template match="tt:toc">
	<xsl:apply-templates select="$page/tt:htmlbody" mode="toc"/>
</xsl:template>
<xsl:template mode="toc" match="tt:htmlbody">
	<ul id="toc">
		<xsl:choose>
			<xsl:when test="tt:section">
				<xsl:apply-templates mode="toc" select="tt:section"/>
			</xsl:when>
			<xsl:otherwise>
				<li>XSL 出力エラー: 目次対象となる見出し要素が見つかりません。</li>
			</xsl:otherwise>
		</xsl:choose>
	</ul>
</xsl:template>
<xsl:template mode="toc" match="tt:section|tt:subsection">
	<li>
		<a href="#{@id}"><xsl:value-of select="html:*[translate(local-name(), 'h123456', 'H******') = 'H*'][position()=1]"/></a>
		<xsl:if test="tt:subsection">
			<ul>
				<xsl:apply-templates mode="toc" select="tt:subsection"/>
			</ul>
		</xsl:if>
	</li>
</xsl:template>



<!-- * page contents body * -->
<xsl:template match="tt:section|tt:subsection">
	<div id="{@id}">
		<xsl:attribute name="class"><xsl:value-of select="concat(local-name(), ' ', @class)"/></xsl:attribute>
		<xsl:apply-templates select="node()"/><!-- node() とすると class 属性を重複生成することになる -->
	</div>
</xsl:template>







<!-- * page header/side/footer field * -->
<xsl:template match="html:html//tt:header">
	<xsl:apply-templates select="$page/tt:htmlbody" mode="header"/>
</xsl:template>
<xsl:template mode="header" match="tt:htmlbody">
	<xsl:choose>
		<xsl:when test="tt:header"><!-- ページ専用のものがあればそれを使用 -->
			<div id="header">
				<xsl:apply-templates select="tt:header/node()"/>
			</div>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="include">
				<xsl:with-param name="id" select="'header-default'"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="html:html//tt:sidebar">
	<xsl:apply-templates select="$page/tt:htmlbody" mode="sidebar"/>
</xsl:template>
<xsl:template mode="sidebar" match="tt:htmlbody">
	<xsl:choose>
		<xsl:when test="tt:sidebar"><!-- ページ専用のものがあればそれを使用 -->
			<div id="side">
				<xsl:apply-templates select="tt:sidebar/node()"/>
			</div>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="include">
				<xsl:with-param name="id" select="'sidebar-default'"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="html:html//tt:footer">
	<xsl:apply-templates select="$page/tt:htmlbody" mode="footer"/>
</xsl:template>
<xsl:template mode="footer" match="tt:htmlbody">
	<xsl:choose>
		<xsl:when test="tt:footer"><!-- ページ専用のものがあればそれを使用 -->
			<div id="footer">
				<xsl:apply-templates select="tt:footer/node()"/>
			</div>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="include">
				<xsl:with-param name="id" select="'footer-default'"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


</xsl:stylesheet>
