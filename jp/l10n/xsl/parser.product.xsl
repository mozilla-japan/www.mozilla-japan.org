<?xml version="1.0" encoding="EUC-JP"?>

<!--		parser.product.xsl  ���ʥǡ����ѥѡ���
   -
   -	productdb.xml �ǡ�������Ѥ��뤿��γ�ĥ�ѡ���
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


<xsl:variable name="productdb"			select="document('../db/productdb.xml') | document('../db/productdb.firefox.xml') | document('../db/productdb.thunderbird.xml') | document('../db/productdb.mozilla.xml')"/>
<xsl:variable name="productdb-product"	select="$productdb/tt:database/tt:product"/>
<xsl:variable name="productdb-server"	select="$productdb/tt:database/tt:server"/>
<xsl:variable name="persondb"			select="document('../db/persondb.xml')"/>
<xsl:variable name="persondb-person"	select="$persondb/tt:database/tt:person"/>
<xsl:variable name="sitedb"				select="document('../db/sitedb.xml')"/>
<xsl:variable name="sitedb-site"		select="$sitedb/tt:database/tt:site"/>
<xsl:variable name="sitedb-mj"			select="$sitedb/tt:database/tt:site[@id = 'mozilla-japan']"/>



<!-- * interface * -->
<!-- <tt:packagetable product="foo" version="X.X.x" server="bar" lastonly="yes|no" excludeplatform="win linux mac ..." excludefiletype="installer zip ..." format=""/> -->
<xsl:template match="tt:packagetable">
	<xsl:variable name="pid" select="@product"/>
	<xsl:variable name="ver" select="@version"/>
	<xsl:variable name="product-version" select="$productdb-product[@id=$pid]/tt:version[@full=$ver or $ver='']"/>
	
	<xsl:if test="not($product-version)">
		<p>XSL ���ϥ��顼: ��������ʤϥǡ����١������¸�ߤ��ޤ���<br/>
			����ID: <xsl:value-of select="$pid"/><br/>
			�С�������ֹ�: <xsl:value-of select="$ver"/><br/>
			���Υ��顼�򥵥��ȴ����ԤޤǤ�Ϣ��ĺ����й����Ǥ���</p>
	</xsl:if>
	<xsl:call-template name="packagetable-product">
		<xsl:with-param name="version" select="$product-version"/>
		<xsl:with-param name="server" select="@server"/>
		<xsl:with-param name="without-thead" select="true()"/><!--  -->
		<xsl:with-param name="last-only" select="@lastonly = 'yes'"/><!-- yes: package ��٥��ʣ�������ΤϺǿ��Τ�ΤΤ� -->
		<xsl:with-param name="ex-platform" select="@excludeplatform"/>
		<xsl:with-param name="ex-type" select="@excludefiletype"/>
	</xsl:call-template>
</xsl:template>


<!-- ���� version �γ� pacakge ��ꥹ�Ƚ��� -->
<!-- <tt:packagelist product="foo" version="X.X.x" server="bar" lastonly="yes|no" format="linkonly"/> -->
<xsl:template match="tt:packagelist">
	<xsl:variable name="pid" select="@product"/>
	<xsl:variable name="ver" select="@version"/>
	<xsl:variable name="server" select="@server"/>
	<xsl:variable name="format" select="@format"/><!-- linkonly ����ꤹ��� [YYYY/MM/DD] ���ά -->
	<xsl:variable name="last-only" select="@lastonly = 'yes'"/><!-- ������ -->
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
					&#xA0;&#xA0;
					<span class="note"><xsl:apply-templates select="tt:note"/></span>
				</xsl:if>
			</li>
		</xsl:for-each>
	</ul>
</xsl:template>


<!-- ���� product �γ� package �� version ��˥ꥹ�Ƚ��� -->
<!-- <tt:versionlist product="foo"/> -->
<xsl:template match="tt:versionlist">
	<xsl:variable name="pid" select="@product"/>
	<xsl:variable name="server" select="@server"/>
	<xsl:variable name="format" select="@format"/><!-- linkonly ����ꤹ��� [YYYY/MM/DD] ���ά -->
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
					&#xA0;&#xA0;
					<span class="note"><xsl:apply-templates select="tt:note"/></span>
				</xsl:if>
			</li>
		</xsl:for-each>
	</ul>
</xsl:template>



<!-- * file list of package * -->
<!-- file|mirror �Υ�󥯤���� -->
<xsl:template name="filelink">
	<xsl:param name="file" select="."/><!-- file|mirror ���� -->
	<xsl:param name="text" select="$file/@serverid"/><!-- �ǥե���ȥ�󥯥ƥ����Ȥϥ�����ID -->
	<xsl:param name="title"/>
	<xsl:param name="url"><!-- URL ʸ����(�̾��ά) -->
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
<!-- package �۲��� file|mirror �ؤΥ�󥯤� delimiter ���ڤ�ǽ��� -->
<xsl:template name="filelist">
	<xsl:param name="package" select="."/><!-- package ���� -->
	<xsl:param name="delimiter" select="', '"/>
	
	<xsl:choose><!-- �ե�������Ͽ�����뤫�ɤ��� -->
		<xsl:when test="count($package/tt:file[@url != '']) != 0">
			<!-- | ����Ѥ����Ρ��ɥ��åȤˤ�� for-each �롼����� last() �ؿ���Ȥ��ȥ롼���������ٺǽ�����ǤΤߤǼ¹Ԥ����褦�ˤʤ��
				���Τ��Ϥ褯ʬ����ʤ����� XSLT �ѡ����ΥХ��ǤϤʤ����Ȼפ��롣��ꤢ���� count($nodeset) �� last() �����Ѥ�����
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
<!-- package ���̤˱�������٥����� -->
<xsl:template name="platform-name">
	<xsl:param name="platform" select="@platform"/>
	
	<xsl:choose>
		<xsl:when test="$platform = 'all'">�� OS �б� </xsl:when>
		<xsl:when test="$platform = 'win+linux'">Win/Linux �� </xsl:when>
		<xsl:when test="$platform = 'win'">Windows �� </xsl:when>
		<xsl:when test="$platform = 'linux'">Linux �� </xsl:when>
		<xsl:when test="$platform = 'mac'">MacOS X �� </xsl:when>
	</xsl:choose>
</xsl:template>
<xsl:template name="type-name">
	<xsl:param name="type" select="@type"/>
	
	<xsl:choose>
		<xsl:when test="$type = 'installer'">���󥹥ȡ���</xsl:when>
		<xsl:when test="$type = 'xpi'">XPI �ѥå�����</xsl:when>
		<xsl:when test="$type = 'source'">������������</xsl:when>
		<xsl:when test="$type = 'jar'">�¹Բ�ǽ JAR</xsl:when>
		<xsl:otherwise><xsl:value-of select="concat(' ', $type, ' ����������')"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>
<xsl:template name="package-label">
	<xsl:param name="package" select="."/><!-- package ���� -->
	
	<xsl:call-template name="platform-name">
		<xsl:with-param name="platform" select="$package/@platform"/>
	</xsl:call-template>
	<xsl:call-template name="type-name">
		<xsl:with-param name="type" select="$package/@type"/>
	</xsl:call-template>
</xsl:template>
<!-- package ����ե������1������� URL ����� -->
<xsl:template name="package-url">
	<xsl:param name="package" select="."/><!-- package ���� -->
	<xsl:param name="server"/><!-- �����Ф� ID ʸ����ǻ��� -->
	
	<xsl:choose>
		<xsl:when test="$server != ''">
			<xsl:if test="$package/tt:file[@serverid = $server and @url != '']"><!-- ���ꥵ���ФΥե����뤬�ʤ��Ȥ��Ͻ��Ϥ��ʤ� -->
				<xsl:value-of select="$package/tt:file[@serverid = $server]/@url"/>
			</xsl:if>
		</xsl:when>
		<!-- �ʲ��������Ф�ͥ���̤������ -->
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
<!-- package �Υ�󥯤����(�ǥե���ȥ����Ф� file �Τ�) -->
<xsl:template name="packagelink">
	<xsl:param name="package" select="."/><!-- package ���� -->
	<xsl:param name="server"/><!-- �����Ф� ID ʸ����ǻ��� -->
	<xsl:param name="text"><!-- �ǥե���ȥ�󥯥ƥ����Ȥ� package-label �ƥ�ץ졼�Ȥˤ�� -->
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
<!-- version �۲��� package �ؤΥ�󥯤� delimiter ���ڤ�ǽ��� -->
<xsl:template name="packagelist">
	<xsl:param name="version" select="."/><!-- version ���� -->
	<xsl:param name="delimiter" select="', '"/>
	
	<xsl:choose><!-- �ե�������Ͽ�����뤫�ɤ��� -->
		<xsl:when test="count($version/tt:package[tt:file/@url != '']) != 0">
			<!-- count($nodeset) �� last() �����Ѥ��Ƥ���ΤϾ�Ҥ� filelist Ʊ�ͤ���ͳ -->
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





<!-- * ���� version �� package �ΰ���ɽ����� * -->
<!-- �� package �ν���(�ꥹ�Ƚ�����) -->
<xsl:template name="packagetable-list-item">
	<xsl:param name="package" select="."/><!-- package ���� -->
	<xsl:param name="server"/>

	<tr>
		<td class="center">
			<xsl:choose>
				<xsl:when test="$package/@platform = 'win+linux'">
					<img src="http://www.mozilla-japan.org/jp/l10n/img/ico-os-win.gif" alt="" class="osicon"/>
					<img src="http://www.mozilla-japan.org/jp/l10n/img/ico-os-linux.gif" alt="" class="osicon"/>
				</xsl:when>
				<xsl:when test="$package/@platform = 'win'">
					<img src="http://www.mozilla-japan.org/jp/l10n/img/ico-os-win.gif" alt="" class="osicon"/>
				</xsl:when>
				<xsl:when test="$package/@platform = 'linux'">
					<img src="http://www.mozilla-japan.org/jp/l10n/img/ico-os-linux.gif" alt="" class="osicon"/>
				</xsl:when>
				<xsl:when test="$package/@platform = 'mac'">
					<img src="http://www.mozilla-japan.org/jp/l10n/img/ico-os-mac.gif" alt="" class="osicon"/>
				</xsl:when>
				<xsl:otherwise>&#xA0;</xsl:otherwise><!-- �������ɻ� -->
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
				<xsl:otherwise>&#xA0;</xsl:otherwise><!-- �������ɻ� -->
			</xsl:choose>
		</td>
		<td class="note">
			<xsl:for-each select="$package/../tt:checksum/tt:file[@serverid=$server]">
				<xsl:if test="position() != 1">&#xA0;</xsl:if>
				<xsl:variable name="type" select="@type"/>
				<a href="{@url}" title="{$package/@*[name() = $type]}"><xsl:value-of select="@type"/></a>
			</xsl:for-each>
			<xsl:if test="not($package/../tt:checksum/tt:file[@serverid=$server])">&#xA0;</xsl:if><!-- �������ɻ� -->
		</td>
	</tr>
	<xsl:if test="tt:note != ''">
		<tr>
			<td colspan="4" class="note">
				&#xA0;&#xA0;
				<xsl:apply-templates select="tt:note"/>
			</td>
		</tr>
	</xsl:if>
</xsl:template>
<!-- �ץ�åȥե����प��ӥѥå�������ǥ����Ȥ��ƽ��� -->
<xsl:template name="packagetable-list-sort">
	<xsl:param name="packages" select="/.."/><!-- package ���ǥꥹ�� -->
	<xsl:param name="last-only"/><!-- ������ -->
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


<!-- �� package �ν���(�ץ�åȥե������̽�����) -->
<xsl:template name="packagetable-platform-item">
	<xsl:param name="package" select="."/><!-- package ���� -->
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
						<xsl:value-of select="concat('������: ', $package/@date)"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="$package/@revision">
					<xsl:value-of select="concat('(rev.', $package/@revision, ')')"/>
				</xsl:if>
			</span>
		</xsl:when>
		<xsl:otherwise>
			<xsl:attribute name="class">none</xsl:attribute>
			&#xA0;
		</xsl:otherwise><!-- �������ɻ� -->
	</xsl:choose>
	<!-- ���Υե����ޥåȤǤϥѥå������̤Υ����Ȥ�̵�뤵��� -->
</xsl:template>
<!-- �ץ�åȥե������̤� -->
<xsl:template name="packagetable-platform">
	<xsl:param name="packages" select="/.."/><!-- package ���ǥꥹ�� -->
	<xsl:param name="platform" select="$packages/@platform"/><!-- package ���ǥꥹ�� -->
	<xsl:param name="xpi-packages"			select="$packages[@type = 'xpi']"/>
	<xsl:param name="installer-packages"	select="$packages[@type = 'installer']"/>
	<xsl:param name="source-packages"		select="$packages[@type = 'source']"/>
	<xsl:param name="jar-packages"			select="$packages[@type = 'jar']"/>
	<xsl:param name="misc-packages"			select="$packages[@type != 'xpi' and @type != 'installer' and @type != 'source' and @type != 'jar']"/>
	<xsl:param name="last-only"/><!-- ������ -->
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

<!-- �ץ�åȥե������̤ˤޤȤ�ƽ��� -->
<xsl:template name="packagetable-group-by-platform">
	<xsl:param name="packages" select="/.."/><!-- package ���ǥꥹ�� -->
	<xsl:param name="last-only"/><!-- ������ -->
	<xsl:param name="server"/>
	
	<xsl:if test="$packages">
		<xsl:variable name="platform" select="$packages[1]/@platform"/>
		
		<tbody class="{$packages/@platform}">
			<tr>
				<th colspan="5">
					<xsl:choose>
						<xsl:when test="$platform = 'win'">
							<img src="http://www.mozilla-japan.org/jp/l10n/img/ico-os-win.gif" alt="" class="osicon"/>
						</xsl:when>
						<xsl:when test="$platform = 'linux'">
							<img src="http://www.mozilla-japan.org/jp/l10n/img/ico-os-linux.gif" alt="" class="osicon"/>
						</xsl:when>
						<xsl:when test="$platform = 'mac'">
							<img src="http://www.mozilla-japan.org/jp/l10n/img/ico-os-mac.gif" alt="" class="osicon"/>
						</xsl:when>
					</xsl:choose>
					<!-- &#xA0; -->
					<xsl:call-template name="platform-name">
						<xsl:with-param name="platform" select="$platform"/>
					</xsl:call-template>
					<xsl:if test="$packages/../tt:md5list/tt:file[@serverid=$server]">
						<a href="{$packages/../tt:md5list/tt:file[@serverid=$server]/@url}" title="gnu md5sum �ˤ������å�����ꥹ��" class="note">[md5]</a>
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


<!-- ���ʤ� package �ꥹ�� -->
<xsl:template name="packagetable-product">
	<xsl:param name="version" select="/.."/><!-- version ����ɬ�� -->
	<xsl:param name="server"/><!-- ������ ID ʸ���� -->
	<xsl:param name="without-thead"/><!-- ������ -->
	<xsl:param name="without-tfoot"/><!-- ������ -->
	<xsl:param name="last-only"/><!-- ������ -->
	<xsl:param name="ex-platform"/><!-- �ץ�åȥե�����̾ʸ���� -->
	<xsl:param name="ex-type"/><!-- �ѥå�������̾ʸ���� -->
	
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
			<!-- tfoot �ǽ��Ϥ���ȥơ��֥������100%�ˤ��Ƥ��ޤ�����֤��餱��ɽ�ˤʤ�� -->
			<xsl:if test="contains($version/@stage, 'development')">
				<xsl:choose>
					<xsl:when test="contains($version/@full, '+')">
						<p class="note"><xsl:value-of select="concat($version/../@shortname, ' ', translate($version/@full, '+', ''))"/> ��꡼����˼��Υ�꡼���ظ����Ƥν����Ȥ��ƺ���������ȯ��꡼���Ǥ���ư���ǧ�ʤɤ��ؤɤ��Ƥ���ޤ���Τǡ������Ѥˤʤ���ˤϽ�ʬ�ˤ���դ���������</p>
					</xsl:when>
					<xsl:when test="contains($version/@full, '-')">
						<p class="note"><xsl:value-of select="concat($version/../@shortname, ' ', translate($version/@full, '-', ''))"/> ��꡼���ظ����Ƥν����Ȥ��ƺ���������ȯ��꡼���Ǥ���ư���ǧ�ʤɤ��ؤɤ��Ƥ���ޤ���Τǡ������Ѥˤʤ���ˤϽ�ʬ�ˤ���դ���������</p>
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
			<p>���� <xsl:value-of select="concat($version/../@shortname, ' ', translate($version/@full, '+', ''))"/> �Ͻ�����Ǥ���</p>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>







<!-- * person list output * -->
<xsl:variable name="userinfo-prefix"	select="'http://moz.skillup.jp/jlp/profile.php?mode=viewprofile&amp;u='"/>

<xsl:template name="personlink">
	<xsl:param name="person" select="."/><!-- person ���� -->
	<xsl:choose>
		<xsl:when test="$person/@forumuserid">
			<a href="{concat($userinfo-prefix, $person/@forumuserid)}">
				<xsl:value-of select="$person/@name"/>
			</a>
		</xsl:when>
		<xsl:when test="$sitedb-site[@id = concat($person/@id, '-site')]">
			<a href="{$sitedb-site[@id = concat($person/@id, '-site')]/@url}">
				<xsl:value-of select="$person/@name"/>
			</a>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="@name"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="tt:stafflist">
	<xsl:for-each select="$persondb-person[contains(concat(@role, ' '), 'jlpstaff ')]">
		<xsl:call-template name="personlink"/>
		<xsl:if test="position() != last()">, </xsl:if>
	</xsl:for-each>
	&#xA0;
	<span class="note" title="���ष�������å�">(
		<xsl:for-each select="$persondb-person[contains(concat(@pastrole, ' '), 'jlpstaff ')]">
			<xsl:call-template name="personlink"/>
			<xsl:if test="position() != last()">, </xsl:if>
		</xsl:for-each>
	)</span>
</xsl:template>
<xsl:template match="tt:contributerlist">
	<xsl:for-each select="$persondb-person[contains(concat(@role, ' '), 'contributer ')]">
		<xsl:call-template name="personlink"/>
		<xsl:if test="position() != last()">, </xsl:if>
	</xsl:for-each>
	<!-- <span class="note" title="���ι׸���">(
		<xsl:for-each select="$persondb-person[contains(concat(@pastrole, ' '), 'contributer ')]">
			<xsl:call-template name="personlink"/>
			<xsl:if test="position() != last()">, </xsl:if>
		</xsl:for-each>
	)</span> -->
</xsl:template>











<!-- $sitedb-site[@id = concat($person/@id, '-site')]/@url -->


<xsl:template name="creatortable-package">
	<xsl:param name="platform"/>
	<xsl:param name="type"/>
	
	<tbody>
		<tr>
			<td>
			</td>
			<td>
			</td>
			<td>
			</td>
		</tr>
	</tbody>
</xsl:template>

<xsl:template name="creatortable-product">
	<xsl:param name="product" select="."/><!-- product ���� -->
	
	<thead>
		<tr><td conspan="3">
			<xsl:value-of select="$product/@name"/>
		</td></tr>
		<tr><td></td><td></td><td></td></tr>
	</thead>
	<xsl:for-each select="$product/tt:version/tt:package           ">
		<xsl:call-template name="creatortable-package"/>
	</xsl:for-each>
</xsl:template>
<!-- 
<xsl:template name="tt:creatortable">
	<xsl:variable name="products" select="@products"/>
	
	<table class="creatortable">
		<xsl:for-each select="$productdb-product[contains(concat($products, ' '), concat(@id, ' '))]">
			<xsl:call-template name="productcreators"/>
		</xsl:for-each>
	</table>
</xsl:template>
 -->



</xsl:stylesheet>
