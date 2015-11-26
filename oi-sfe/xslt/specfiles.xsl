<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:strip-space elements="*"/>
  <xsl:output method="text"/>

  <xsl:param name="encumbered">false</xsl:param>

  <xsl:template match="/pkgs">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="pkg">
    <xsl:if test="(not(@skip='true'))">
       <xsl:if test="($encumbered='true' and @encumbered='true') or ($encumbered!='true' and not(@encumbered='true'))">
	 <xsl:choose>
	   <xsl:when test="@filename">
	     <xsl:value-of select="@filename"/>
	   </xsl:when>
	   <xsl:otherwise>
	     <xsl:value-of select="./name"/>
	     <xsl:text>.spec</xsl:text>
	   </xsl:otherwise>
	 </xsl:choose>
         <xsl:text>
</xsl:text>
       </xsl:if>
    </xsl:if>

  </xsl:template>
</xsl:stylesheet>
