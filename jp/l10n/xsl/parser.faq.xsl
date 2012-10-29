<?xml version="1.0" encoding="EUC-JP"?>

<!-- 		parser.faq.xsl  FAQ データ用パーサ
   -
   -	faqdb.xml データを使用するための拡張パーサ
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


<xsl:variable name="faqdb"				select="document('../db/faqdb.xml')"/>
<xsl:variable name="faqdb-meta"			select="$faqdb/tt:database/tt:meta"/>
<xsl:variable name="faqdb-section"		select="$faqdb/tt:database/tt:section"/>
<xsl:variable name="faqdb-entry"		select="$faqdb/tt:database/tt:section/tt:entry"/>



<!-- * interface * -->
<!-- <tt:faqlink entryid="" text="" /> -->
<xsl:template match="tt:faqlink">
	<xsl:variable name="entryid" select="@entryid"/>
	<a>
		<xsl:attribute name="href">
			<xsl:call-template name="faq.entryhref">
				<xsl:with-param name="entry" select="$faqdb-entry[@id = $entryid]"/>
			</xsl:call-template>
		</xsl:attribute>
		<xsl:choose>
			<xsl:when test="*|text()">
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:when test="@text != ''">
				<xsl:value-of select="@text"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$faqdb-entry[@id = $entryid]/tt:question"/>
			</xsl:otherwise>
		</xsl:choose>
	</a>
</xsl:template>
<!-- <a tt:faqhref=""/> -->
<xsl:template match="@tt:faqentryhref">
	<xsl:variable name="entryid" select="."/>
	<xsl:attribute name="href">
		<xsl:call-template name="faq.entryhref">
			<xsl:with-param name="entry" select="$faqdb-entry[@id = $entryid]"/>
		</xsl:call-template>
	</xsl:attribute>
</xsl:template>


<!-- <tt:faqtitle section=""/> -->
<xsl:template match="tt:faqtitle">
	<xsl:apply-templates select="$faqdb-meta/tt:title"/>
	<xsl:if test="@section != ''">
		<xsl:variable name="sectionid" select="@section"/>
		<xsl:value-of select="concat(' - ', $faqdb-section[@id = normalize-space($sectionid)]/tt:title)"/>
	</xsl:if>
</xsl:template>


<!-- <tt:faq section="" /> -->
<xsl:template match="tt:faq">
	<xsl:choose>
		<xsl:when test="@section != ''">
			<xsl:variable name="sectionid" select="@section"/>
			<xsl:apply-templates select="$faqdb-section[@id = normalize-space($sectionid)]"/>
		</xsl:when>
		<xsl:when test="@entry != ''">
			<xsl:variable name="entry" select="@entry"/>
			<xsl:apply-templates select="$faqdb-entry[@id = normalize-space($entry)]"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates select="$faqdb/tt:database"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- <tt:faqindex section="" /> -->
<xsl:template match="tt:faqindex">
	<xsl:choose>
		<xsl:when test="@section != ''">
			<xsl:variable name="sectionid" select="@section"/>
			<ol>
				<xsl:for-each select="$faqdb-section">
					<li>
						<xsl:choose>
							<xsl:when test="@id = normalize-space($sectionid)">
								<xsl:apply-templates select="tt:title"/>
								<xsl:apply-templates mode="index-entry-list" select="."/>
							</xsl:when>
							<xsl:otherwise>
								<a>
									<xsl:attribute name="href"><xsl:call-template name="faq.sectionhref"/></xsl:attribute>
									<xsl:apply-templates select="tt:title"/>
								</a>
							</xsl:otherwise>
						</xsl:choose>
					</li>
				</xsl:for-each>
			</ol>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates mode="index" select="$faqdb/tt:database"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="tt:faqsectionlist">
	<ol>
		<xsl:for-each select="$faqdb-section">
			<li>
				<a>
					<xsl:attribute name="href"><xsl:call-template name="faq.sectionhref"/></xsl:attribute>
					<xsl:apply-templates select="tt:title"/>
				</a>
			</li>
		</xsl:for-each>
	</ol>
</xsl:template>

<xsl:template match="tt:faqentrylist">
	<xsl:variable name="sectionid" select="@section"/>
	<xsl:apply-templates mode="index-entry-list" select="$faqdb-section[@id = normalize-space($sectionid)]"/>
</xsl:template>



<!-- * common * -->
<xsl:template name="faq.entryid">
	<xsl:param name="entry" select="."/><!-- entry 要素 -->
	<xsl:choose>
		<xsl:when test="$entry/@id != ''"><xsl:value-of select="$entry/@id"/></xsl:when>
		<xsl:otherwise>q<xsl:for-each select="$entry[1]"><xsl:number level="multiple" format="1.1" count="tt:section|tt:entry"/></xsl:for-each></xsl:otherwise><!-- for-each を使用しているのは entry を with-param でカレントノードと異なるものが渡されたときのため -->
	</xsl:choose>
</xsl:template>

<xsl:template name="faq.entryhref">
	<xsl:param name="entry" select="."/><!-- entry 要素 -->
	<xsl:param name="filename" select="$faqdb-meta/tt:output/tt:page[@type = 'section' and @idref = $entry/../@id]/@filename"/>
	<xsl:call-template name="url-filter">
		<xsl:with-param name="url">
			<xsl:value-of select="concat($faqdb-meta/tt:output/@basepath, $filename, '#')"/>
			<xsl:call-template name="faq.entryid">
				<xsl:with-param name="entry" select="$entry"/>
			</xsl:call-template>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template name="faq.sectionhref">
	<xsl:param name="section" select="."/><!-- section 要素 -->
	<xsl:param name="filename" select="$faqdb-meta/tt:output/tt:page[@type='section' and @idref = $section/@id]/@filename"/>
	<xsl:call-template name="url-filter">
		<xsl:with-param name="url" select="concat($faqdb-meta/tt:output/@basepath, $filename)"/>
	</xsl:call-template>
</xsl:template>



<!-- * main output * -->
<xsl:template match="tt:database[@type='faqdb']">
	<xsl:for-each select="tt:section">
		<xsl:apply-templates select="."/>
	</xsl:for-each>
</xsl:template>

<xsl:template match="tt:database[@type='faqdb']//tt:section">
	<div class="section" id="{@id}">
		<h3><xsl:number/>. <xsl:apply-templates select="tt:title"/></h3>
		<dl>
			<xsl:apply-templates select="tt:entry[tt:question != '']"/>
		</dl>
		<p class="note right">[<a href="./">FAQ 一覧に戻る</a>]</p>
	</div>
</xsl:template>

<xsl:template match="tt:database[@type='faqdb']//tt:title">
	<xsl:apply-templates select="node()"/>
</xsl:template>

<xsl:template match="tt:database[@type='faqdb']//tt:entry">
	<dt>
		<xsl:attribute name="id">
			<xsl:call-template name="faq.entryid"/>
		</xsl:attribute>
		<xsl:number level="multiple" format="1.1 " count="tt:section|tt:entry"/>
		<xsl:apply-templates select="tt:question/node()"/>
	</dt>
	<dd><xsl:apply-templates select="tt:answer/node()"/></dd>
</xsl:template>



<!-- * index output * -->
<xsl:template mode="index" match="tt:database[@type='faqdb']">
	<ol id="index">
		<xsl:for-each select="tt:section">
			<li><xsl:apply-templates mode="index" select="."/></li>
		</xsl:for-each>
	</ol>
</xsl:template>

<xsl:template mode="index" match="tt:database[@type='faqdb']//tt:section">
	<a>
		<xsl:attribute name="href"><xsl:call-template name="faq.sectionhref"/></xsl:attribute>
		<xsl:apply-templates select="tt:title"/>
	</a>
	<xsl:apply-templates mode="index-entry-list" select="."/>
</xsl:template>
<xsl:template mode="index-entry-list" match="tt:database[@type='faqdb']//tt:section">
	<xsl:if test="tt:entry[tt:question != '']">
		<ol id="{concat('index_', @id)}">
			<xsl:for-each select="tt:entry[tt:question != '']">
				<li>
					<xsl:apply-templates mode="index" select="."/>
				</li>
			</xsl:for-each>
		</ol>
	</xsl:if>
</xsl:template>


<xsl:template mode="index" match="tt:database[@type='faqdb']//tt:section/tt:entry">
	<a>
		<xsl:attribute name="href"><xsl:call-template name="faq.entryhref"/></xsl:attribute>
		<xsl:apply-templates select="tt:question/node()"/>
	</a>
</xsl:template>



</xsl:stylesheet>
