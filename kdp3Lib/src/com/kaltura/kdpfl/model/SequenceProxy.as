package com.kaltura.kdpfl.model
{
	import com.kaltura.kdpfl.model.type.AdOpportunityType;
	import com.kaltura.kdpfl.model.type.AdsNotificationTypes;
	import com.kaltura.kdpfl.model.type.EnableType;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.type.SequenceContextType;
	import com.kaltura.kdpfl.model.vo.MediaVO;
	import com.kaltura.kdpfl.model.vo.SequenceVO;
	import com.kaltura.kdpfl.plugin.IMidrollSequencePlugin;
	import com.kaltura.kdpfl.plugin.ISequencePlugin;
	import com.kaltura.kdpfl.plugin.Plugin;
	import com.kaltura.kdpfl.util.Cloner;
	import com.kaltura.kdpfl.view.controls.KTrace;
	import com.kaltura.kdpfl.view.media.KMediaPlayerMediator;
	import com.kaltura.osmf.proxy.KSwitchingProxyElement;
	import com.kaltura.vo.KalturaCuePoint;
	
	import org.osmf.elements.SWFElement;
	import org.osmf.events.MediaPlayerCapabilityChangeEvent;
	import org.osmf.events.TimeEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaPlayer;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.TimeTrait;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	/**
	 * Class SequenceProxy manages everything that is related to the sequence mechanism - i.e the beginning of pre- and post- 
	 * advertising sequences, resolving of progress after pre- or post- sequences have ended, etc.
	 * @author Hila
	 * 
	 */	
	public class SequenceProxy extends Proxy
	{
		public static const NAME:String = "sequenceProxy";

		
		/**
		 * indicates we started playing an ad and we should send adEnd on playback complete 
		 */		
		public var shouldEndAd:Boolean = false;
		
		public function SequenceProxy(proxyName:String=null, data:Object=null)
		{
			super( NAME, new SequenceVO() );
		}
		
		public function get vo():SequenceVO  
		{  
			return data as SequenceVO;  
		} 
		
		/**
		 *Function which saves the main mediaVO as a property of the SequenceVO. 
		 * 
		 */        
		public function saveMainMedia() : void
		{
			var cloner : Cloner = new Cloner();
			vo.mainMediaVO = cloner.clone((facade.retrieveProxy(MediaProxy.NAME) as MediaProxy).vo) as MediaVO;
			
			
		}
		/**
		 *Function which restores the original mediaVO to the MediaProxy 
		 * 
		 */        
		public function restoreMainMedia () : void
		{
			var cloner : Cloner = new Cloner();
			var describeVO : Object = Cloner.describeObject(vo.mainMediaVO);
			var mediaVo:MediaVO = (facade.retrieveProxy(MediaProxy.NAME) as MediaProxy).vo as MediaVO;
			for (var prop : String in describeVO)
			{
				mediaVo[prop] = describeVO[prop];
			}
			
			var player:MediaPlayer = (facade.retrieveMediator(KMediaPlayerMediator.NAME) as KMediaPlayerMediator).player;
			if (mediaVo.useParallelElement) 
			{
				sendNotification(NotificationType.RESTORE_MAIN_PARALLEL_ELEMENT);
			}
		}
		
		/**
		 * Function which checks whether the sequence plugin lined up to play plays withing the KDP or as an independent swf. 
		 * @return <code>true</code> if the plugin plays in the KDP; <code>false</code> otherwise.
		 * 
		 */        
		public function hasMediaElement () : Boolean
		{
			//Check whether the next plugin in the sequence has a media element which can be loaded 
			//into the player
			var mediaProxy : MediaProxy = facade.retrieveProxy(MediaProxy.NAME) as MediaProxy;
			
			if (vo.preCurrentIndex != -1)
			{
				if ( vo.preSequenceArr[vo.preCurrentIndex].hasMediaElement() )
				{
					vo.isAdSkip = true;
					return true;
				}
			}
			else if (vo.postCurrentIndex != -1 )
			{
				if (vo.postSequenceArr[vo.postCurrentIndex].hasMediaElement() )
				{
					vo.isAdSkip = true;
					return true;
				}
			}
			vo.isAdSkip = false;
			return false;	
		}
		
		/**
		 * Function checks whether the sequence plugin lined up to play
		 * has been loaded into the MediaPlayer (this check is performed only if the
		 * sequence plugin plays in the MediaPlayer of the KDP and not as a custom swf.
		 * 
		 */        
		public function hasMediaLoaded () : Boolean
		{
			//Check whether the plugin media is loaded into the KDP.
			
			var mediaProxy : MediaProxy = facade.retrieveProxy(MediaProxy.NAME) as MediaProxy;
			
			if ( (mediaProxy.vo.entry.id == activePlugin().entryId) || (activePlugin().mediaElement) )
			{
				return true;
			}
			
			
			return false;
			
		}
		
		/**
		 * Function which plays the next sequence plugin lined up to play in either
		 * the pre-sequenceor the post-sequence. 
		 * 
		 */        
		public function playNextInSequence () : void
		{
			//Begins a sequence of events to start playing the next Sequence Plugin
			var  activeIndex : int;
			var activeSequenceArr : Array;
			if (vo.preCurrentIndex != -1){
				activeSequenceArr = vo.preSequenceArr;
				activeIndex = vo.preCurrentIndex;
				if (vo.preCurrentIndex == 0) {
					sendNotification(NotificationType.PRE_SEQUENCE_START);
				}
			}
			else if (vo.postCurrentIndex != -1){
				activeSequenceArr = vo.postSequenceArr;
				activeIndex = vo.postCurrentIndex;
				if (vo.postCurrentIndex == 0) {
					sendNotification(NotificationType.POST_SEQUENCE_START);
				}
			}
			else if (vo.midCurrentIndex != -1) 
			{
				if (!vo.midrollArr || !vo.midrollArr.length)
				{
					sendNotification(NotificationType.MID_SEQUENCE_EMPTY);
					vo.midCurrentIndex = -1;
				}
				else
				{
					activeSequenceArr = vo.midrollArr;
					activeIndex = vo.midCurrentIndex;
					if (vo.midCurrentIndex == 0) {
						sendNotification(NotificationType.MID_SEQUENCE_START);
					}
				}
			}
			
			if ( hasMediaElement() )
			{
				if ( !vo.mainMediaVO )
        		{
        			saveMainMedia();
        		}
				if ( !hasMediaLoaded() )
				{
					sendNotification(NotificationType.CHANGE_MEDIA, {entryId:activeSequenceArr[activeIndex].entryId});
				}
				else
				{
					if(activePlugin().entryId != "null")
					{
						vo.isAdLoaded = true;
					}
					sendNotification(NotificationType.SEQUENCE_ITEM_PLAY_START, {sequenceContext : sequenceContext, currentIndex : activeIndex});
					(activeSequenceArr[activeIndex] as ISequencePlugin).start();
					
				}
			}
			else
			{
				if ( activeSequenceArr && activeSequenceArr.length )
				{
					sendNotification(NotificationType.SEQUENCE_ITEM_PLAY_START, {sequenceContext : sequenceContext, currentIndex : activeIndex});
					activeSequenceArr[activeIndex].start();
				}
			}
		}
		
		/**
		 * Function to insert a particular plugin into the pre and post sequence arrs. 
		 * @param plugin - 
		 * 
		 */        
		private function addPluginToSequenceArrs (plugin : ISequencePlugin) : void
		{
			
			if( plugin.preIndex )
			{
				vo.preSequenceArr[plugin.preIndex -1] = plugin;
			}
			if ( plugin.postIndex )
			{
				vo.postSequenceArr[plugin.postIndex -1] = plugin;
			}
			if ( (plugin is IMidrollSequencePlugin) && (plugin as IMidrollSequencePlugin).hasMidroll())
			{
				vo.midrollArr.push( plugin );
			}
			
		}
		
		/**
		 *  funtion to populate the preroll and postroll arrays.
		 * @param preArr -  optional parameter of type array allowing the player to set the preroll array from the cue points
		 * @param postArr - optional parameter of type array allowing the player to set the postroll array from the cue points
		 * 
		 */		       
		public function populatePrePostArr (preArr : Array = null, postArr : Array = null) : void
		{
			vo.preSequenceArr = new Array();
			vo.postSequenceArr = new Array();
			vo.midrollArr = new Array();
			var bindObj : Object = facade["bindObject"];
			if (!preArr || !postArr)
			{
				for each(var comp : * in bindObj)
				{
					if ( comp is Plugin )
					{
						if (comp.content is ISequencePlugin)
						{
							addPluginToSequenceArrs(comp.content as ISequencePlugin);
						}
					}
				}
			}
			if (preArr || postArr)
			{
				if (preArr && preArr.length)
				{
					createPluginArrayFromNameArray( preArr, vo.preSequenceArr );
				}
				if (postArr && postArr.length)
				{
					createPluginArrayFromNameArray(  postArr, vo.postSequenceArr );			
				}
			}
		}
		
		/**
		 * Correct function for setting one of the sequence arrays found on the SequenceVO object 
		 * @param nameArray - array of sequence plugin names to insert into the sequence array
		 * @param pluginArray - the sequence array to set with plugins
		 * 
		 */		
		public function createPluginArrayFromNameArray (nameArray : Array, pluginArray : Array) : void
		{
			var bindObj : Object = facade["bindObject"];
			for each (var pluginName : String in nameArray)
			{
				if (bindObj.hasOwnProperty(pluginName) && (bindObj[pluginName] is ISequencePlugin))
				{
					pluginArray.push(bindObj[pluginName]);
				}
			}	
		}
		
		/**
		 * Function to check whether the pre and post sequences have been configured 
		 * @return True- if the pre and post arrs have been populated. false otherwise.
		 * 
		 */        
		public function prePostInited () : Boolean
		{
			if ( !vo.preSequenceArr || !vo.postSequenceArr ) 
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		
		/**
		 * Function evaluates whether there is are sequence items to play. 
		 * @return returns <code>true</code> if there is anything left to play in 
		 * the pre or post sequence arrays. Returns <code>false</code> otherwise.
		 * 
		 */        
		public function hasSequenceToPlay () : Boolean
		{
			var	returnVal : Boolean = false;
			if (vo.preCurrentIndex != -1)
			{
				if (vo.skipPrerolls)
				{
					returnVal = false;
					vo.preCurrentIndex = -1;
				}
				else
				{
					vo.preCurrentIndex == vo.preSequenceArr.length  ? returnVal = false : returnVal = true;
				}
			}
				
			else if (vo.postCurrentIndex != -1)
			{
				vo.postCurrentIndex == vo.postSequenceArr.length ? returnVal = false : returnVal = true;
			}
			return returnVal;
		}
		
		/**
		 * Function for retrieval of the sequence context that is running currently. 
		 * @return If in pre-sequence - "pre"; post-sequence = "post"; mid-sequence - "mid";
		 * running main entry - "main"
		 * 
		 */		
		public function get sequenceContext () : String
		{
			//The index for preSequence is active
			if (vo.preCurrentIndex != -1)
			{
				return SequenceContextType.PRE;
			}
			else if (vo.midCurrentIndex != -1)
			{
				return SequenceContextType.MID;
			}
			//The index for the post sequence is active
			else if (vo.postCurrentIndex != -1)
			{
				return SequenceContextType.POST;
			}
			else 
			{
				return SequenceContextType.MAIN;
			}
		}
		
		/**
		 * Function evaluates the pre sequence index to 0
		 * if the kdp has pre sequence configured. 
		 * 
		 */		
		public function initPreIndex() : void
		{
			if (vo.preSequenceArr.length > 0)
			{
				vo.preCurrentIndex = 0;
			}
			else
			{
				vo.preCurrentIndex = -1;
			}
		}
		
		/**
		 * Function initiates the postsequence index to 0
		 * on the condition that the player has post-sequence configured. 
		 * 
		 */		
		public function initPostIndex() : void
		{
			if (vo.postSequenceArr.length > 0 )
			{
				vo.postCurrentIndex = 0;
			}
			else{
				vo.postCurrentIndex = -1
			}
		}
		
		
		/**
		 * Function returns whether the sequence plugin lined up to play
		 * has a sub-sequence (For now, will only be implemented with VAST plugin.  
		 * @return <code>true</code> if the sequence plugin has any sequence of its own;
		 * <code>false</script> otherwise.
		 * 
		 */		
		public function hasSubSequence () : Boolean
		{
			if (vo.preCurrentIndex != -1)
			{
				return vo.preSequenceArr[vo.preCurrentIndex].hasSubSequence();
			}
			else if (vo.postCurrentIndex != -1)
			{
				return vo.postSequenceArr[vo.postCurrentIndex].hasSubSequence();
			}
			else if (vo.midCurrentIndex != -1)
			{
				return vo.midrollArr[vo.midCurrentIndex].hasSubSequence();
			}
			return false;
		}
		
		/**
		 * Function which evaluates the current plugin being played in the sequence (pre/post) 
		 * @return 
		 * 
		 */		
		public function activePlugin () : ISequencePlugin
		{
			if (vo.preCurrentIndex != -1)
				return vo.preSequenceArr[vo.preCurrentIndex];
			else if (vo.postCurrentIndex != -1)
				return vo.postSequenceArr[vo.postCurrentIndex];
			else if (sequenceContext == SequenceContextType.MID)
				return vo.midrollArr[vo.midCurrentIndex];
			else
				return null;
		}
		
		/**
		 * Function meant to resolve the onward progress of playback after the end
		 * of a sequence plugin - whether the next plugin should be played or whether the
		 * sequence (pre/post) has been completed 
		 * 
		 */		
		public function resolveProgress() : void
		{
			//Hide the count down message.
			vo.isAdSkip = false;
			vo.isAdLoaded = false;
			if (vo.preCurrentIndex != -1)
			{
				vo.preCurrentIndex++;
				if (vo.preCurrentIndex == vo.preSequenceArr.length)
				{
					sendNotification(NotificationType.PRE_SEQUENCE_COMPLETE);
				}
				else
				{
					playNextInSequence();
				}
			}
			else if (vo.postCurrentIndex != -1)
			{
				vo.postCurrentIndex++;
				if (vo.postCurrentIndex == vo.postSequenceArr.length)
				{
					sendNotification(NotificationType.POST_SEQUENCE_COMPLETE);
				}
				else
				{
					playNextInSequence();
				}
			}
			else if (sequenceContext == SequenceContextType.MID)
			{
				vo.midCurrentIndex++;
				var mediaProxy : MediaProxy = facade.retrieveProxy( MediaProxy.NAME ) as MediaProxy;
				if (vo.midCurrentIndex == vo.midrollArr.length)
				{
					sendNotification( NotificationType.MID_SEQUENCE_COMPLETE );
				}
				else
				{
					if ((mediaProxy.vo.media as KSwitchingProxyElement).proxiedElement != (mediaProxy.vo.media as KSwitchingProxyElement).mainMediaElement)
					{
						(mediaProxy.vo.media as KSwitchingProxyElement).switchElements();
					}
					playNextInSequence()
				}
			}
		}
		/**
		 * function which activates the sequence plugin's midroll sequence.
		 * @param midrollPlugin the sequence plugin sheduled to play a midroll.
		 * 
		 */		
		public function activateMidrollSequence (midrollPlugin : IMidrollSequencePlugin) : void
		{
			vo.activeMidrollPlugin = midrollPlugin;
			
		}
		
		/**
		 * Function which stops the current sequence and returns the user to the 
		 * main entry 
		 * 
		 */			
		public function stopCurrentSequence () : void
		{
			sendNotification (NotificationType.DO_PAUSE);
			var origIndex : int = -1;
			if (vo.preCurrentIndex != -1 )
			{
				origIndex = vo.preCurrentIndex;
				vo.preCurrentIndex = vo.preSequenceArr.length;
			}
			else if ( vo.postCurrentIndex != -1 )
			{
				origIndex = vo.postCurrentIndex;
				vo.postCurrentIndex = vo.postSequenceArr.length;
			}
			else if ( vo.midCurrentIndex != -1 )
			{
				origIndex = vo.midCurrentIndex;
				vo.midCurrentIndex = vo.midrollArr.length;
			}

			sendNotification (NotificationType.SEQUENCE_ITEM_PLAY_END, {sequenceContext : sequenceContext, currentIndex : origIndex});
		}
		
		/**
		 * set the given element as the player's media secondary element and start to play the midroll 
		 * @param element
		 * @return true if ad start was sent, otherwise false
		 * 
		 */		
		public function switchElementForMidroll(element:MediaElement):Boolean {
			if (element.hasTrait(MediaTraitType.TIME)) 
			{
				var elementDuration:Number = (element.getTrait(MediaTraitType.TIME) as TimeTrait).duration;
	
				if (isNaN(elementDuration) || elementDuration<=0) {
					sendNotification(NotificationType.SEQUENCE_ITEM_PLAY_END, {sequenceContext : sequenceContext, currentIndex : vo.midCurrentIndex});
					
					return false;
				}
			}
		
			enableGui(false);
			var player:MediaPlayer = (facade.retrieveMediator(KMediaPlayerMediator.NAME) as KMediaPlayerMediator).player;
			var spe:KSwitchingProxyElement = player.media as KSwitchingProxyElement;
			spe.secondaryMediaElement = element;
			
			if (element is SWFElement)
				vo.isAdLoaded = true;
			else
			{
				player.addEventListener( MediaPlayerCapabilityChangeEvent.CAN_PLAY_CHANGE , onAdPlayable );
				player.addEventListener(TimeEvent.DURATION_CHANGE, onAdDurationReceived,false, int.MIN_VALUE);
			}
			shouldEndAd = true;
			sendNotification(AdsNotificationTypes.AD_START, {timeSlot: sequenceContext});
			spe.switchElements();
			
			return true;
		}
		
		/**
		 * set the given mediaElement as the player's media 
		 * @param mediaElement the element to play
		 * @param isPre is preroll
		 * @return true if adStart notification was sent
		 * 
		 */		
		public function setPrePostMedia(mediaElement:MediaElement):Boolean {
			if (mediaElement.hasTrait(MediaTraitType.TIME)) 
			{
				var elementDuration:Number = (mediaElement.getTrait(MediaTraitType.TIME) as TimeTrait).duration;
				if (isNaN(elementDuration) || elementDuration<=0)
				{
					var curIndex:int = (sequenceContext == SequenceContextType.PRE) ? vo.preCurrentIndex : vo.postCurrentIndex;
					sendNotification(NotificationType.SEQUENCE_ITEM_PLAY_END, {sequenceContext : sequenceContext, currentIndex : curIndex });
					return false;
				}
			}
		
			var playerMediator:KMediaPlayerMediator = facade.retrieveMediator(KMediaPlayerMediator.NAME) as KMediaPlayerMediator;
			var mediaProxy:MediaProxy = facade.retrieveProxy(MediaProxy.NAME) as MediaProxy;
			
			//improve user experience: if we play live stream we can start connect to it during the preroll play
			if (mediaProxy.vo.useParallelElement && (sequenceContext == SequenceContextType.PRE))
			{
				sendNotification(NotificationType.CREATE_PARALLEL_ELEMENT, {mediaElement: mediaElement});
			}
			else
			{
				playerMediator.player.media = mediaElement;				
			}
			enableGui(false);	
			shouldEndAd = true;
			vo.isAdLoaded = true;
			sendNotification(AdsNotificationTypes.AD_START, {timeSlot: sequenceContext});
			playerMediator.playContent();

			return true;		
		}
		
		/**
		 * call ad end notification
		 * */
		public function endAd():void {
			enableGui(true);
			sendNotification(AdsNotificationTypes.AD_END, {timeSlot: sequenceContext});
			shouldEndAd = false;
		}
		
		/**
		 * starts to play the secondary element 
		 * @param e
		 * 
		 */		
		private function onAdPlayable (e:MediaPlayerCapabilityChangeEvent) : void
		{	
			var kmediaPlayer:KMediaPlayerMediator = facade.retrieveMediator(KMediaPlayerMediator.NAME) as KMediaPlayerMediator;
			if (e.enabled)
			{
				kmediaPlayer.playContent();
				kmediaPlayer.player.removeEventListener( MediaPlayerCapabilityChangeEvent.CAN_PLAY_CHANGE , onAdPlayable );
			}
		}
		
		/**
		 * update vo values 
		 * @param e
		 * 
		 */		
		private function onAdDurationReceived (e : TimeEvent) : void
		{
			if (e.time > 0 && !isNaN(e.time))
			{
				vo.timeRemaining = Math.round(e.time);
				vo.isAdLoaded = true;
				(e.target as MediaPlayer).removeEventListener(TimeEvent.DURATION_CHANGE, onAdDurationReceived );
			}
		}
		
		/**
		 * disable/enable gui, besides volume bar 
		 * @param enabled
		 * 
		 */		
		private function enableGui(enabled:Boolean):void
		{
			sendNotification(NotificationType.ENABLE_GUI, {guiEnabled: enabled, enableType: EnableType.FULL});
			// volume bar stays enabled all the time.
			try{
				facade['bindObject']['volumeBar'].enabled = true;
			}
			catch (e:Error){
				KTrace.getInstance().log('Enabling volumeBar caught error: ' + e.toString());
			}
		}
		
		/**
		 * This function will trigger a mid sequence to start. 
		 * @param sendAdOpportunity - true if it should send AD_OPPORTUNITY notification (it will cause 
		 * the registered ad plugin to push itself to the midrolls array)
		 * @param cuePointObj - cue point object that will be send on AD_PPORUNITY 
		 * 
		 */		
		public function startMidSequence(sendAdOpportunity:Boolean, cuePointObj:KalturaCuePoint = null):void 
		{
			if (sendAdOpportunity)
			{
				sendNotification(NotificationType.AD_OPPORTUNITY, {context : SequenceContextType.MID, cuePoint: cuePointObj, type: AdOpportunityType.EXTERNAL});
			}
			vo.midCurrentIndex = 0;
			playNextInSequence();
		}
		
		/**
		 * reset presequence and postsequence states, as if they weren't played yet 
		 * 
		 */		
		public function resetPrePostSequence():void 
		{
			initPreIndex();
			vo.postSequenceComplete = false;
		}
		
	}
	
	
}