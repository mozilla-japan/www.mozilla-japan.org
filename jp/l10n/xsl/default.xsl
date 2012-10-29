<?xml version="1.0" encoding="EUC-JP"?>

<!--  default.xsl   標準形式出力  -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:tt="http://dynamis.jp/2003/TransTools"
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns="http://www.w3.org/1999/xhtml"
	version="1.0"
	xml:lang="ja-JP">

<xsl:import href="page.xsl"/>
<!-- import により定義を上書きすることで出力を調整 -->

<!--
<xsl:output method="xml"
	doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
	doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
	encoding="EUC-JP"
	indent="no"
	/> 
-->

<xsl:output method="html"
	doctype-public="-//W3C//DTD HTML 4.01//EN"
	doctype-system="http://www.w3.org/TR/html4/strict.dtd"
	encoding="EUC-JP"
	indent="no"
	/>
<!-- indent="no" としないと空白制御ができない -->



<xsl:variable name="format"			select="'default'"/>
<xsl:variable name="lang"			select="'japanese'"/>
<xsl:variable name="env-year-from"	select="'2004'"/>
<xsl:variable name="env-year"		select="'2004'"/>


<xsl:template match="/tt:contents/tt:page" xml:space="preserve">
<html template="none"><xsl:comment><xsl:value-of select="' defaut style '"/></xsl:comment>
<head>
	<xsl:apply-templates select="tt:htmlheader"/>
</head>
<body>
	<div id="container">
		<p class="skipLink"><a href="#mainContent" accesskey="2">メインコンテンツへスキップ</a></p>
		
		<xsl:apply-templates select="tt:htmlbody" mode="header"/>
		
		<hr class="hide"/>
		
		<div id="mBody">
			<xsl:apply-templates select="tt:htmlbody" mode="sidebar"/>
			<hr class="hide"/>
			<xsl:apply-templates select="tt:htmlbody"/>
		</div>
		
		<hr class="hide"/>
		
		<xsl:apply-templates select="tt:htmlbody" mode="footer"/>
	</div><xsl:comment> close #container </xsl:comment>
</body>
</html>
</xsl:template>



</xsl:stylesheet>
