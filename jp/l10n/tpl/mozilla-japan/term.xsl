<?xml version="1.0" encoding="UTF-8"?>

<!-- 		parser.term.xsl  用語データ用パーサ
   -
   -	termdb.xml データを使用するための拡張パーサ
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


<xsl:variable name="termdb"				select="document('../../db/termdb.xml')"/>
<xsl:variable name="termdb-term"		select="$termdb/tt:database//tt:term"/>


<!-- * interface * -->
<!-- <tt:term mode="index|glossary|en-ja" class="" os="" software=""/> -->
<xsl:template match="tt:termlist">
	<xsl:variable name="mode" select="@mode"/>
	<xsl:variable name="class" select="@class"/>
	<xsl:variable name="os" select="@os"/>
	<xsl:variable name="software" select="@software"/>
	<xsl:variable name="status" select="@status"/>
	<xsl:variable name="page" select="@page"/>
	
	<xsl:variable name="classterm" select="$termdb-term[not($class) or ancestor-or-self::*[contains(@class, $class)]]"/>
	<xsl:variable name="osterm" select="$classterm[not($os) or ancestor-or-self::*[contains(@os, $os)]]"/>
	<xsl:variable name="softwareterm" select="$osterm[not($software) or ancestor-or-self::*[contains(@software, $software)]]"/>
	<xsl:variable name="targetterm" select="$softwareterm[contains(tt:ja/@status, $status)]"/>
	
	<xsl:choose>
		<xsl:when test="@mode = 'index'">
			<ul class="termlist-index">
				<xsl:for-each select="$targetterm[tt:en != '' or tt:ja != '']">
					<xsl:sort select="@id"/>
					<li>
						<xsl:apply-templates mode="index" select=".">
							<xsl:with-param name="page" select="$page"/>
						</xsl:apply-templates>
					</li>
				</xsl:for-each>
			</ul>
		</xsl:when>
		<xsl:when test="@mode = 'en-ja'">
			<dl class="terminology en-ja">
				<xsl:for-each select="$targetterm[tt:en != '' and tt:ja != '']">
					<xsl:sort select="@id"/>
					<xsl:apply-templates mode="en-ja" select=".">
						<xsl:with-param name="status" select="$status"/>
					</xsl:apply-templates>
				</xsl:for-each>
			</dl>
		</xsl:when>
		<xsl:when test="@mode = 'glossary'">
			用語集出力機能は未実装
		</xsl:when>
		<xsl:otherwise>
			<p>TransToolsError: tt:termlist 要素の mode 属性が指定されていません。</p>
			<!-- <xsl:apply-templates select="$termdb/tt:database">
				<xsl:with-param name="class" select="@class"/>
				<xsl:with-param name="os" select="@os"/>
				<xsl:with-param name="software" select="@software"/>
			</xsl:apply-templates> -->
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="tt:termcount">
	<xsl:variable name="mode" select="@mode"/>
	<xsl:variable name="class" select="@class"/>
	<xsl:variable name="os" select="@os"/>
	<xsl:variable name="software" select="@software"/>
	<xsl:variable name="status" select="@status"/>
	
	<xsl:variable name="classterm" select="$termdb-term[not($class) or ancestor-or-self::*[contains(@class, $class)]]"/>
	<xsl:variable name="osterm" select="$classterm[not($os) or ancestor-or-self::*[contains(@os, $os)]]"/>
	<xsl:variable name="softwareterm" select="$osterm[not($software) or ancestor-or-self::*[contains(@software, $software)]]"/>
	<xsl:variable name="statusterm" select="$softwareterm[contains(tt:ja/@status, $status)]"/>
	<xsl:variable name="targetterm" select="$statusterm[(not($mode) and (tt:en != '' or tt:ja != ''))
		or ($mode = 'en-ja' and (tt:en != '' and tt:ja != ''))]"/>
	
	<xsl:value-of select="count($targetterm)"/>
</xsl:template>




<!-- * common * -->
<xsl:template name="termname">
	<xsl:param name="mainlang" select="'ja'"/>
	<xsl:choose>
		<xsl:when test="tt:en = ''"><xsl:value-of select="tt:ja"/></xsl:when>
		<xsl:when test="tt:ja = ''"><xsl:value-of select="tt:en"/></xsl:when>
		<xsl:when test="$mainlang = 'en'"><xsl:value-of select="concat(tt:en, ' (', tt:ja, ')')"/></xsl:when>
		<xsl:otherwise><xsl:value-of select="concat(tt:ja, ' (', tt:en, ')')"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="classlist">
	<xsl:param name="term" select="/.."/><!-- tt:term|tt:group -->
	<xsl:if test="$term/@class != ''"><xsl:value-of select="concat($term/@class, ' ')"/></xsl:if>
	<xsl:if test="local-name($term/..) != 'database' or not($term/..)">
		<xsl:call-template name="classlist"><xsl:with-param name="term" select="$term/.."/></xsl:call-template> 
	</xsl:if>
</xsl:template>
<xsl:template name="oslist">
	<xsl:param name="term" select="/.."/><!-- tt:term|tt:group -->
	<xsl:if test="$term/@os != ''"><xsl:value-of select="concat($term/@os, ' ')"/></xsl:if>
	<xsl:if test="local-name($term/..) != 'database' or not($term/..)">
		<xsl:call-template name="oslist"><xsl:with-param name="term" select="$term/.."/></xsl:call-template> 
	</xsl:if>
</xsl:template>
<xsl:template name="softwarelist">
	<xsl:param name="term" select="/.."/><!-- tt:term|tt:group -->
	<xsl:if test="$term/@software != ''"><xsl:value-of select="concat($term/@software, ' ')"/></xsl:if>
	<xsl:if test="local-name($term/..) != 'database' or not($term/..)">
		<xsl:call-template name="softwarelist"><xsl:with-param name="term" select="$term/.."/></xsl:call-template> 
	</xsl:if>
</xsl:template>

<xsl:template name="termcheck">
	<xsl:param name="term" select="/.."/><!-- tt:term|tt:group -->
	<xsl:param name="class"/>
	<xsl:param name="os"/>
	<xsl:param name="software"/>
	<xsl:variable name="classlist">
		<xsl:call-template name="classlist"><xsl:with-param name="term" select="$term"/></xsl:call-template>
	</xsl:variable>
	<xsl:variable name="oslist">
		<xsl:call-template name="oslist"><xsl:with-param name="term" select="$term"/></xsl:call-template>
	</xsl:variable>
	<xsl:variable name="softwarelist">
		<xsl:call-template name="softwarelist"><xsl:with-param name="term" select="$term"/></xsl:call-template>
	</xsl:variable>
	<xsl:if test="( not($class) or contains($classlist, concat($class, ' ')) )
		and ( not($os) or contains($oslist, concat($os, ' ')) )
		and ( not($software) or contains($softwarelist, concat($software, ' ')) )">true</xsl:if>
</xsl:template>


<!-- * main output * -->
<xsl:template match="tt:database[@type='termdb']">
	<xsl:for-each select="//tt:term">
		<xsl:sort select="@id"/>
		<xsl:apply-templates select="."/>
	</xsl:for-each>
</xsl:template>

<xsl:template match="tt:database[@type='termdb']//tt:term">
	<dt><xsl:call-template name="termname"/></dt>
	<dd>
		<xsl:for-each select="tt:ja">
			<xsl:if test="position() != 1"> | </xsl:if>
			<xsl:value-of select="."/>
		</xsl:for-each>
	</dd>
</xsl:template>



<!-- * en-ja output * -->
<xsl:template mode="en-ja" match="tt:database[@type='termdb']//tt:term">
	<xsl:param name="status"/>
	<dt id="{@id}">
		<xsl:choose>
			<xsl:when test="@abbr != ''">
				<abbr title="{@abbr}"><xsl:value-of select="tt:en"/></abbr>
			</xsl:when>
			<xsl:when test="@acronym != ''">
				<acronym title="{@acronym}"><xsl:value-of select="tt:en"/></acronym>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="tt:en"/>
			</xsl:otherwise>
		</xsl:choose>
	</dt>
	<dd>
		<xsl:if test="tt:note">
			<xsl:attribute name="title">
				<xsl:value-of select="tt:note"/>
			</xsl:attribute>
		</xsl:if>
		<!-- $status 指定に一致する訳語のみを出力する -->
		<xsl:for-each select="tt:ja[not($status) or contains(@status, $status) or (not(@status) and $status = 'example')]">
			<xsl:if test="position() != 1"> | </xsl:if>
			<xsl:choose>
				<xsl:when test="contains(@status, 'obsolete') or contains(@status, 'wrong')">
					<del class="{@status}"><xsl:value-of select="."/></del>
				</xsl:when>
				<xsl:when test="@status != ''">
					<span class="{@status}"><xsl:value-of select="."/></span>
				</xsl:when>
				<xsl:otherwise><span class="example"><xsl:value-of select="."/></span></xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<xsl:if test="tt:relate">
			<xsl:value-of select="'&#xA0;&#xA0;&#xA0;'"/>
			<span class="relate">
				<xsl:for-each select="tt:relate">
					<xsl:if test="position() = 1">c.f. </xsl:if>
					<xsl:variable name="refid" select="@refid"/>
					<xsl:if test="position() != 1">, </xsl:if>
					<a href="{concat('#', @refid)}"><xsl:value-of select="$termdb-term[@id = $refid]/tt:en"/></a>
				</xsl:for-each>
			</span>
		</xsl:if>
	</dd>
</xsl:template>



<!-- * index output * -->
<xsl:template mode="index" match="tt:database[@type='termdb']//tt:term">
	<xsl:param name="page"/>
	<xsl:if test="@id != ''">
		<a href="{concat($page, '#', @id)}">
			<xsl:call-template name="termname">
				<xsl:with-param name="mainlang" select="'en'"/>
			</xsl:call-template>
		</a>
	</xsl:if>
</xsl:template>




</xsl:stylesheet>
