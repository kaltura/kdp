package
{
	import com.kaltura.controls.Stars;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.starsMediator;
	
	import fl.core.UIComponent;
	
	import flash.external.ExternalInterface;
	import flash.system.Security;
	
	import org.puremvc.as3.interfaces.IFacade;

	/**
	 * Class starsPluginCode is the uicomponent that is added to the stage for the plugin. 
	 * @author Hila
	 * 
	 */	
	public class starsPluginCode extends UIComponent implements IPlugin
	{
		
		private var _starsMediator : starsMediator;
		private var _editable:Boolean;
		private var _rating : Number = 0;
		/**
		 * Parameter that holds the gap between the stars (in pixels). Default value is 3px. 
		 */		
		private var _gap:Number = 3;
		/**
		 * Scale factor for the stars 
		 */		
		public var starScale : Number = 1;
		
		
		private var stars:Stars;
		
		private var _useExternalRatingSystem : Boolean = false;
		
		public var externalSetRatingFunction : String = "setRating";
		
		public var externalGetRatingFunction : String = "getRating";
		
		/**
		 * Constructor 
		 * @param isEditable flag indicating whether the stars should be open for ranking or static.
		 * @param startRank the initial rank the stars should display.
		 * 
		 */		
		public function starsPluginCode(isEditable:Boolean, startRank:Number)
		{
			Security.allowDomain("*");
			rating = startRank;
		}
		/**
		 * The initialization function for the plugin. Creates the view-component and the mediator of the plugin. 
		 * @param facade
		 * 
		 */		
		public function initializePlugin (facade : IFacade) : void
		{
			var mediaProxy : MediaProxy = facade.retrieveProxy(MediaProxy.NAME) as MediaProxy;
			if(rating == -1){
				rating = 0;
			}

			if (_useExternalRatingSystem)
			{
				rating = ExternalInterface.call (externalGetRatingFunction, [mediaProxy.vo.entry.id]);
			}
			stars = new Stars(starScale);

			stars.gap = _gap;
			_starsMediator = new starsMediator(stars,editable,rating);
			
			_starsMediator.useExternalRatingSystem = _useExternalRatingSystem;
			facade.registerMediator(_starsMediator);
			addChild(stars);
		}
		
		public function setSkin(styleName:String, setSkinSize:Boolean=false):void{}
		
		
		public function set gap(value:Number):void
		{
			_gap = value;
			if(stars!=null)
			{
				stars.gap = value;
			}
		}
		
		public function get gap():Number
		{
			return _gap;
		}
		
		[Bindable]
		public function get useExternalRatingSystem():String
		{
			return _useExternalRatingSystem.toString();
		}

		public function set useExternalRatingSystem(value:String):void
		{
			_useExternalRatingSystem = (value == "true") ? true : false;
		}

		/**
		 * Flag indicating whether the stars should be static or available for rating.
		 */
		public function get editable():Boolean
		{
			return _editable;
		}

		/**
		 * @private
		 */
		public function set editable(value:Boolean):void
		{
			_editable = value;
		}

		/**
		 * Parameter holds the initial rating the stars should display.
		 */
		public function get rating():Number
		{
			return _rating;
		}

		/**
		 * @private
		 */
		public function set rating(value:Number):void
		{
			_rating = value;
		}


	}
}