package org.osmf.vast.model
{
	import org.osmf.vast.parser.VAST2Parser;
	import org.osmf.vast.parser.VAST3Parser;
	
	public class VAST3Translator extends VASTDataObject
	{
		public var vastObjects:Array;
		
		public function VAST3Translator()
		{
			super(VASTDataObject.VERSION_3_0);
			vastObjects = new Array();
		}
	
		
		public function addVastTranslator(parser:VAST2Parser, placement:String=VAST2Translator.PLACEMENT_LINEAR):void
		{
			var translator:VAST2Translator = new VAST2Translator(parser, placement);
			vastObjects.push(translator);
		}
	}
}