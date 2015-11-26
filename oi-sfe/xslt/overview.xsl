<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="xhtml xsl">

  <xsl:output
      method="xml"
      doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
      indent="yes"
      omit-xml-declaration="yes"/>

  <xsl:param name="encumbered">false</xsl:param>

  <xsl:template match="/pkgs">
    <html>
      <head>
        <title>Packages
        <xsl:if test="$encumbered='true'">(encumbered)</xsl:if>
        </title>
      </head>
      <body>
        <h1>Packages
        <xsl:if test="$encumbered='true'">(encumbered)</xsl:if>
        </h1>
        <table border="1">
        <tr>
          <th>Name</th>
          <th>IPS Name</th>
          <th>Group</th>
        </tr>
        <xsl:apply-templates/>
        </table>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="pkg">
    <xsl:if test="($encumbered='true' and @encumbered='true') or ($encumbered!='true' and not(@encumbered='true'))">
      <xsl:variable name="subpackages" select="count(./pkg)+1"/>

      <tr>
        <td>
        <xsl:if test="$subpackages &gt; 1">
          <xsl:attribute name="rowspan">
            <xsl:value-of select="$subpackages"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:value-of select="./name"/>
        </td>
        <td>
        <xsl:value-of select="./ips_package_name"/>
        </td>
        <td>
        <xsl:value-of select="./group"/>
        </td>
      </tr>

      <xsl:for-each select="./pkg">
      <tr>
        <td>
        <xsl:value-of select="./ips_package_name"/>
        </td>
        <td>
        <xsl:value-of select="./group"/>
        </td>
      </tr>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
