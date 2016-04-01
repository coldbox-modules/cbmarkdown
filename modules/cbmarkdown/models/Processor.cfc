/**
* Ortus Markdown Module
* Copyright 2013 Ortus Solutions, Corp
* www.ortussolutions.com
* ---
* @author Luis Majano
* Convert markdown to HTML via the MarkdownJ Java library
*/
component accessors="true" singleton{

	/**
	* MarkdownJ processor
	*/
	property name="processor";
	/**
	* Java loader class
	*/
	property name="javaloader";

	/**
	* Constructor
	* @javaLoader The javaloader class
	* @javaLoader.inject loader@cbjavaloader
	*/
	function init( required javaLoader ){
		// store references
		variables.javaLoader = arguments.javaLoader;
		// Setup markdown processor
		variables.processor = arguments.javaLoader.create( "org.markdownj.MarkdownProcessor" ).init();
		return this;
	}

	/**
	* Convert markdown to HTML
	* @txt The markdown text to convert
	*/
	function toHTML( required txt ){
		return trim( variables.processor.markdown( trim( arguments.txt ) ) );
	}
	
}