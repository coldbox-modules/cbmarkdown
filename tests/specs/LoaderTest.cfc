/**
* My BDD Test
*/
component extends="coldbox.system.testing.BaseTestCase" appMapping="/root"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		super.beforeAll();
	}

	// executes after all suites+specs in the run() method
	function afterAll(){
		super.afterAll();
	}

/*********************************** BDD SUITES ***********************************/

	function run(){

		// all your suites go here.
		describe( "Markdown Module", function(){

			beforeEach(function( currentSpec ){
				setup();
			});

			it( "should register processor", function(){
				var processor = getProcessor();
				expect(	processor ).toBeComponent();
			});

			it( "should process markdown", function(){
				var event = execute( event="main.index" );
				var prc = event.getPrivateCollection();
				expect(	prc.html )
					.toInclude( "Introduction" );
			});

		});

	}

	private function getProcessor(){
		return getWireBox().getInstance( "processor@cbmarkdown" );
	}

}