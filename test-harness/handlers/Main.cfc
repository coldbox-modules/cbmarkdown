﻿/**
 * Process Markdown
 */
component {

	property name="processor" inject="processor@cbmarkdown";

	// Index
	any function index( event, rc, prc ){
		prc.html = processor.toHTML( renderView( "main/markdown.md" ) );
		event.setView( "main/index" );
	}

}
