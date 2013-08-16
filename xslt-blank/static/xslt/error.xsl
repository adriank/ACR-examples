<?xml version="1.0" encoding="UTF-8"?>
<x:stylesheet xmlns:x="http://www.w3.org/1999/XSL/Transform"
	version="1.0">

	<x:output method="html"
						doctype-system="about:legacy-compat"
						encoding="UTF-8"/>

	<x:variable name="lang" select="//object[@name='acr:lang']/@current"/>
	<!-- IE doesn't understand relative paths so domain MUST be predefined -->
	<x:variable name="config" select="//object[@name='acr:appDetails']"/>
	<x:variable name="domain" select="$config/@domain"/>
	<x:variable name="localeDoc" select="document(concat('http://',$domain,'/locale/',$lang,'.xml'))/t"/>
	<x:variable name="errorLocaleDoc" select="document(concat('http://',$domain,'/locale/errors/',$lang,'.xml'))/t"/>

	<x:template match="/">
		<x:variable name="error" select="//*[@name='acr:globalError']/@error"/>
		<html>
			<head>
				<title>
					<x:value-of select="$error"/>
					-
					<x:value-of select="$localeDoc/siteName/node()"/>
				</title>
				<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
				<!--<link href="{$static}css/style.css" rel="stylesheet" type="text/css"/>-->
			</head>
			<body>
				<h1>GlobalError <x:value-of select="$error"/></h1>
				<x:value-of select="$errorLocaleDoc//*[local-name()=$error]"/>
				<x:value-of select="//*[@name='acr:globalError']/@message"/>
				<!--<x:variable name="x" select="'exists:xxx'"/>-->
				<!--<x:value-of select="starts-with($x,'exists')"/>-->
			</body>
		</html>
	</x:template>
</x:stylesheet>
