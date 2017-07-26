/**
* Ortus Markdown Module
* Copyright 2013 Ortus Solutions, Corp
* www.ortussolutions.com
* ---
* Module Configuration
*/
component {

	// Module Properties
	this.title 				= "ColdBox Markdown Processor";
	this.author 			= "Ortus Solutions, Corp";
	this.webURL 			= "http://www.ortussolutions.com/products/codexwiki";
	this.description 		= "Markdown processor for ColdBox applications";
	this.version			= "@build.version@+@build.number@";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "cbmarkdown";
	// CF Mapping
	this.cfmapping			= "cbmarkdown";
	// Module Dependencies That Must Be Loaded First, use internal names or aliases
	this.dependencies		= [ "cbjavaloader" ];

	/**
	* Configure this module
	*/
	function configure(){
		settings = {
			tableOptions = {
				// Treat consecutive pipes at the end of a column as defining spanning column.
				columnSpans = true,
				// Whether table body columns should be at least the number or header columns.
				appendMissingColumns = true,
				// Whether to discard body columns that are beyond what is defined in the header
				discardExtraColumns = true,
				// Class name to use on tables
				className = "table",
				// When true only tables whose header lines contain the same number of columns as the separator line will be recognized
				headerSeparationColumnMatch = true
			}
		};
	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		// Class load FlexMark Processor
		controller.getWireBox()
			.getInstance( "loader@cbjavaloader" )
			.appendPaths( modulePath & "/models/lib" );
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){
	}

}