package {
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.VisibilatorMediator;
	
	import fl.core.UIComponent;
	
	import flash.display.Sprite;
	import flash.utils.setTimeout;
	
	import org.puremvc.as3.interfaces.IFacade;

	/*

	   <Plugin id="visibilator" target="{shareBtn}" tagString="{mediaProxy.entry.adminTags}" tag="hdOn" show="true" />

	 */
	/**
	 * Actual plugin 
	 * @author Atar
	 */
	public class visibilatorPluginCode extends Sprite implements IPlugin {

		/**
		 * the uicomponent this plugin controls
		 */
		[Bindable]
		public var target:UIComponent;

		/**
		 * This plugin looks for a sub string in this string. Typically this will use a bind expression.
		 */
		[Bindable]
		public var tagString:String;
		
		/**
		 * @copy #tag 
		 */
		private var _tag:String;

		/**
		 * @copy #show
		 */
		private var _show:Boolean;


		private var _mediator:VisibilatorMediator;


		public function visibilatorPluginCode() {
			super();
		}


		public function initializePlugin(facade:IFacade):void {
			_mediator = new VisibilatorMediator(this);
			facade.registerMediator(_mediator);
		}


		/**
		 * This plugin is not visible, empty implementation.
		 * @param styleName 
		 * @param setSkinSize
		 */
		public function setSkin(styleName:String, setSkinSize:Boolean = false):void {

		}


		/**
		 * set target visibility according to search string.
		 */
		public function setVisibility():void {
			
			if (tagString && tagString.indexOf(tag) > -1) {
				// set visibility to "show" value
				if (_show) {
					target.visible = true;
				}
				else {
					target.visible = false;
				}
			}
			else {
				// set visibility to opposite of "show" value
				if (_show) {
					target.visible = false;
				}
				else {
					target.visible = true;
				}
			}
		}


		/**
		 * should the plugin show or hide the component if the
		 * search string is found
		 */
		public function get show():String {
			return _show.toString();
		}


		/**
		 * @private
		 */
		public function set show(value:String):void {
			_show = value == "true";
		}

		/**
		 * the tag to search for
		 */
		public function get tag():String
		{
			return _tag;
		}

		/**
		 * @private
		 * we keep the lower case value because for some reason the server  
		 * chooses to save tags as lower case - so that's what we're gonna
		 * get in tagString.
		 */
		public function set tag(value:String):void
		{
			_tag = value.toLowerCase();
		}

	}
}