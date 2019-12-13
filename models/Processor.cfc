/**
 * Ortus Markdown Module
 * Copyright 2013 Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * @author Luis Majano
 * Convert markdown to HTML via the MarkdownJ Java library
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
	 * @javaLoader The javaloader class
	 * @javaLoader.inject loader@cbjavaloader
	 * @options The module options
	 * @options.inject coldbox:modulesettings:cbmarkdown
	 */
	function init( required javaloader, required struct options ){
		// store references
		variables.javaloader   = arguments.javaLoader;
		variables.staticParser = javaloader.create( "com.vladsch.flexmark.parser.Parser" );

		// Build out builder with options
		var parserOptions  = createOptions( arguments.options );
		variables.parser   = staticParser.builder( parserOptions ).build();
		variables.renderer = javaloader
			.create( "com.vladsch.flexmark.html.HtmlRenderer" )
			.builder( parserOptions )
			.build();
		return this;
	}

	/**
	 * Convert markdown to HTML
	 * @txt The markdown text to convert
	 */
	function toHTML( required txt ){
		var document = variables.parser.parse( trim( arguments.txt ) );
		return emojiService.emojify( trim( variables.renderer.render( document ) ) );
	}

	/**
	 * Create a parser options object for the FlexMark parser.
	 *
	 * @options A struct of options for the parser.
	 *
	 * @return  A parser options object.
	 */
	private function createOptions( required struct options ){
		structAppend( arguments.options, defaultOptions(), false );

		var staticTableExtension = javaloader.create( "com.vladsch.flexmark.ext.tables.TablesExtension" );
		return javaloader
			.create( "com.vladsch.flexmark.util.data.MutableDataSet" )
			.init()
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
			.set( variables.staticParser.EXTENSIONS, [ staticTableExtension.create() ] );
	}

	/**
	 * Return the default parser options to merge with the user's options.
	 *
	 * @return The default parser options struct.
	 */
	private struct function defaultOptions(){
		return {
			tableOptions : {
				// Treat consecutive pipes at the end of a column as defining spanning column.
				columnSpans                 : true,
				// Whether table body columns should be at least the number or header columns.
				appendMissingColumns        : true,
				// Whether to discard body columns that are beyond what is defined in the header
				discardExtraColumns         : true,
				// Class name to use on tables
				className                   : "table",
				// When true only tables whose header lines contain the same number of columns as the separator line will be recognized
				headerSeparationColumnMatch : true
			}
		};
	}

}
