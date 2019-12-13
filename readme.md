[![Build Status](https://travis-ci.org/coldbox-modules/cbmarkdown.svg?branch=development)](https://travis-ci.org/coldbox-modules/cbmarkdown)

# Welcome to the CBMarkdown Project

This module will give you markdown processing capabilities via the flexmark-java project: https://github.com/vsch/flexmark-java and full emoji support :rocket:

## License

Apache License, Version 2.0.

## Important Links

- https://github.com/coldbox-modules/cbmarkdown
- http://forgebox.io/view/cbmarkdown
- https://github.com/vsch/flexmark-java

## System Requirements

- Lucee 5+
- ColdFusion 2016+

## Instructions

Just use the CommandBox to install or drop into your **modules** folder:

`box install cbmarkdown`

## Models

The module registers the following mapping in WireBox: `Processor@cbmarkdown`. Which is the class you will use to process markdown into HTML.  There is one simple function to call on the processor:

* `toHTML( required txt )` - Convert markdown text to HTML.

## Options

A subset of the flexmark options are supported.  These can be configured in your module settings in your `config/Coldbox.cfc` via the `modulesettings` struct.

```
moduleSettings = {
	cbmarkdown = {
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
	}
};
```

********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************

#### HONOR GOES TO GOD ABOVE ALL

Because of His grace, this project exists. If you don't like this, then don't read it, its not for you.

>"Therefore being justified by faith, we have peace with God through our Lord Jesus Christ:
By whom also we have access by faith into this grace wherein we stand, and rejoice in hope of the glory of God.
And not only so, but we glory in tribulations also: knowing that tribulation worketh patience;
And patience, experience; and experience, hope:
And hope maketh not ashamed; because the love of God is shed abroad in our hearts by the 
Holy Ghost which is given unto us. ." Romans 5:5

### THE DAILY BREAD

> "I am the way, and the truth, and the life; no one comes to the Father, but by me (JESUS)" Jn 14:1-12
