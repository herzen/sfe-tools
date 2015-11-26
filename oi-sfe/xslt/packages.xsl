<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:strip-space elements="*"/>
<xsl:output method="text"/>

<xsl:template match="/">
<!-- <xsl:apply-templates select="pkgs/pkg"/> -->
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="pkg">

 <xsl:value-of select="name"/>
 <xsl:text>:</xsl:text>

 <xsl:value-of select="ips_package_name"/>
 <xsl:text>:</xsl:text>

 <xsl:value-of select="group"/>
 <xsl:text>:</xsl:text>
 <xsl:value-of select="summary"/>
 <xsl:text>:</xsl:text>
 <xsl:text>&#xA;</xsl:text>
</xsl:template>

</xsl:stylesheet>
