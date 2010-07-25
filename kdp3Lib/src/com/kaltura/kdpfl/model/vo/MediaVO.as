package com.kaltura.kdpfl.model.vo
{

	import com.kaltura.kdpfl.model.type.StreamerType;
	import org.osmf.media.pluginClasses.PluginManager;PluginManager;
	import com.kaltura.vo.KalturaBaseEntry;
	import com.kaltura.vo.KalturaEntryContextDataResult;
	import org.osmf.media.MediaElement;MediaElement;
	import org.osmf.media.MediaFactory;MediaFactory;
	import org.osmf.media.MediaResourceBase;MediaResourceBase;
	
	
	[Bindable] 
	/**
	 * Class MediaVO holds parameters related to the media that the KDP plays. 
	 * 
	 */	
	public class MediaVO
	{
		/**
		 * If the current media is liveEntry and if it is NOT broadcasting at the given time this variable will be set to true and vice versa
		 */
		public var isOffline:Boolean = true;
		/**
		 * If the current entry is a live entry this variable will be set to true. Otherwise it will remain false
		 */	
		public var isLive:Boolean = false;	
		/**
		 * entry already loaded entryLoadedBeforeChangeMedia by kdp first multirequest 
		 */
		public var entryLoadedBeforeChangeMedia:Boolean = false;
		
		/** 
		 * Kaltura Entry hold all the Metadata about the Entry from witch a URLResource
		 * can be created and a MediaElemnt can be built
		 */		
		public var entry:KalturaBaseEntry;
		
		/**
		 * a specific flavorId to be played (can be passed via flashvars) 
		 */
		public var selectedFlavorId:String;
		
		/**
		 * a prefered bitrate for selecting the flavor to be played. in case of an rtmp adaptive mbr a -1 value
		 * will force an auto switching as opposed to manual one 
		 */
		public var preferedFlavorBR:int = 1000;
		
		/**
		 * Extra data the we might want to know about the current entry 
		 */		
		public var entryExtraData:KalturaEntryContextDataResult;
	
		/**
		 * OSMF resource that contain the media path to be loaded from 
		 */		
		public var resource:MediaResourceBase;
		
		/**
		 * OSMF MediaElement represents a unified media experience. 
		 * It may consist of a simple media item, such as a video, audio, image, mix ect.
		 */		
		public var media:MediaElement;
		
		/**
		 * Array that contains the Kaltura Flavor Asset collection as objects. 
		 */		
		public var kalturaMediaFlavorArray:Array;
		/**
		 * Array that contains the VideoElement keyframe values(from metadata)
		 */
		public var keyframeValuesArray:Array;
		
		/**
		 * mediaFactory for creating all kind of MediaElemnets
		 */		
		public var mediaFactory:MediaFactory = new MediaFactory();
		
		/**
		 * plugin manager for loading osmf plugins 
		 */
		public var osmfPluginManager:PluginManager = new PluginManager(mediaFactory);
		
		/**
		 * After switch flavor we need to start play again so we need to save this state 
		 */		
		public var singleAutoPlay : Boolean = false;
		
		/**
		 * When the media is Image and played in a playlist we will set the defualt 
		 * time of the image to the next value unless override from flashvars
		 */		
		public var imageDefaultDuration : int = 3;
		
		/**
		 * Some types of media need to behave defrently in a listed ui (playlist,related list) like
		 * Image that need to play with duration if a list is loaded it need to set this attribute to true
		 * if you want to play image in a non listed way even if you load a list set this flag to false again
		 */		
		public var supportImageDuration : Boolean = false;
		
		/**
		 * When we get an entry with a valid restriction, we don't event want it loaded
		 * to the kdp3.
		 */	
		 
		 public var isMediaDisabled : Boolean = false;
		 
		/**
		 * set initial buffer time for quick starting the playing of a stream
		 */
		public var initialBufferTime:Number = 2;
		
		/**
		 * set the maximum buffer time to be set once the video started playing in order to minimize further buffering events
		 */
		public var expandedBufferTime:Number = 10;
		
		/**
		 * Initial buffer time for a live entry
		 */		
		public var initialLiveBufferTime : Number = 0.75;
		
		/**
		 * Expanded buffer time for live entry (buffer time that is set when the video has started to minimize further buffering events).
		 */		
		public var expandedLiveBufferTime : Number = 0.75;

		/**
		 *Flag signifying whether the user has switched bitrates before pressing play. If set to true this flag signifies to the player mediator to switch to the desired bitrate immediately upon commencing playback. 
		 */		
		public var switchDue : Boolean = false;
		
		/**
		 * Delivery type of the entry - because there is a possibility of a playlist that contains both progressive download entries and live stream entries.
		 */	
		public var deliveryType : String = StreamerType.HTTP;
		/**
		 *  Flag indicating whether the media that is being loaded should begin playing immediately after being loaded.
		 */		
		public var playOnLoad : Boolean = false;	

	}
}