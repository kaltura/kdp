package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.type.AdsNotificationTypes;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.vo.*;
	import com.kaltura.kdpfl.view.media.KMediaPlayerMediator;
	import com.kaltura.types.KalturaAdType;
	import com.kaltura.vo.KalturaAdCuePoint;
	import com.kaltura.vo.KalturaCuePoint;
	import com.kaltura.vo.KalturaMediaEntry;
	import com.kaltura.vo.KalturaPlayableEntry;
	
	import org.osmf.media.URLResource;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class NielsenMediator extends Mediator
	{
		private var _lastState:String = '';
		private var _lastStateMedia:String = '';
		private var _mediaInfo:String = '';
		private var _playheadPosition:Number = 0;
		private var _intervalSentPos:Number = 0;
		private var _duration:Number = 0;
		private var _media:KalturaMediaEntry;
		private var _seeking:Boolean = false;
		private var _seekStartEnd:Number = 0;
		private var _cuePoints:Array;
		private var _sendPos:Number = 0;
		private var _adPlayhead:Number = 0;
		private var _seg:Number = 1;
		public var _dynamicClass:nielsenCombinedPluginCode;
		
		//ads variables
		private var _lastStateAds:String = '';
		private var _mediaInfoAds:String = '';
		private var _playheadPositionAds:Number = 0;
		private var _intervalSentPosAds:Number = 0;
		private var _durationAds:Number = 0;
		private var _adUrl : String = '';
		private var _adType:String = '';
		
		private var _lastSegmentInfoSent:int;
		private var _mediaProxy:MediaProxy;
		private var _sequenceProxy:SequenceProxy;
		
		public var contentUrl:String;
		
		public function NielsenMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
			_mediaProxy = facade.retrieveProxy(MediaProxy.NAME) as MediaProxy;
			_sequenceProxy = facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
		}
		
		override public function listNotificationInterests():Array
		{
			var notificationsArray:Array =  [
				NotificationType.HAS_OPENED_FULL_SCREEN,
				NotificationType.HAS_CLOSED_FULL_SCREEN,
				NotificationType.PLAYER_PLAYED,
				NotificationType.MEDIA_READY,
				NotificationType.PLAYER_SEEK_START,
				NotificationType.PLAYER_SEEK_END,
				NotificationType.PLAYER_PAUSED,
				NotificationType.PLAYER_PLAY_END,
				NotificationType.CHANGE_MEDIA,
				NotificationType.PLAYER_UPDATE_PLAYHEAD,
				NotificationType.DO_REPLAY,
				NotificationType.DO_SEEK,
				NotificationType.DURATION_CHANGE,
				NotificationType.SEQUENCE_SKIP_NEXT,
				AdsNotificationTypes.AD_START,
				AdsNotificationTypes.AD_CLICK,
				AdsNotificationTypes.AD_END,
			];
			
			return notificationsArray;
		}
		
		override public function handleNotification(note:INotification):void
		{
			trace('note.getName() =kg= '+note.getName());
			var curTime:Number = (facade.retrieveMediator(KMediaPlayerMediator.NAME) as KMediaPlayerMediator).player.currentTime;
			if (!_sequenceProxy.vo.isInSequence && this._cuePoints && this._cuePoints.length && this._seg > 1)
			{
				curTime -= this._cuePoints[this._seg-2];
			}
			var currentTime:String = curTime.toFixed(2);
			
			if(note.getName() == this._lastState)
				return;
			switch(note.getName())
			{
				case NotificationType.HAS_OPENED_FULL_SCREEN:
					ggCom.getInstance().PM(10,1);
					break;
				case NotificationType.HAS_CLOSED_FULL_SCREEN:
					ggCom.getInstance().PM(11,0);
					break;
				case NotificationType.PLAYER_PLAY_END:
						//FIx issue where sometimes player became uninitialized
						// and current time was 0
						var timeToSend:String = (_media.msDuration / 1000).toFixed(2);
						if(_lastStateMedia != 'unloaded')
						{
							ggCom.getInstance().PM(7, timeToSend);
							_lastStateMedia = 'unloaded';
						}
						ggCom.getInstance().PM(4, timeToSend, "content");
						_lastState = 'playerPlayEnd';
					break;
				case NotificationType.PLAYER_PAUSED:
					if(_lastState == 'playerPlayed')
					{
						ggCom.getInstance().PM(6, currentTime);
						_lastState = 'playerPaused';
					}
					break;
				case NotificationType.PLAYER_UPDATE_PLAYHEAD:
					if (_sequenceProxy.vo.isInSequence)
						_adPlayhead = _playheadPosition;
					else {
						_playheadPosition = note.getBody() as Number;
						_playheadPosition = Number(_playheadPosition.toFixed(2));
					}
					this._sendPos = _playheadPosition;
					//_adPlayhead = this._sendPos;
					if(this._seg > 1 && this._cuePoints && this._cuePoints.length)
						this._sendPos = Math.round((_playheadPosition - this._cuePoints[this._seg-2]));
					if (this._dynamicClass.updateInterval < (_playheadPosition - _intervalSentPos))
					{
						_intervalSentPos = _playheadPosition;
						ggCom.getInstance().PM(49,_sendPos);
					}
					trace("_playheadPosition == "+_playheadPosition);
					break;
				case NotificationType.PLAYER_PLAYED:
					if (_lastState != 'playerPlayed')
					{
						if(_lastStateAds == 'adStart')
						{
							_lastStateAds = 'adPlay';
							var adInfo:String = getAdInfoFromMetadata();
							ggCom.getInstance().PM(15, _adUrl, _adType, adInfo, this.getSegmentFromCuePoints());
							
						}
						else if (!_sequenceProxy.vo.isInSequence)
						{
							if (getSegmentFromCuePoints() != _lastSegmentInfoSent)
							{
								ggCom.getInstance().PM(15, contentUrl ? contentUrl : (_mediaProxy.vo.resource as URLResource).url, 'content', this.getVideoInfoFromMetadata(), _seg);
								_lastSegmentInfoSent = _seg;
								_lastStateMedia = 'mediaInfoSent';
								
							}
							else if (_lastState == "playerPaused")
							{
								ggCom.getInstance().PM(5, currentTime);		
							}
						}
					}
					_lastState = 'playerPlayed';
					break; 
				case NotificationType.MEDIA_READY:
					_mediaInfo = '';
					_media = (facade.retrieveProxy("mediaProxy"))["vo"].entry;
					var l_media:MediaVO = (facade.retrieveProxy("mediaProxy"))["vo"];
					_cuePoints = []; 
					for (var ii:String in l_media.entryCuePoints)
					{
						//ignore pre/post rolls
						if (ii== '0' || ii==_media.msDuration.toString())
							continue;
						
						for (var j:int = 0; j< l_media.entryCuePoints[ii].length; j++) 
						{
							//will count the intime only if at least one of the cue points in this intime
							//is a video
							var cp:KalturaCuePoint = l_media.entryCuePoints[ii][j] as KalturaCuePoint;
							if (cp && (cp is KalturaAdCuePoint) && ((cp as KalturaAdCuePoint).adType==KalturaAdType.VIDEO))
							{
								//cue points value is in milliseconds
								_cuePoints.push(Number(ii) / 1000);
								break;
							}
						}
						
					}
					_cuePoints.sort(16);
					trace("_cuePoints == "+_cuePoints);
					_mediaInfo = getVideoInfoFromMetadata();
					//ggCom.getInstance().PM(3, (_mediaProxy.vo.resource as URLResource).url, 'content', _mediaInfo, this.getSegmentFromCuePoints());
					_lastStateMedia = 'mediaReady';
					_lastSegmentInfoSent = 0;
					break;
				case NotificationType.PLAYER_SEEK_START:
					this._seeking = true;
					break;
				case NotificationType.PLAYER_SEEK_END:
					this._seeking = false;
					break;								
				case NotificationType.DO_REPLAY:
					//ggCom.getInstance().PM(3, (_mediaProxy.vo.resource as URLResource).url, 'content', this.getVideoInfoFromMetadata(), this.getSegmentFromCuePoints());
					_lastStateMedia = 'mediaReady';
					this._playheadPosition = 0;
					_lastSegmentInfoSent = 0;
					break;
				case NotificationType.DO_SEEK:
					var l_pos:Number = note.getBody() as Number;
					l_pos = Number(l_pos.toFixed(2));
					this._playheadPosition = l_pos;
					if(this._seg > 1)
						l_pos = l_pos - this._cuePoints[this._seg-1];
					ggCom.getInstance().PM(8,currentTime, l_pos);
					break;
				case AdsNotificationTypes.AD_START:
					var noteBodyAS:Object = note.getBody();
					_adType = note.getBody().timeSlot + "roll";
					if(_adType != "mainroll")
					{
						if(_lastStateMedia == 'mediaInfoSent')
						{
							trace("kg == this is fired");
							ggCom.getInstance().PM(7, _sendPos);
							ggCom.getInstance().PM(4, _sendPos, "content");
							_lastStateMedia = 'unloaded';
						}
						trace("_adType =KG= "+_adType);
						trace("this.getAdInfoFromMetadata() == ");
						//var adInfo:String = this.getAdInfoFromMetadata();
						//ggCom.getInstance().PM(3, _adUrl, _adType, adInfo , this.getSegmentFromCuePoints());
						_lastStateAds = 'adStart';
						this._adPlayhead = 0;
					};
					_lastState = AdsNotificationTypes.AD_START;
					break;
				case AdsNotificationTypes.AD_CLICK:
					if(_lastStateAds == 'adPlay')
						ggCom.getInstance( ).PM( 16, currentTime);
					break;
				/*case NotificationType.PLAYBACK_COMPLETE:
					this._adPlayhead = _durationAds;
					this.sendAdStop();
					break;*/
				case NotificationType.SEQUENCE_SKIP_NEXT:
					this.sendAdStop();
					break;
				case AdsNotificationTypes.AD_END:
					_adPlayhead = this._durationAds;
					if(_lastStateAds == 'adPlay')
						ggCom.getInstance().PM(7, _adPlayhead);
					ggCom.getInstance().PM(4, _adPlayhead, _adType);
					_lastStateAds = 'adEnd';
					var noteBody:Object = note.getBody();
					for(var i:String in noteBody)
						trace(i +" =adEnd note.body= "+noteBody[i]);
					if(_adType == "preroll" && (_lastStateMedia == 'unloaded' || _lastStateMedia == 'mediaReady'))
					{
						ggCom.getInstance().PM(15, contentUrl ? contentUrl : (_mediaProxy.vo.resource as URLResource).url, 'content', this.getVideoInfoFromMetadata(), this.getSegmentFromCuePoints());
						_lastStateMedia = 'mediaInfoSent';
						_lastState = "playerPlayed";
						_lastSegmentInfoSent = _seg;
					//	_firstVideoPlay = true;
					}
					break;
				case AdsNotificationTypes.FIRST_QUARTILE_OF_AD:
					this._adPlayhead = Math.round(_durationAds * .25);
					break;
				case AdsNotificationTypes.MID_OF_AD:
					this._adPlayhead = Math.round(_durationAds * .5);
					break;
				case AdsNotificationTypes.THIRD_QUARTILE_OF_AD:
					this._adPlayhead = Math.round(_durationAds * .75);
					break;
				case NotificationType.DURATION_CHANGE:
					var noteBodyDC:Object = note.getBody();
					//if(_lastState == AdsNotificationTypes.AD_START)
						//_durationAds = noteBodyDC.newValue;
					_lastState = 'durationChange';
					trace("noteBodyDC =="+noteBodyDC.newValue);
					break;
			}
		}
		
		private function sendAdStop():void
		{
			trace("sendAdStop _adPlayhead == "+_adPlayhead);
			if(_lastStateAds == 'adPlay')
				ggCom.getInstance().PM(7, _adPlayhead);
			ggCom.getInstance().PM(4, _adPlayhead, _adType);
			_lastStateAds = 'adEnd';
			if(_adType == "preroll" && _lastStateMedia == 'unloaded')
			{
				ggCom.getInstance().PM(15, contentUrl ? contentUrl : (_mediaProxy.vo.resource as URLResource).url, 'content', this.getVideoInfoFromMetadata(), this.getSegmentFromCuePoints());
				_lastStateMedia = 'mediaInfoSent';
				_lastState = "playerPlayed";
				_lastSegmentInfoSent = _seg;
			}
		}
		
		private function getVideoInfoFromMetadata():String
		{
			var metadata:KalturaPlayableEntry = (facade.retrieveProxy("mediaProxy"))["vo"].entry;
			_duration = isNaN(metadata.duration) ? _duration : metadata.msDuration / 1000;
			var c_seg:Number = this.getSegmentFromCuePoints()-1;
			if(this._cuePoints && this._cuePoints.length)
				if(c_seg == 0)
					_duration = this._cuePoints[c_seg];
				else if(c_seg == this._cuePoints.length)
					_duration = _duration - this._cuePoints[c_seg-1];
				else 
					_duration = this._cuePoints[c_seg] - this._cuePoints[c_seg-1];
			var adxml:XML = <videoInfo></videoInfo>;
			adxml.appendChild(<length>{_duration.toFixed(2)}</length>);
								
			var returnString:String;
			var objIndexArr:Array;
			var value:Object;
			var i:Object;
			
			for(var j:Object in _dynamicClass)
			{
				if(j.indexOf('tag_') == 0)
				{
					var tag:String = j.toString().substring(4);
					returnString = _dynamicClass[j].toString();
					adxml.hasOwnProperty(tag) ? adxml.replace(tag,<{tag}>{returnString}</{tag}>) : adxml.appendChild(<{tag}>{returnString}</{tag}>);
				}
			}
			return adxml.children().toString();
		}
		
		private function getAdInfoFromMetadata():String
		{
			trace("getAdInfoFromMetadata called");
			var xml:XML = <videoInfo></videoInfo>;
			var tag:String;
			var metadata:AdMetadataVO = _sequenceProxy.vo.activePluginMetadata;
			trace("metadata == "+metadata);
			if(metadata)
			{
				trace("metadata.url == "+metadata.url);
				_durationAds = metadata.duration;	
				_adUrl = metadata.url ? metadata.url : "";
			} 
			xml.appendChild(<length>{_durationAds.toFixed(2)}</length>);
			
			var returnString:String;
			
			for(var j:Object in _dynamicClass)
			{
				if(j.indexOf('ad_') == 0 && _dynamicClass[j])
				{
					tag = j.toString().substring(3);
					returnString = _dynamicClass[j].toString();
					xml.hasOwnProperty(tag) ? xml.replace(tag,<{tag}>{returnString}</{tag}>) : xml.appendChild(<{tag}>{returnString}</{tag}>);
				}
			}
			
			trace("xml.children().toString() == "+xml.children().toString());
			return xml.children().toString();
		}
		
		private function getSegmentFromCuePoints ():Number
		{
			var val:Number = 1;
			var l_pos:Number = Math.ceil(_playheadPosition);
			if(!_cuePoints)
				return val;
			if(_cuePoints[0] > l_pos)
				val = 1;
			else if (_cuePoints[_cuePoints.length -1] <= l_pos)
				val = _cuePoints.length+1;
			else
				for(var i:Number = 0; i < _cuePoints.length; i++)
					if(_cuePoints[i] <= l_pos && l_pos < _cuePoints[i+1])
					{
						val = i+2;
						break;
					}
			this._seg = val;
			return val;
		}
	}
}