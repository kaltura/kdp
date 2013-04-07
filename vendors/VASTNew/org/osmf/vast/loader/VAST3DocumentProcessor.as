package org.osmf.vast.loader
{
	import flash.events.Event;
	
	import org.osmf.utils.HTTPLoader;
	import org.osmf.vast.model.VAST2Translator;
	import org.osmf.vast.model.VAST3Translator;
	import org.osmf.vast.parser.VAST2Parser;
	import org.osmf.vast.parser.VAST3Parser;
	import org.osmf.vast.parser.base.VAST2TrackingData;
	import org.osmf.vast.parser.base.events.ParserErrorEvent;
	import org.osmf.vast.parser.base.events.ParserEvent;
	
	public class VAST3DocumentProcessor extends VAST2DocumentProcessor
	{
		private var _parsedCounter:int;
		private var _errorCounter:int;
		private var _wrappedCounter:int;
		
		private var _translator:VAST3Translator;
		
		public function VAST3DocumentProcessor(maxNumWrapperRedirects:Number, httpLoader:HTTPLoader)
		{
			super(maxNumWrapperRedirects, httpLoader);
		}
		
		/**
		 *Takes a VAST document, converts it to XML, then submits it to the parser for parsing.
		 * 
		 * @param documentContents The VAST document that holds the raw VAST information
		 * @trackingData A data transfer object for tracking data.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		override public function processVASTDocument(documentContents:String, trackingData:VAST2TrackingData = null):void
		{
			var documentXML:XML = null;
			try
			{
				documentXML = new XML(documentContents);
			}
			catch (error:TypeError)
			{
				trace ("processing vast3 failed");
			}
			
			if (documentXML != null)
			{
				parser = new VAST3Parser(trackingData);
				parser.addEventListener(ParserEvent.XML_PARSED, onXMLParsed);
				parser.addEventListener(ParserErrorEvent.XML_ERROR, onXMLParseError);
				this.addEventListener(VASTDocumentProcessedEvent.PROCESSED, onWrappedProcessed, false, 1);
				this.addEventListener(VASTDocumentProcessedEvent.PROCESSING_FAILED, onWrappedFailed);
				_parsedCounter = 0;
				_errorCounter = 0;
				_wrappedCounter = 0;
				_translator = new VAST3Translator();
				parser.parse(documentXML);
			}
		}
		
		private function onXMLParsed(event:ParserEvent):void
		{
			
			var curParser:VAST2Parser = event.uifVars as VAST2Parser;
			if(curParser.isVASTXMLWRAPPER)
			{
				CONFIG::LOGGING
				{
					logger.debug("[VAST] " + curParser.adTagTitle + " is a VAST wrapper tag.")
				}
				loadVASTWrapper(curParser);
			}
			else
			{
				_parsedCounter++;
				_translator.addVastTranslator(curParser);
			}
			

			checkForComplete();
			
			
		}
		
		private function onWrappedProcessed(e:VASTDocumentProcessedEvent):void{
			_wrappedCounter++;
			_translator.vastObjects.push(e.vastDocument);
			e.stopImmediatePropagation();
			checkForComplete();
		}
		
		private function onWrappedFailed(e:Event):void{
			_errorCounter++;
			checkForComplete();
		}
		
		private function onXMLParseError(event:ParserErrorEvent):void
		{
			CONFIG::LOGGING
			{
				logger.debug("[VAST] Error Parsing Tag: " + event.description);
			}
			
			_errorCounter++;
			checkForComplete();
		}
		
		private function checkForComplete():void
		{
			if ((parser as VAST3Parser).totalAds == (_parsedCounter + _errorCounter + _wrappedCounter))
			{
				parser.removeEventListener(ParserEvent.XML_PARSED, onXMLParsed);
				parser.removeEventListener(ParserErrorEvent.XML_ERROR, onXMLParseError);
				this.removeEventListener(VASTDocumentProcessedEvent.PROCESSED, onWrappedProcessed);
				this.removeEventListener(VASTDocumentProcessedEvent.PROCESSING_FAILED, onWrappedFailed);
				
				//at least one ad was loaded successfully
				if (_parsedCounter > 0 || _wrappedCounter > 0)
					dispatchEvent(new VASTDocumentProcessedEvent(VASTDocumentProcessedEvent.PROCESSED, _translator));
				else
					dispatchEvent(new VASTDocumentProcessedEvent(VASTDocumentProcessedEvent.PROCESSING_FAILED));	
			}
		}
		
	}
}