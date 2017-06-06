<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:functx="http://www.functx.com"
        xmlns:xs="http://www.w3.org/2001/XMLSchema"
        version="2.0">
  
  <xsl:output method="text"/>
  <xsl:output indent="yes"/>
  
  <xsl:template match="/html/body/div/nav/ul">
    <xsl:result-document href="120.json">
      [<xsl:apply-templates/>]
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template match="li">
{
"title": "<xsl:value-of select="normalize-space(a/text())"/>",
"path": "<xsl:value-of select="a[1]/@href"/>"
<xsl:if test="ul/*">
  ,"items": [<xsl:text>&#x20;&#x20;</xsl:text><xsl:apply-templates/>]
</xsl:if>}<xsl:if test="following-sibling::li">,</xsl:if>
  </xsl:template>
  
  <xsl:template match="text()"/>
  
</xsl:stylesheet>