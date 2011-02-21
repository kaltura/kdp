package
{
	import com.kaltura.controls.Stars;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.starsMediator;
	
	import fl.core.UIComponent;
	
	import flash.system.Security;
	
	import org.puremvc.as3.interfaces.IFacade;
	/**
	 * Class starsPluginCode is the uicomponent that is added to the stage for the plugin. 
	 * @author Hila
	 * 
	 */	
	public class starsPluginCode extends UIComponent implements IPlugin
	{
		
		private var _starsMedidator : starsMediator;
		/**
		 * Flag indicating whether the stars should be static or available for rating.
		 */		
		public var editable:Boolean;
		/**
		 * Parameter holds the initial rating the stars should display.
		 */		
		public var rating : Number;
		/**
		 * Parameter that holds the gap between the stars (in pixels). Default value is 3px. 
		 */		
		private var _gap:Number = 3;
		/**
		 * Scale factor for the stars 
		 */		
		public var starScale : Number;
		
		
		private var stars:Stars;
		
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
			if(rating == -1){
				rating = 0;
			}
			stars = new Stars(starScale);
			stars.gap = _gap;
			_starsMedidator = new starsMediator(stars,editable,rating);
			facade.registerMediator(_starsMedidator);
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
	}
}