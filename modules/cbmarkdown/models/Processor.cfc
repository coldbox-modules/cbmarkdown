/**
* Ortus Markdown Module
* Copyright 2013 Ortus Solutions, Corp
* www.ortussolutions.com
* ---
* @author Luis Majano
* Convert markdown to HTML via the MarkdownJ Java library
*/
component singleton {

	/**
	* Constructor
	* @javaLoader The javaloader class
	* @javaLoader.inject loader@cbjavaloader
	*/
	function init( required javaLoader ){
		// store references
		variables.jl = arguments.javaLoader;
		variables.StaticParser = jl.create( "com.vladsch.flexmark.parser.Parser" );
		var options = createOptions();
		variables.parser = StaticParser.builder( options ).build();
		variables.renderer = jl.create( "com.vladsch.flexmark.html.HtmlRenderer" )
			.builder( options )
			.build();
		return this;
	}

	/**
	* Convert markdown to HTML
	* @txt The markdown text to convert
	*/
	function toHTML( required txt ){
		var document = variables.parser.parse( trim( arguments.txt ) );
		return trim( variables.renderer.render( document ) );
	}

	private function createOptions() {
		var TE = jl.create( "com.vladsch.flexmark.ext.tables.TablesExtension" );
		return jl.create( "com.vladsch.flexmark.util.options.MutableDataSet" )
			.init()
			.set( TE.COLUMN_SPANS, false )
        	.set( TE.APPEND_MISSING_COLUMNS, true )
        	.set( TE.DISCARD_EXTRA_COLUMNS, true )
        	.set( TE.CLASS_NAME, "table" )
        	.set( TE.HEADER_SEPARATOR_COLUMN_MATCH, true )
        	.set( variables.StaticParser.EXTENSIONS, [
        		TE.create()
        	] );
	}

}