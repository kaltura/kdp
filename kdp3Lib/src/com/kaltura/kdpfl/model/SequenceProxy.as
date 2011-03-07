package com.kaltura.kdpfl.model
{
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.type.SequenceContextType;
	import com.kaltura.kdpfl.model.vo.MediaVO;
	import com.kaltura.kdpfl.model.vo.SequenceVO;
	import com.kaltura.kdpfl.plugin.IMidrollSequencePlugin;
	import com.kaltura.kdpfl.plugin.ISequencePlugin;
	import com.kaltura.kdpfl.plugin.Plugin;
	import com.kaltura.kdpfl.util.Cloner;
	import com.kaltura.osmf.proxy.KSwitchingProxyElement;
	
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
			for (var prop : String in describeVO)
			{
				(facade.retrieveProxy(MediaProxy.NAME) as MediaProxy).vo[prop] = describeVO[prop];
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
			}
			else if (vo.postCurrentIndex != -1){
				activeSequenceArr = vo.postSequenceArr;
				activeIndex = vo.postCurrentIndex;
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
					(activeSequenceArr[activeIndex] as ISequencePlugin).start();
					
				}
			}
			else
			{
				activeSequenceArr[activeIndex].start();
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
			if (plugin is IMidrollSequencePlugin)
			{
				vo.midrollArr.push(plugin);
			}
		}
		
		/**
		 *Function to populate the pre and post sequence arrs on the  
		 * SequenceVO with the appropriate configurations
		 */        
		public function populatePrePostArr () : void
		{
			vo.preSequenceArr = new Array();
			vo.postSequenceArr = new Array();
			vo.midrollArr = new Array();
			var bindObj : Object = facade["bindObject"];
			
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
				vo.preCurrentIndex == vo.preSequenceArr.length  ? returnVal = false : returnVal = true;
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
			//The index for the post sequence is active
			if (vo.postCurrentIndex != -1)
			{
				return SequenceContextType.POST;
			}
				//The index for preSequence is active
			else if (vo.preCurrentIndex != -1)
			{
				return SequenceContextType.PRE;
			}
				//Both indexes equal -1 which means we're running the main entry
			else if (vo.isInSequence)
			{
				return SequenceContextType.MID;
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
				return vo.activeMidrollPlugin;
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
				var mediaProxy : MediaProxy = facade.retrieveProxy( MediaProxy.NAME ) as MediaProxy;
				
				if (mediaProxy.vo.media is KSwitchingProxyElement)
				{
					(mediaProxy.vo.media as KSwitchingProxyElement).switchElements();
				}
			}
		}
		
		public function activateMidrollSequence (midrollPlugin : IMidrollSequencePlugin) : void
		{
			vo.activeMidrollPlugin = midrollPlugin;
			
		}
		
	}
}