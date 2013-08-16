<?xml version="1.0" encoding="UTF-8"?>
<x:stylesheet xmlns:x="http://www.w3.org/1999/XSL/Transform"
	version="1.0">

<!--	<x:output method="html" version="4.01" encoding="UTF-8"
		doctype-public="-//W3C//DTD HTML 4.01//EN"
		doctype-system="http://www.w3.org/TR/html4/strict.dtd"/>-->
	<x:output method="html"
						doctype-system="about:legacy-compat"
						encoding="UTF-8"/>

	<!-- TODO some of these variables should be merged with others -->
	<!--<x:variable name="doc" select="/list//*"/>-->
	<x:variable name="lang" select="//object[@name='acr:lang']/@current"/>
	<!-- IE doesn't understand relative paths so domain MUST be predefined -->
	<x:variable name="config" select="//object[@name='acr:appDetails']"/>
	<x:variable name="domain" select="$config/@domain"/>
	<x:variable name="langdoc" select="document(concat('http://',$domain,'/locale/',$lang,'.xml'))/t"/>
	<x:variable name="tempdoc" select="document(concat('http://',$domain,'/xml/templates.xml'))/t"/>
	<x:variable name="static" select="concat('http://',$domain,'/')"/>
	<x:variable name="role" select="//object[@name='acr:user']/@role"/>
	<x:variable name="layoutdoc" select="//object[@name='layout']"/>
	<x:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
	<x:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
	<x:variable name="defaultPageWidth" select="'whole'" />

	<x:variable name="BS_VER">3.0.0-rc1</x:variable>

	<x:template match="/">
		<html lang="">
			<x:attribute name="lang"><x:value-of select="/list/object[@name='acr:lang']/@current"/></x:attribute>
		<head>
			<title>
				<x:for-each select="$layoutdoc//pageTitle/node()">
					<x:call-template name="template">
						<x:with-param name="dataSource" select="(//object|//list)[@name=$layoutdoc//pageTitle/@dataSource]"/>
					</x:call-template>
				</x:for-each>
				-
				<x:value-of select="$langdoc/siteName/node()"/>
			</title>
			<meta name="description" content="{//desc/node()}"/>
			<meta name="keywords" content="{//keyWords/node()}"/>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
			<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
			<link href="//netdna.bootstrapcdn.com/bootstrap/{$BS_VER}/css/bootstrap.min.css" rel="stylesheet"/>
			<link href="//netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome.css" rel="stylesheet"/>
			<x:for-each select="//style">
				<x:choose>
					<x:when test="@url">
						<link href="{@url}" rel="stylesheet" type="text/css"/>
					</x:when>
					<x:otherwise>
						<x:copy-of select="."/>
					</x:otherwise>
				</x:choose>
			</x:for-each>
			<script src="//code.jquery.com/jquery.js"/>
			<script src="//netdna.bootstrapcdn.com/bootstrap/{$BS_VER}/js/bootstrap.min.js"/>
			<script type="text/javascript"><x:value-of select="//*[@name='layout']//script/node()"/></script>
			<x:for-each select="//script[@url]">
				<script type="text/javascript" src="{@url}"/>
			</x:for-each>
		</head>
		<body>
			<x:apply-templates select="$layoutdoc"/>
			<x:if test="count(//object[@name='acr:globalError'])">
				<h1>GlobalError <x:value-of select="//object[@name='acr:globalError']/@error"/></h1>
				<x:value-of select="//object[@name='acr:globalError']/@message"/>
			</x:if>
		</body>
		</html>
	</x:template>

	<x:template match="container">
		<x:variable name="t">
			<x:value-of select="@type"/>
			<x:if test="not(@type)">container</x:if>
		</x:variable>
		<div id="cont-{@name}" class="{$t} {@name} {@class}">
			<x:apply-templates select="./*"/>
		</div>
	</x:template>

	<x:template match="div">
		<div class="{@class}">
			<x:apply-templates/>
		</div>
	</x:template>

	<x:template match="column">
		<x:variable name="width">
			span<x:value-of select="@width"/>
			<x:if test="not(@width)">span12</x:if>
		</x:variable>
		<div id="col-{@name}" class="{$width} {@name} {@class}">
			<x:apply-templates select="./*"/>
		</div>
	</x:template>

	<x:template match="script|pageTitle|style"/>

	<x:template match="widget" name="widget">
		<x:param name="dataSource" select="(//object|//list)[@name=current()/@dataSource]"/>
		<x:variable name="tag">
			<x:value-of select="@tag"/>
			<x:if test="not(@tag)">div</x:if>
		</x:variable>
		<x:element name="{$tag}">
			<x:if test="not(@mode) or @mode!='tree' or $dataSource/@name!=@childName">
				<x:attribute name="id"><x:value-of select="@name"/></x:attribute>
			</x:if>
			<x:attribute name="title"><x:value-of select="@desc"/></x:attribute>

			<x:variable name="before">
				<x:for-each select="before/node()">
					<x:call-template name="template">
						<x:with-param name="dataSource" select="$dataSource"/>
					</x:call-template>
				</x:for-each>
			</x:variable>

			<x:variable name="type">
				<x:value-of select="@type"/>
				<x:if test="not(@type)">template</x:if>
			</x:variable>

			<x:variable name="subtag">
				<x:value-of select="@subtag"/>
				<x:if test="not(@subtag)">div</x:if>
			</x:variable>

			<x:choose>
				<x:when test="local-name($dataSource)='list' and count($dataSource/object)">
					<x:attribute name="class">widget <x:value-of select="$type"/>-list <x:value-of select="@class"/></x:attribute>
					<x:copy-of select="$before"/>
					<x:variable name="this" select="."/>
					<x:variable name="subtagclass" select="@subtagclass"/>
					<x:if test="$role='admin'">
						<div class="accms-optionsPanel"/>
					</x:if>
					<x:for-each select="$dataSource/object">
						<x:element name="{$subtag}">
							<x:attribute name="class">
								widget <x:value-of select="$type"/>-item
								<x:if test="position()=1">first </x:if>
								<x:if test="position() mod 2=1">odd </x:if>
								<x:if test="position() mod 2=0">even </x:if>
								<x:value-of select="$subtagclass"/>
							</x:attribute>
							<x:apply-templates mode="widget" select="$this">
								<x:with-param name="dataSource" select="."/>
							</x:apply-templates>
							<x:if test="$this/@mode='tree' and ./*[@name=$this/@childName]/node()">
								<x:variable name="data" select="*[@name=$this/@childName]"/>
								<x:for-each select="$this">
									<x:call-template name="widget">
										<x:with-param name="dataSource" select="$data"/>
									</x:call-template>
								</x:for-each>
							</x:if>
						</x:element>
					</x:for-each>
				</x:when>
				<x:when test="not(@dataSource) or $dataSource/node() or @showEmpty='true' or @type='form'">
					<x:attribute name="class">widget <x:value-of select="$type"/>-item <x:value-of select="@class"/></x:attribute>
					<x:copy-of select="$before"/>
					<x:apply-templates mode="widget" select=".">
						<x:with-param name="dataSource" select="$dataSource"/>
					</x:apply-templates>
					<x:if test="@mode='tree' and $dataSource/*[@name=current()/@childName]/node()">
						<x:call-template name="widget">
							<x:with-param name="dataSource" select="$dataSource/*[@name=current()/@childName]"/>
						</x:call-template>
					</x:if>
				</x:when>
				<!--<x:otherwise>nodata TODO make customization possible <x:value-of select="$langdoc//*[local-name()='noData']"/></x:otherwise>-->
			</x:choose>

			<x:for-each select="after/node()">
				<x:call-template name="template">
					<x:with-param name="dataSource" select="."/>
				</x:call-template>
			</x:for-each>
		</x:element>
	</x:template>

	<x:template match="access">
		<a href="#" accesskey="{@key}"/>
	</x:template>

	<!-- TODO add required fields support -->
	<x:template match="widget[@type='form']" mode="widget">
		<x:param name="dataSource" select="//object[@name=current()/@dataSource]"/>
		<form action="{@action}" method="post" enctype="multipart/form-data">
			<x:variable name="name" select="@name"/>
			<x:for-each select="*">
				<x:variable name="value">
					<x:variable name="helper" select="$dataSource/*[name()=current()/@name]"/>
					<x:choose>
						<x:when test="@value">
							<x:copy-of select="//object[@name=current()/@value]/node()"/>
						</x:when>
						<x:when test="count(node())">
							<x:for-each select="node()">
								<x:call-template name="template">
									<x:with-param name="dataSource" select="$dataSource"/>
								</x:call-template>
							</x:for-each>
						</x:when>
						<x:otherwise>
							<x:copy-of select="$helper/node()"/>
						</x:otherwise>
					</x:choose>
				</x:variable>
				<x:choose>
					<x:when test="local-name(.)='widget'">
						<x:call-template name="widget">
							<x:with-param name="dataSource" select="//*[@name=current()/@dataSource]"/>
						</x:call-template>
					</x:when>
					<x:when test="local-name()='item' and @type='hidden'">
						<input id="{$name}-{@name}" type="{@type}" name="{@name}" value="{$value}"/>
					</x:when>
					<x:when test="local-name()='item' and @type!='hidden'">
						<x:variable name="required">
							<x:if test="@required"> required</x:if>
						</x:variable>
						<div class="item {@type} {$name}-{@name}{$required}">
							<x:if test="not(@label) or @label!='disabled'">
								<label for="{$name}-{@name}">
									<x:variable name="ml" select="$langdoc//*[local-name()=current()/@ml]"/>
									<x:choose>
										<x:when test="$ml">
											<x:value-of select="$ml"/>
										</x:when>
										<x:when test="not($ml) and @ml">
											ml.<x:value-of select="@ml"/>
										</x:when>
										<x:otherwise>
											ml attribute was not set for <b><x:value-of select="@name"/></b>
										</x:otherwise>
									</x:choose>
								</label>
							</x:if>
							<x:choose>
								<x:when test="@type='text' or @type='file' or @type='hidden' or @type='password' or @type='number'">
									<input id="{$name}-{@name}" type="{@type}" name="{@name}" value="{$value}" accesskey="{@accesskey}" title="{@title}"/>
								</x:when>
								<x:when test="@type='button'">
									<button id="{$name}-{@name}" name="{@name}" class="{@name}" accesskey="{@accesskey}"><x:copy-of select="$value"/></button>
								</x:when>
								<x:when test="@type='textarea'">
									<textarea id="{$name}-{@name}" name="{@name}" accesskey="{@accesskey}" title="{@title}"><x:copy-of select="$value"/></textarea>
								</x:when>
								<x:when test="@type='richText'">
									<textarea id="{$name}-{@name}" name="{@name}" accesskey="{@accesskey}" class="acenv-richText"><x:value-of select="$value"/></textarea>
								</x:when>
								<x:when test="@type='checkbox'">
									<input id="{$name}-{@name}" type="checkbox" name="{@name}" value="true" accesskey="{@accesskey}" title="{@title}">
									<x:if test="translate($value, $uppercase, $smallcase)='true' or translate(@checked, $uppercase, $smallcase)='true'">
										<x:attribute name="checked">checked</x:attribute>
									</x:if>
									</input>
								</x:when>
								<x:when test="@type='spinner'">
									<div class="spinner">
										<input id="{$name}-{@name}" name="{@name}" type="text" class="yui-spinner-value" value="{$value}" title="{@title}"/>
									</div>
								</x:when>
								<x:when test="@type='time'">
									<x:variable name="time" select="$dataSource/*[name()=current()/@name]"/>
									<div class="accms-time">
										<input id="{$name}-{@name}-h" maxlength="2" name="{@name}_h" type="text" value="{$time/@hour}" title="godzina w formacie gg"/>
										<input id="{$name}-{@name}-m" maxlength="2" name="{@name}_m" type="text" value="{$time/@minute}" title="minuta w formacie mm"/>
									</div>
								</x:when>
								<x:when test="@type='date'">
									<x:variable name="date" select="$dataSource/*[name()=current()/@name]"/>
									<div class="accms-date">
										<!--<input id="{$name}-{@name}-y" maxlength="4" name="{@name}_y" type="text" value="{$value}" title="rok w formacie rrrr"/>-->
										<select id="{$name}-{@name}-y" name="{@name}_y">
											<option value="2011">
												<x:if test="$date/@year=2011"><x:attribute name="selected">selected</x:attribute></x:if>
												2011
											</option>
											<option value="2012">
												<x:if test="$date/@year=2012"><x:attribute name="selected">selected</x:attribute></x:if>
												2012
											</option>
											<option value="2013">
												<x:if test="$date/@year=2013 or not(@year)"><x:attribute name="selected">selected</x:attribute></x:if>
												2013
											</option>
											<option value="2014">
												<x:if test="$date/@year=2014"><x:attribute name="selected">selected</x:attribute></x:if>
												2014
											</option>
											<option value="2015">
												<x:if test="$date/@year=2015"><x:attribute name="selected">selected</x:attribute></x:if>
												2015
											</option>
										</select>
										<!--<input id="{$name}-{@name}-m" maxlength="2" name="{@name}_m" type="text" value="{$value}" title="miesiąc w formacie mm"/>-->
										<select id="{$name}-{@name}-m" name="{@name}_m">
											<x:variable name="month" select="number($date/@month)"/>
											<option value="1">
												<x:if test="$month=1"><x:attribute name="selected">selected</x:attribute></x:if>
												<x:value-of select="$langdoc//january"/>
											</option>
											<option value="2">
												<x:if test="$month=2"><x:attribute name="selected">selected</x:attribute></x:if>
												<x:value-of select="$langdoc//february"/>
											</option>
											<option value="3">
												<x:if test="$month=3"><x:attribute name="selected">selected</x:attribute></x:if>
												<x:value-of select="$langdoc//march"/>
											</option>
											<option value="4">
												<x:if test="$month=4"><x:attribute name="selected">selected</x:attribute></x:if>
												<x:value-of select="$langdoc//april"/>
											</option>
											<option value="5">
												<x:if test="$month=5"><x:attribute name="selected">selected</x:attribute></x:if>
												<x:value-of select="$langdoc//may"/>
											</option>
											<option value="6">
												<x:if test="$month=6"><x:attribute name="selected">selected</x:attribute></x:if>
												<x:value-of select="$langdoc//june"/>
											</option>
											<option value="7">
												<x:if test="$month=7"><x:attribute name="selected">selected</x:attribute></x:if>
												<x:value-of select="$langdoc//july"/>
											</option>
											<option value="8">
												<x:if test="$month=8"><x:attribute name="selected">selected</x:attribute></x:if>
												<x:value-of select="$langdoc//august"/>
											</option>
											<option value="9">
												<x:if test="$month=9"><x:attribute name="selected">selected</x:attribute></x:if>
												<x:value-of select="$langdoc//september"/>
											</option>
											<option value="10">
												<x:if test="$month=10"><x:attribute name="selected">selected</x:attribute></x:if>
												<x:value-of select="$langdoc//october"/>
											</option>
											<option value="11">
												<x:if test="$month=11"><x:attribute name="selected">selected</x:attribute></x:if>
												<x:value-of select="$langdoc//november"/>
											</option>
											<option value="12">
												<x:if test="$month=12"><x:attribute name="selected">selected</x:attribute></x:if>
												<x:value-of select="$langdoc//december"/>
											</option>
										</select>
										<input id="{$name}-{@name}-d" maxlength="2" name="{@name}_d" type="text" value="{$date/@day}" title="dzień w formacie dd"/>
									</div>
								</x:when>
								<x:otherwise>
									<select id="{$name}-{@name}" name="{@name}" accesskey="{@accesskey}" class="{@class}">
										<x:if test="count(@multiple)">
											<x:attribute name="multiple">multiple</x:attribute>
										</x:if>
										<x:for-each select="//*[@name=current()/@type]/*">
											<x:variable name="optionValue">
												<x:choose>
													<x:when test="count(@value)=1"><x:value-of select="@value"/></x:when>
													<x:when test="count(value)"><x:value-of select="value"/></x:when>
													<x:otherwise><x:value-of select="."/></x:otherwise>
												</x:choose>
											</x:variable>
											<option value="{$optionValue}" title="{@title}">
												<x:if test="$optionValue=$value">
													<x:attribute name="selected">selected</x:attribute>
												</x:if>
												<x:value-of select="$langdoc//*[local-name()=current()/@ml]|name|@name"/>
											</option>
										</x:for-each>
									</select>
								</x:otherwise>
							</x:choose>
						</div>
					</x:when>
					<x:otherwise>
						<x:copy-of select="."/>
					</x:otherwise>
				</x:choose>
			</x:for-each>
			<x:if test="not(@submit) or @submit!='none'">
				<x:variable name="submitText">
					<x:value-of select="@submitText"/>
					<x:value-of select="$langdoc//*[local-name()=current()/@submitTextML]"/>
					<x:if test="not(@submitText or @submitTextML)">
						<x:value-of select="$langdoc/submit/node()"/>
					</x:if>
				</x:variable>
				<input id="{$name}-submit" name="submit" class="submit" value="{$submitText}" type="submit" accesskey="s"/>
			</x:if>
		</form>
	</x:template>

	<!--
		dataSource is element with data for node
		context is template schema
	-->
	<x:template name="template">
		<x:param name="dataSource"/>
		<x:variable name="conditionNode" select="$dataSource/*[local-name()=current()/@condition]"/>
		<x:if test="not(@condition) or @condition and $conditionNode">
			<x:choose>
				<x:when test="local-name(.)='import'">
					<x:for-each select="$tempdoc/*[local-name()=current()/@name]/node()">
						<x:call-template name="template">
							<x:with-param name="dataSource" select="$dataSource"/>
						</x:call-template>
					</x:for-each>
				</x:when>
				<x:when test="local-name(.)='ml'">
					<x:variable name="ml" select="$langdoc//*[local-name()=current()/@name]/node()"/>
					<x:if test="@name">
						<x:choose>
							<x:when test="$ml">
								<x:copy-of select="$ml"/>
							</x:when>
							<x:otherwise>
								ml.<x:value-of select="@name"/>
							</x:otherwise>
						</x:choose>
					</x:if>
					<x:if test="@node">
						<x:copy-of select="$langdoc//*[local-name()=$dataSource/*[local-name()=current()/@node]/node()]/node()"/>
					</x:if>
				</x:when>
				<x:when test="local-name(.)='time'">
					<x:variable name="curr" select="$dataSource/*[local-name()=current()/@from]"/>
					<x:value-of select="concat($curr/@hour,':',$curr/@minute)"/>
				</x:when>
				<x:when test="local-name(.)='date'">
					<x:variable name="curr" select="$dataSource/*[local-name()=current()/@from]"/>
					<x:value-of select="concat($curr/@day,'/',$curr/@month,'/',$curr/@year)"/>
				</x:when>
				<x:when test="local-name(.)='node'">
					<x:copy-of select="$dataSource/*[local-name()=current()/@name]/node()"/>
				</x:when>
				<x:when test="local-name(.)='attr'">
					<x:choose>
						<x:when test="@node">
							<x:value-of select="$dataSource/*[local-name()=current()/@node]/@*[local-name()=current()/@name]"/>
						</x:when>
						<x:otherwise>
							<x:value-of select="$dataSource/@*[local-name()=current()/@name]"/>
						</x:otherwise>
					</x:choose>
				</x:when>
				<x:when test="local-name(.)='widget'">
					<x:if test="@dataSource">
						<x:call-template name="widget">
							<x:with-param name="dataSource" select="$dataSource/*[@name=current()/@dataSource]"/>
						</x:call-template>
					</x:if>
					<x:if test="not(@dataSource)">
						<x:call-template name="widget">
							<x:with-param name="dataSource" select="$dataSource"/>
						</x:call-template>
					</x:if>
				</x:when>
				<x:when test="not(name())">
					<x:value-of select="."/>
				</x:when>
				<x:otherwise>
					<x:element name="{local-name()}">
						<x:for-each select="@*">
							<x:attribute name="{local-name()}">
								<x:variable name="temp">
									<x:value-of select="."/>
									<x:for-each select="parent::*/pars[@for=local-name(current())]/node()">
										<x:call-template name="template">
											<x:with-param name="dataSource" select="$dataSource"/>
										</x:call-template>
									</x:for-each>
								</x:variable>
								<x:value-of select="$temp"/>
							</x:attribute>
						</x:for-each>
						<x:for-each select="text()|*[local-name()!='pars']">
							<x:call-template name="template">
								<x:with-param name="dataSource" select="$dataSource"/>
							</x:call-template>
						</x:for-each>
					</x:element>
				</x:otherwise>
			</x:choose>
		</x:if>
	</x:template>

	<x:template match="widget[@type='template']|widget[not(@type)]" name="templateWidget" mode="widget">
		<x:param name="dataSource" select="@dataSource"/>
		<x:choose>
			<x:when test="count(template)">
				<x:choose>
					<x:when test="template/@schemaFrom">
						<x:for-each select="$tempdoc/*[local-name()=$dataSource/*[local-name()=current()/template/@schemaFrom]]/node()">
							<x:call-template name="template">
								<x:with-param name="dataSource" select="$dataSource"/>
							</x:call-template>
						</x:for-each>
					</x:when>
					<x:when test="template/@name">
						<x:for-each select="//*[local-name()=current()/@name]/node()">
							<x:call-template name="template">
								<x:with-param name="dataSource" select="$dataSource"/>
							</x:call-template>
						</x:for-each>
					</x:when>
					<x:otherwise>
						<x:for-each select="template/*">
							<x:call-template name="template">
								<x:with-param name="dataSource" select="$dataSource"/>
							</x:call-template>
						</x:for-each>
					</x:otherwise>
				</x:choose>
			</x:when>
			<x:otherwise>
				<x:for-each select="*|text()">
					<x:call-template name="template">
						<x:with-param name="dataSource" select="$dataSource"/>
					</x:call-template>
				</x:for-each>
			</x:otherwise>
		</x:choose>
	</x:template>

</x:stylesheet>
