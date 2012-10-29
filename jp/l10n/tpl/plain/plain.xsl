<?xml version="1.0" encoding="UTF-8"?>

<!--  plain.xsl   プレインテンプレート  -->

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

<!--
<xsl:output method="xml"
	doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
	doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
	encoding="UTF-8"
	indent="no"
	/> 
-->

<xsl:output method="html"
	doctype-public="-//W3C//DTD HTML 4.01//EN"
	doctype-system="http://www.w3.org/TR/html4/strict.dtd"
	encoding="UTF-8"
	indent="no"
	/>
<!-- indent="no" としないと空白制御ができない -->


<xsl:template match="/tt:contents/tt:page">
	<xsl:comment><xsl:value-of select="' plain style '"/></xsl:comment>
	<xsl:apply-templates select="document('plain.xml')"/>
</xsl:template>

</xsl:stylesheet>
