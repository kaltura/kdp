/**
 * @langversion 3.0
 * @playerversion Flash 10.0.1
 * @author Eitan Avgil
 */
package {
	import com.kaltura.kdpfl.plugin.IPlugin;
	
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.filters.DropShadowFilter;
	
	import org.puremvc.as3.interfaces.IFacade;

	/**
	 * <code>nonvisualDemoCode</code> is the real plugin. 
	 * KDP initializes it by calling <code>initializePlugin()</code> and then calls <code>setSkin()</code>.
	 * @author Atar
	 */
	public class ShadowFilterPluginCode extends UIComponent implements IPlugin {
		
		public var color:Number = 0xAAAAAA;
		public var blurX:Number = 4;
		public var blurY:Number = 4;
		public var angle:Number = 45;
		public var distancs:Number = 4;
		public var strength:Number  =  3;
		public var quality:Number = 15;
		public var inner:Boolean = false;
		public var knockout:Boolean = false;
		public var hideObject:Boolean = false; 
		
		public var target:Object;
		
		/**
		 * Constructor
		 */
		public function ShadowFilterPluginCode() {

		}


		/**
		 * KDP calls this interface method to initialize the new plugin. 
		 * @param facade	KDP application facade
		 * @return
		 */
		public function initializePlugin(facade:IFacade):void {
			
			if (!target && !(target is DisplayObject))
				return;
			
			var dropShadow:DropShadowFilter = new DropShadowFilter();
			dropShadow.color = color;
			dropShadow.blurX = blurX;
			dropShadow.blurY = blurY;
			dropShadow.angle = angle;
			dropShadow.alpha = alpha;
			dropShadow.distance = distancs;
			dropShadow.strength = strength;
			dropShadow.quality = quality;
			dropShadow.inner = inner;
			dropShadow.knockout = knockout;
			dropShadow.hideObject = hideObject;
			
			
			var filtersArray:Array = (target as DisplayObject).filters;
			filtersArray.push(dropShadow);
			(target as DisplayObject).filters = filtersArray;
			trace(1);
		}


		/**
		 * KDP calls this interface method in order to set the plugin's skin.
		 * This plugin isn't visual and has no skin, so the implementation is empty.
		 * @param styleName		name of style to be set
		 * @param setSkinSize
		 */
		public function setSkin(styleName:String, setSkinSize:Boolean = false):void {
		
		}


	}
}
