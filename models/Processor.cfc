/**
 * Ortus Markdown Module
 * Copyright 2013 Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * Convert markdown to HTML via the MarkdownJ Java library
 *
 * @author Luis Majano
 */
component accessors=true singleton {

	// Emoji Support
	property name="emojiService" inject="EmojiService@cbemoji";

	/**
	 * The internal parser
	 */
	property name="parser";

	/**
	 * The internal renderer
	 */
	property name="renderer";

	/**
	 * Constructor
	 *
	 * @javaLoader        The javaloader class
	 * @javaLoader.inject loader@cbjavaloader
	 * @options           The module options
	 * @options.inject    coldbox:modulesettings:cbmarkdown
	 */
	function init( required javaloader, required struct options ){
		// store references
		variables.javaloader   = arguments.javaLoader;
		variables.StaticParser = javaloader.create( "com.vladsch.flexmark.parser.Parser" );
		variables.HtmlRenderer = javaloader.create( "com.vladsch.flexmark.html.HtmlRenderer" );

		var parserOptions        = createOptions( arguments.options );
		variables.parser         = StaticParser.builder( parserOptions ).build();
		variables.renderer       = HtmlRenderer.builder( parserOptions ).build();
		variables.htmlToMarkdown = javaLoader
			.create( "com.vladsch.flexmark.html2md.converter.FlexmarkHtmlConverter" )
			.builder( parserOptions )
			.build();

		return this;
	}

	/**
	 * Convert markdown to HTML
	 *
	 * @txt The markdown text to convert
	 */
	function toHTML( required txt ){
		var document = variables.parser.parse( trim( arguments.txt ) );
		return emojiService.emojify( trim( variables.renderer.render( document ) ) );
	}

	/**
	 * Convert HTML to Markdown
	 *
	 * @html The html to convert to markdown
	 */
	function toMarkdown( required html ){
		return variables.htmlToMarkdown.convert( trim( arguments.html ) );
	}

	/**
	 * Create a parser options object for the FlexMark parser.
	 *
	 * @options A struct of options for the parser.
	 *
	 * @return A parser options object.
	 */
	private function createOptions( required struct options ){
		var staticTableExtension = javaloader.create( "com.vladsch.flexmark.ext.tables.TablesExtension" );
		var anchorLinkExtension  = javaloader.create( "com.vladsch.flexmark.ext.anchorlink.AnchorLinkExtension" );

		var extensionsToLoad = [
			staticTableExtension.create(),
			javaloader
				.create( "com.vladsch.flexmark.ext.gfm.strikethrough.StrikethroughSubscriptExtension" )
				.create(),
			javaloader.create( "com.vladsch.flexmark.ext.gfm.tasklist.TaskListExtension" ).create(),
			javaloader.create( "com.vladsch.flexmark.ext.toc.TocExtension" ).create()
		];

		// autoLinkUrls
		if ( arguments.options.autoLinkUrls ) {
			extensionsToLoad.append(
				javaloader.create( "com.vladsch.flexmark.ext.autolink.AutolinkExtension" ).create()
			);
		}
		// AnchorLinks
		if ( arguments.options.anchorLinks ) {
			extensionsToLoad.append( anchorLinkExtension.create() );
		}
		// Youtube Transformer
		if ( arguments.options.enableYouTubeTransformer ) {
			extensionsToLoad.append(
				javaloader.create( "com.vladsch.flexmark.ext.youtube.embedded.YouTubeLinkExtension" ).create()
			);
		}

		return javaloader
			.create( "com.vladsch.flexmark.util.data.MutableDataSet" )
			.init()
			// Autolink + Anchor Link Options
			.set(
				variables.StaticParser.WWW_AUTO_LINK_ELEMENT,
				javacast( "boolean", arguments.options.autoLinkUrls )
			)
			.set( anchorLinkExtension.ANCHORLINKS_SET_ID, javacast( "boolean", arguments.options.anchorSetId ) )
			.set( anchorLinkExtension.ANCHORLINKS_SET_NAME, javacast( "boolean", arguments.options.achorSetName ) )
			.set(
				anchorLinkExtension.ANCHORLINKS_WRAP_TEXT,
				javacast( "boolean", arguments.options.anchorWrapText )
			)
			.set( anchorLinkExtension.ANCHORLINKS_ANCHOR_CLASS, arguments.options.anchorClass )
			.set( anchorLinkExtension.ANCHORLINKS_TEXT_PREFIX, arguments.options.anchorPrefix )
			.set( anchorLinkExtension.ANCHORLINKS_TEXT_SUFFIX, arguments.options.anchorSuffix )
			.set(
				variables.HtmlRenderer.CODE_STYLE_HTML_OPEN,
				javacast( "string", arguments.options.codeStyleHTMLOpen )
			)
			.set(
				variables.HtmlRenderer.CODE_STYLE_HTML_CLOSE,
				javacast( "string", arguments.options.codeStyleHTMLClose )
			)
			.set(
				variables.HtmlRenderer.FENCED_CODE_LANGUAGE_CLASS_PREFIX,
				javacast( "string", arguments.options.fencedCodeLanguageClassPrefix )
			)
			// Add Table Options
			.set(
				staticTableExtension.COLUMN_SPANS,
				javacast( "boolean", arguments.options.tableOptions.columnSpans )
			)
			.set(
				staticTableExtension.APPEND_MISSING_COLUMNS,
				javacast( "boolean", arguments.options.tableOptions.appendMissingColumns )
			)
			.set(
				staticTableExtension.DISCARD_EXTRA_COLUMNS,
				javacast( "boolean", arguments.options.tableOptions.discardExtraColumns )
			)
			.set( staticTableExtension.CLASS_NAME, arguments.options.tableOptions.className )
			.set(
				staticTableExtension.HEADER_SEPARATOR_COLUMN_MATCH,
				javacast( "boolean", arguments.options.tableOptions.headerSeparationColumnMatch )
			)
			// Load extensions
			.set( variables.StaticParser.EXTENSIONS, extensionsToLoad );
	}

}
