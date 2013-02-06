package
{
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.ColorShortcuts;
	
	import com.adobe.serialization.json.JSON;
	import com.kaltura.kdpfl.model.LayoutProxy;
	import com.kaltura.kdpfl.model.PlayerStatusProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.AnimationMediator;
	import com.kaltura.kdpfl.util.Functor;
	import com.kaltura.kdpfl.view.containers.KHBox;
	import com.kaltura.kdpfl.view.media.KMediaPlayerMediator;
	import com.yahoo.astra.fl.containers.HBoxPane;
	
	import fl.core.UIComponent;
	import fl.data.DataProvider;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;

	public class AnimationCode extends MovieClip implements IPlugin
	{
		[Bindable]
		public var color1:String	= "0x000000";
		[Bindable]
		public var color2:String	= "0x000000";
		[Bindable]
		public var color3:String	= "0x000000";
		[Bindable]
		public var color4:String	= "0x000000";
		[Bindable]
		public var color5:String	= "0x000000";
		
		
		public function AnimationCode()
		{
		}
		
		public function initializePlugin(facade:IFacade):void
		{
			var aMediator:AnimationMediator	= new AnimationMediator("animationMediator", this);
				facade.registerMediator(aMediator);
		}
		
		public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
		}
		
		/**
		 * Global animation function.  
		 * @param component:String 	- component name to perform animation against. separate multiple components by comma ",". 
		 * @param arg0:String 		- caurina animation parameters
		 * @param condition:String	- if available, perform only during these MediaPlayer conditions. "playing" or "paused"     
		 * **/	
		Functor.globalsFunctionsObject.tweenProps = function (component : String, arg0:String, condition:String = null) : void
		{

			ColorShortcuts.init();
			var f:IFacade	= Facade.getInstance();
			
			//don't animate during sequence states
			if((f.retrieveProxy("sequenceProxy") as SequenceProxy).vo.isInSequence)
				return;
			
			var components:Array	= new Array();
			if(component.indexOf(",") > -1){
				components	= component.split(",");
			}else{
				components.push(component);
			}
			
			for(var i:int=0;i<components.length;i++){
				var item:String	= components[i];
					
				if(condition){
					if(!(f.retrieveMediator("kMediaPlayerMediator") as KMediaPlayerMediator).player[condition]){
						var tweens:Array	= Tweener.getTweens(f["bindObject"][item]);
						for(var i:int=0;i<tweens.length;i++){
							Tweener.removeTweens(f["bindObject"][item],tweens[i]);
						}
						return;
					}
				}
				
				
				
				while(arg0.indexOf("{") > -1){//tested binding only against this plugin. 
					var extractStr:String = arg0.substr(arg0.indexOf("{"), arg0.indexOf("}")-arg0.indexOf("{")+1);
					var binding:String = extractStr;
						binding	= binding.replace("{","");
						binding	= binding.replace("}","");
					var path:Array	= binding.split(".");
					var s:*		= f["bindObject"];
					for (var i:int=0;i<path.length;i++){
						s = s[path[i]];
					}
					arg0	= arg0.replace(extractStr,s);
				}
				
				var splitStr:Array		= arg0.split(",");
				var props:Object		= new Object();
				for(var i:int=0;i< splitStr.length;i++){
					var propValue:Array	= splitStr[i].split(":");
					props[propValue[0]]		= propValue[1];
				}
				
				//TODO: make this dynamic
				props.transition	= "easeOutQuart";
				
				var comp:* 			=	f["bindObject"][item];
				Tweener.addTween(comp,props);
			}
		}
		
	}
}