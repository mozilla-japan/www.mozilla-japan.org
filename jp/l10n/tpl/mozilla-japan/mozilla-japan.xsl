<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:tt="http://dynamis.jp/2003/TransTools"
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns="http://www.w3.org/1999/xhtml"
	version="1.0"
	xml:lang="ja-JP">

<xsl:import href="../../xsl/page.xsl"/>
<!-- import により定義を上書きすることで出力を調整可能 -->
<xsl:include href="product.xsl"/>
<xsl:include href="faq.xsl"/>
<xsl:include href="term.xsl"/>


<xsl:output method="xml"
	doctype-public="-//W3C//DTD HTML 4.01//EN"
	doctype-system="http://www.w3.org/TR/html4/strict.dtd"
	encoding="EUC-JP"
	indent="no"
	/>
<!-- indent="no" としないと空白制御ができない -->

<xsl:variable name="env-year-from"	select="'2004'"/>
<xsl:variable name="env-year"		select="'2005'"/>


<xsl:template match="/tt:contents/tt:page" xml:space="preserve">
	<xsl:apply-templates select="document('mozilla-japan.xml')"/>
</xsl:template>


<!-- * section * -->
<xsl:template match="tt:section">
	<div id="{@id}">
		<xsl:attribute name="class">section <xsl:value-of select="@class"/></xsl:attribute>
		<xsl:apply-templates select="node()"/><!-- node() とすると class 属性を重複生成することになる -->
	</div>
</xsl:template>


<!-- * page meta info * -->
<!-- ページ右上に author と target を表示する -->
<xsl:template match="tt:htmlbody/html:*[position()=1 and (local-name()='h1' or local-name()='h2')]">
	<xsl:copy>
		<xsl:copy-of select="@*[namespace-uri()='']"/>
		<xsl:apply-templates select="@tt:*"/>
		<xsl:apply-templates select="child::node()"/>
	</xsl:copy>
	<xsl:if test="$meta/dc:creator | $meta/dcterms:audience">
		<address>
			<xsl:if test="$meta/dc:creator">
				author: 
				<xsl:for-each select="$meta/dc:creator">
					<dc:creator><xsl:value-of select="."/></dc:creator>
					<xsl:if test="position() != last()">, </xsl:if>
				</xsl:for-each>
				<br/>
			</xsl:if>
			<xsl:if test="$meta/dcterms:audience">
				target: 
				<xsl:for-each select="$meta/dcterms:audience">
					<dcterms:audience><xsl:value-of select="."/></dcterms:audience>
					<xsl:if test="position() != last()">, </xsl:if>
				</xsl:for-each>
				<br/>
			</xsl:if>
		</address>
	</xsl:if>
</xsl:template>


<!-- * page header/sidebar/footer * -->
<xsl:template mode="header" match="tt:htmlbody">
	<xsl:choose>
		<xsl:when test="tt:header">
			<div id="header">
				<xsl:apply-templates select="tt:header/node()"/>
			</div>
		</xsl:when>
		<xsl:otherwise><!-- ページ専用のものがない場合 MJ 共通のデフォルト出力 -->
			<xsl:call-template name="include">
				<xsl:with-param name="id" select="'header-mj'"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
<xsl:template mode="sidebar" match="tt:htmlbody">
	<xsl:choose>
		<xsl:when test="tt:sidebar">
			<div id="side">
				<xsl:apply-templates select="tt:sidebar/node()"/>
			</div>
		</xsl:when>
		<xsl:otherwise><!-- ページ専用のものがない場合 L10N 共通のデフォルト出力 -->
			<xsl:call-template name="include">
				<xsl:with-param name="id" select="'sidebar-l10n'"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
<xsl:template mode="footer" match="tt:htmlbody">
	<xsl:choose>
		<xsl:when test="tt:footer">
			<div id="footer">
				<xsl:apply-templates select="tt:footer/node()"/>
			</div>
		</xsl:when>
		<xsl:otherwise><!-- ページ専用のものがない場合 L10N 共通のデフォルト出力 -->
			<xsl:call-template name="include">
				<xsl:with-param name="id" select="'footer-l10n'"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
