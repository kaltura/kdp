/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.example.views
{
	import com.yahoo.example.events.SearchEvent;
	
	import fl.controls.Button;
	import fl.controls.TextInput;
	import fl.events.ComponentEvent;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 * Dispatched when the user interacts with the for to request a search.
	 */
	[Event(name="search",type="com.yahoo.example.events.SearchEvent")]
	
	public class SearchForm extends Sprite
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 */
		public function SearchForm()
		{
			super();
			
			this.queryField.setStyle("focusRectSkin", Shape);
			this.queryField.setStyle("textFormat", new TextFormat("Arial", 12, 0x000000));
			this.queryField.addEventListener(ComponentEvent.ENTER, queryFieldEnterHandler);
			this.queryField.drawNow(); 
			
			this.searchButton.buttonMode = true;
			this.searchButton.useHandCursor = true;
			this.searchButton.setStyle("textFormat", new TextFormat("Arial", 12, 0x000000, true));
			this.searchButton.setStyle("upSkin", "YahooButton_upSkin");
			this.searchButton.setStyle("overSkin", "YahooButton_overSkin");
			this.searchButton.setStyle("downSkin", "YahooButton_downSkin");
			this.searchButton.addEventListener(MouseEvent.CLICK, searchButtonClickHandler);
			this.searchButton.drawNow();
			
			//we have to call drawNow() because the size isn't reported
			//correctly until after drawing once. I'm guessing its because
			//the TextInput or Button doesn't resize the TextField (which
			//has a default size of 100 x 100
		}

	//--------------------------------------
	//  Properties
	//--------------------------------------
	
		/**
		 * @private
		 * The TextInput field for the search query.
		 */
		public var queryField:TextInput;
		
		/**
		 * @private
		 * The Button control to activate the search.
		 */
		public var searchButton:Button;
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
	
		/**
		 * @private
		 * Requests a search using the SearchEvent type.
		 */
		protected function requestSearch():void
		{
			//if no text has been entered, there's no use searching
			if(!this.queryField.text)
			{
				return;
			}
			
			var searchEvent:SearchEvent = new SearchEvent(SearchEvent.SEARCH, this.queryField.text);
			this.dispatchEvent(searchEvent);
		}
		
	//--------------------------------------
	//  Protected Event Handlers
	//--------------------------------------
	
		/**
		 * @private
		 * Request a search when the button is pressed.
		 */
		protected function searchButtonClickHandler(event:MouseEvent):void
		{
			this.requestSearch();
		}
		
		/**
		 * @private
		 * Request a search when the user presses the Enter key in the query field.
		 */
		protected function queryFieldEnterHandler(event:ComponentEvent):void
		{
			this.requestSearch();
		}
	}
}