/*
LoaderObject.as

Universal Instream Framework
Copyright (c) 2006-2009, Eyewonder, Inc
All Rights Reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.
 * Neither the name of Eyewonder, Inc nor the
 names of contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY Eyewonder, Inc ''AS IS'' AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Eyewonder, Inc BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

This file should be accompanied with supporting documentation and source code.
If you believe you are missing files or information, please 
contact Eyewonder, Inc (http://www.eyewonder.com)



Description
-----------

Creates a object that can be gived to UIF and converted into an ad.
This class is an example of what to write.

*/
package com.eyewonder.instream.parser.loaderObject
{
	import flash.xml.XMLDocument;
	
	
	public dynamic class LoaderObject extends XMLDocument
	{
		
		public var VideoAdServingTemplate:XML;
		
		private static const UTF_ENCODING:String = "<?xml version='1.0' encoding='utf-8'?>";
		
		public function LoaderObject( ){}

		public function createObject():XML
		{
			
			//create object root node
			VideoAdServingTemplate = new XML("<VideoAdServingTemplate></VideoAdServingTemplate>");
			
			//define all child nodes and attributes
			VideoAdServingTemplate.Ad = new XML();
			VideoAdServingTemplate.Ad.@id = "EWAD";
			VideoAdServingTemplate.Ad.InLine = new XML();
			VideoAdServingTemplate.Ad.InLine.AdSystem = new XML("EW");
			VideoAdServingTemplate.Ad.InLine.AdTitle = new XML("SAMPLE");
			VideoAdServingTemplate.Ad.InLine.Impression = new XML();
			VideoAdServingTemplate.Ad.InLine.Impression.URL = new XML("http://cdn1.eyewonder.com/200125/EW_IMPRESSION?ewadid=0&eid=000000&ewbust=[timestamp]");
			VideoAdServingTemplate.Ad.InLine.Impression.URL.@id = "myadserver";
			VideoAdServingTemplate.Ad.InLine.TrackingEvents = new XML();
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[0] = new XMLList("<Tracking></Tracking>");
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[0].@event = "start";
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[0].URL = new XML("http://cdn1.eyewonder.com/200125/EWTRACK_NEW_V?ewadid=0&ewbust=[timestamp]&eid=000000&file=video.flv&bw=&vlen=14.7&per=0&time=0&adtime=");
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[0].URL.@id = "EWADSERVER";
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[1] = new XMLList("<Tracking></Tracking>");
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[1].@event = "midpoint";
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[1].URL = new XML("http://cdn1.eyewonder.com/200125/EWTRACK_NEW_V?ewadid=0&ewbust=[timestamp]&eid=000000&file=video.flv&bw=&vlen=14.7&per=25&time=3.675&adtime=");
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[1].URL.@id = "EWADSERVER";
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[2] = new XMLList("<Tracking></Tracking>");
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[2].@event = "firstQuartile";
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[2].URL = new XML("http://cdn1.eyewonder.com/200125/EWTRACK_NEW_V?ewadid=0&ewbust=[timestamp]&eid=000000&file=video.flv&bw=&vlen=14.7&per=50&time=7.35&adtime=");
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[2].URL.@id = "EWADSERVER";
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[3] = new XMLList("<Tracking></Tracking>");
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[3].@event = "thirdQuartile";
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[3].URL = new XML("http://cdn1.eyewonder.com/200125/EWTRACK_NEW_V?ewadid=0&ewbust=[timestamp]&eid=000000&file=video.flv&bw=&vlen=14.7&per=75&time=11.075&adtime=");
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[3].URL.@id = "EWADSERVER";
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[4] = new XMLList("<Tracking></Tracking>");
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[4].@event = "complete";
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[4].URL = new XML("http://cdn1.eyewonder.com/200125/EWTRACK_NEW_V?ewadid=0&ewbust=[timestamp]&eid=000000&file=video.flv&bw=&vlen=14.7&per=100&time=14.7&adtime=");
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[4].URL.@id = "EWADSERVER";
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[5] = new XMLList("<Tracking></Tracking>");
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[5].@event = "mute";
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[5].URL = new XML("http://cdn1.eyewonder.com/200125/EWTRACK_NEW_I?ewadid=0&ewbust=[timestamp]&eid=00000&file=null&pnl=MainBanner&type=0&itr=Mute-M&num=&time=&diff=");
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[5].URL.@id = "EWADSERVER";
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[6] = new XMLList("<Tracking></Tracking>");
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[6].@event = "pause";
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[6].URL = new XML("http://cdn1.eyewonder.com/200125/EWTRACK_NEW_I?ewadid=0&ewbust=[timestamp]&eid=00000&file=null&pnl=MainBanner&type=0&itr=Pause-M&num=&time=&diff=");
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[6].URL.@id = "EWADSERVER";
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[7] = new XMLList("<Tracking></Tracking>");
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[7].@event = "replay";
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[7].URL = new XML("http://cdn1.eyewonder.com/200125/EWTRACK_NEW_I?ewadid=0&ewbust=[timestamp]&eid=00000&file=null&pnl=MainBanner&type=0&itr=Replay-M&num=&time=&diff=");
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[7].URL.@id = "EWADSERVER";
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[8] = new XMLList("<Tracking></Tracking>");
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[8].@event = "fullscreen";
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[8].URL = new XML("http://cdn1.eyewonder.com/200125/EWTRACK_NEW_I?ewadid=0&ewbust=[timestamp]&eid=00000&file=null&pnl=MainBanner&type=0&itr=Fullscreen-M&num=&time=&diff=");
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[8].URL.@id = "EWADSERVER";
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[9] = new XMLList("<Tracking></Tracking>");
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[9].@event = "stop";
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[9].URL = new XML("http://cdn1.eyewonder.com/200125/EWTRACK_NEW_I?ewadid=0&ewbust=[timestamp]&eid=00000&file=null&pnl=MainBanner&type=0&itr=Stop-M&num=&time=&diff=");
			VideoAdServingTemplate.Ad.InLine.TrackingEvents.Tracking[9].URL.@id = "EWADSERVER";
			VideoAdServingTemplate.Ad.InLine.Video = new XML();
			VideoAdServingTemplate.Ad.InLine.Video.Duration = new XML("00:00:14.7");
			VideoAdServingTemplate.Ad.InLine.Video.AdID = new XML("0000000000");
			VideoAdServingTemplate.Ad.InLine.Video.VideoClicks = new XML();
			VideoAdServingTemplate.Ad.InLine.Video.VideoClicks.ClickThrough = new XML();
			VideoAdServingTemplate.Ad.InLine.Video.VideoClicks.ClickThrough.URL = new XML("http://www.eyewonderlabs.com/ct2.cfm?ewbust=[timestamp]&eid=0000000&file=null&pnl=MainBanner&type=0&name=Clickthru-clickTag1&num=&time=&diff=15522&click=http%3A%2F%2Fwww%2Eeyewonder%2Ecom"); 
			VideoAdServingTemplate.Ad.InLine.Video.VideoClicks.ClickThrough.URL.@id = "myadsever";
			VideoAdServingTemplate.Ad.InLine.Video.MediaFiles = new XML();
			VideoAdServingTemplate.Ad.InLine.Video.MediaFiles.MediaFile[0] = new XMLList("<MediaFile></MediaFile>");
			VideoAdServingTemplate.Ad.InLine.Video.MediaFiles.MediaFile[0].@delivery = "streaming";
			VideoAdServingTemplate.Ad.InLine.Video.MediaFiles.MediaFile[0].@bitrate = "56";
			VideoAdServingTemplate.Ad.InLine.Video.MediaFiles.MediaFile[0].URL = new XML("rtmp://fms2.eyewonder.speedera.net/ondemand/fms2.eyewonder/video/12106/fl8__EW_placeholder_01- 320x240-56.flv");
			VideoAdServingTemplate.Ad.InLine.Video.MediaFiles.MediaFile[1] = new XMLList("<MediaFile></MediaFile>");
			VideoAdServingTemplate.Ad.InLine.Video.MediaFiles.MediaFile[1].@delivery = "streaming";
			VideoAdServingTemplate.Ad.InLine.Video.MediaFiles.MediaFile[1].@bitrate = "90";
			VideoAdServingTemplate.Ad.InLine.Video.MediaFiles.MediaFile[1].URL = new XML("rtmp://fms2.eyewonder.speedera.net/ondemand/fms2.eyewonder/video/12106/fl8__EW_placeholder_01- 320x240-90.flv");
			VideoAdServingTemplate.Ad.InLine.Video.MediaFiles.MediaFile[2] = new XMLList("<MediaFile></MediaFile>");
			VideoAdServingTemplate.Ad.InLine.Video.MediaFiles.MediaFile[2].@delivery = "streaming";
			VideoAdServingTemplate.Ad.InLine.Video.MediaFiles.MediaFile[2].@bitrate = "135";
			VideoAdServingTemplate.Ad.InLine.Video.MediaFiles.MediaFile[2].URL = new XML("rtmp://fms2.eyewonder.speedera.net/ondemand/fms2.eyewonder/video/12106/fl8__EW_placeholder_01- 320x240-135.flv");
			VideoAdServingTemplate.Ad.InLine.Video.MediaFiles.MediaFile[3] = new XMLList("<MediaFile></MediaFile>");
			VideoAdServingTemplate.Ad.InLine.Video.MediaFiles.MediaFile[3].@delivery = "streaming";
			VideoAdServingTemplate.Ad.InLine.Video.MediaFiles.MediaFile[3].@bitrate = "300";
			VideoAdServingTemplate.Ad.InLine.Video.MediaFiles.MediaFile[3].URL = new XML("rtmp://fms2.eyewonder.speedera.net/ondemand/fms2.eyewonder/video/12106/fl8__EW_placeholder_01- 320x240-300.flv");
			VideoAdServingTemplate.Ad.InLine.Video.MediaFiles.MediaFile[4] = new XMLList("<MediaFile></MediaFile>");
			VideoAdServingTemplate.Ad.InLine.Video.MediaFiles.MediaFile[4].@delivery = "streaming";
			VideoAdServingTemplate.Ad.InLine.Video.MediaFiles.MediaFile[4].@bitrate = "450";
			VideoAdServingTemplate.Ad.InLine.Video.MediaFiles.MediaFile[4].URL = new XML("rtmp://fms2.eyewonder.speedera.net/ondemand/fms2.eyewonder/video/12106/fl8__EW_placeholder_01- 320x240-450.flv");
			VideoAdServingTemplate.Ad.InLine.Video.MediaFiles.MediaFile[5] = new XMLList("<MediaFile></MediaFile>");
			VideoAdServingTemplate.Ad.InLine.Video.MediaFiles.MediaFile[5].@delivery = "streaming";
			VideoAdServingTemplate.Ad.InLine.Video.MediaFiles.MediaFile[5].@bitrate = "600";
			VideoAdServingTemplate.Ad.InLine.Video.MediaFiles.MediaFile[5].URL = new XML("rtmp://fms2.eyewonder.speedera.net/ondemand/fms2.eyewonder/video/12106/fl8__EW_placeholder_01- 320x240-600.flv");
			
			var xmlstring:String = VideoAdServingTemplate.toXMLString();
           
            
			return new XML(xmlstring);
			
						
		}
				
	}
	
	
}