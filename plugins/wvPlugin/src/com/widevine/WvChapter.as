/**
 WvChapter
 version 1.1
 03/08/2010
**/
 
package com.widevine
{
	import flash.errors.*;
	import flash.utils.ByteArray;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	
	public class WvChapter
	{
		private var myBitmap:Bitmap;
		private var myIndex:Number;
		private var myName:String;
		private var myChapterNum:int;
		private var myLoader:Loader;
		public var  myByteArray:ByteArray;
		
		///////////////////////////////////////////////////////////////////////////
		public function WvChapter(chapterNum:int):void
		{
			myChapterNum 	= chapterNum;
			myLoader 		= new Loader();
			myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			myByteArray 	= new ByteArray();
		}
		///////////////////////////////////////////////////////////////////////////
		// Read chapterData from the socket. 
		// Parameters:
		//		[in]	socket to read data from
		// Returns:
		//		false if no chapterData is available
		//
		public function loadData(src:String):Boolean
		{
			myName 	= getStringFromMsg("Title=", src);
			if (myName == null) {
				return false;
			}
			myIndex = Number(getStringFromMsg("TimeIndex=", src));
			if (myName.length == 0) {
				myName = "Chapter " + (myChapterNum + 1);
			}

			//trace("Chapter#" + myChapterNum + ", Title:" + myName + ", Index:" + myIndex);
			return true;
		}
		///////////////////////////////////////////////////////////////////////////
		public function loadImage():Boolean
		{
			try {
				myLoader.loadBytes(myByteArray);
			}
			catch (e:Error) {
				//trace("WVChapter::loadImage() error:" + e.message);
				return false;
			}
			return true;
		}
		///////////////////////////////////////////////////////////////////////////
		private function loaderCompleteHandler(event:Event):void
		{
			var loader:Loader = (event.target as LoaderInfo).loader;
			myBitmap = Bitmap(loader.content);
			//trace("loaded " + myName + " image. Width:" + myBitmap.width + ", Height:" + myBitmap.height
			//	  			+ ", bytes:" + loader.contentLoaderInfo.bytesLoaded);
		}		
		///////////////////////////////////////////////////////////////////////////
		// Paramters:
		//		[out]	image as a bitmap  
		//	Returns:	
		//		0
		//
		public function getBitmapData():BitmapData
		{
			return myBitmap.bitmapData;
		}
		public function getBitmap():Bitmap
		{
			return myBitmap;
		}
		///////////////////////////////////////////////////////////////////////////
		public function getIndex():Number
		{
			return myIndex/1000000;
		}
		///////////////////////////////////////////////////////////////////////////
		public function getName():String
		{
			return myName;
		}	
		///////////////////////////////////////////////////////////////////////////
		public function hasBitmap():Boolean
		{
			if (myBitmap == null) {
				return false;
			}
			return true;
		}	
		///////////////////////////////////////////////////////////////////////////
		private function getStringFromMsg(key:String, msg:String):String
		{
			var loc1:int = msg.indexOf(key);
			if (loc1 == -1) {
				//trace("Did not find \"" + key + "\" in:" + msg);
				return null;
			}
			loc1 += key.length; 
			// find <CR>
			var loc2:int = msg.indexOf("\n", loc1);
			if (loc2 == -1) {
				//trace("Did not find <CR> starting in:" + msg.substr(loc1));
				return msg.substr(loc1);
			}
			return msg.substr(loc1, loc2-loc1);
		}
		///////////////////////////////////////////////////////////////////////////
		public function getNumber():int 
		{
			return myChapterNum;
		}
		///////////////////////////////////////////////////////////////////////////
		public function close():void 
		{
			myBitmap = null;
			myByteArray = null;
			myLoader = null;
		}
	} // class
}  // package
