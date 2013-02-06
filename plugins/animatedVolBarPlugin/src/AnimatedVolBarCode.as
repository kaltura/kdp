package
{

	import caurina.transitions.Tweener;
	
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.util.KColorUtil;
	import com.kaltura.kdpfl.view.containers.KCanvas;
	import com.kaltura.kdpfl.view.containers.KHBox;
	import com.kaltura.kdpfl.view.containers.KVBox;
	import com.kaltura.kdpfl.view.controls.KButton;
	import com.kaltura.kdpfl.view.controls.KLabel;
	import com.kaltura.kdpfl.view.controls.ToolTipManager;
	import com.yahoo.astra.fl.containers.BoxPane;
	import com.yahoo.astra.layout.modes.HorizontalAlignment;
	import com.yahoo.astra.layout.modes.VerticalAlignment;
	
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.net.SharedObject;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	
	import org.osmf.layout.HorizontalAlign;
	import org.osmf.layout.VerticalAlign;
	import org.puremvc.as3.interfaces.IFacade;
	
	public class AnimatedVolBarCode extends KHBox implements IPlugin
	{
		private var _currVolumeIdx:Number	= -1;
		private var _volumeBars:Array;		
		private var _volBarsContainer:KHBox;
		private var _volumeCookie:Object;
		private var _volBtn:KButton; 
		private var _mediator:AnimatedVolBarMediator;
		public var 	selectedTooltip:String	= "";
		public var	defaultTooltip:String	= "";
		
		public var totalBars:Number			= 10;
		public var layoutType:String		= "horizontal"; //or vertical;
		public var volBarGap:Number			= 3;
		public var forceInitialValue:Boolean=false;
		public var initialValue:Number		=-1;
		public var animated:Boolean=true;
		
		public var dynamicColor:Boolean		= false;
		
		[Bindable]//volume btn upstate
		public var color1:Number			= -1;
		
		[Bindable]//volume btn hover
		public var color2:Number			= -1;
		
		[Bindable]//volume btn down
		public var color3:Number			= -1;
		
		[Bindable]//selected volume btn upstate
		public var color4:Number			= -1;
		[Bindable]//selected volume btn hover
		public var color5:Number			= -1;
		[Bindable]//selected volume btn down
		public var color6:Number			= -1;
		
		public var volBarActiveColor:uint	= 0x0000FF;
		public var volBarInactiveColor:uint = 0x666666;
		
		public var selectedOnOut:Boolean	= true;
		
		//volume icon styles
		public var volumeUpIcon:String					= "VolumeIcon_Up";
		public var volumeOverIcon:String				= "VolumeIcon_Hover";
		public var volumeDownIcon:String				= "VolumeIcon_Down";
		public var volumeDisabledIcon:String			= "VolumeIcon_Disabled";
		public var volumeSelectedUpIcon:String			= "MuteIcon_up";
		public var volumeSelectedOverIcon:String		= "MuteIcon_Hover";
		public var volumeSelectedDownIcon:String		= "MuteIcon_Down";
		public var volumeSelectedDisabledIcon:String	= "MuteIcon_Disabled";
		
		public var volBarUpIcon:String					= "animatedVolBar_active";
		public var volBarOverIcon:String				= "animatedVolBar_over";
		public var volBarDownIcon:String				= "animatedVolBar_over";
		public var volBarDisabledIcon:String			= "animatedVolBar_inactive";
		public var volBarSelectedUpIcon:String			= "animatedVolBar_over";
		public var volBarSelectedOverIcon:String		= "animatedVolBar_over";
		public var volBarSelectedDownIcon:String		= "animatedVolBar_over";
		public var volBarSelectedDisabledIcon:String	= "animatedVolBar_inactive";

		public function AnimatedVolBarCode()
		{
			super();
		}
		
		public function initializePlugin(facade:IFacade):void
		{
				_mediator	= new AnimatedVolBarMediator("animatedVolBarMediator",this);
				facade.registerMediator(_mediator);
				buttonMode	= true;
				
				try
				{
					_volumeCookie= SharedObject.getLocal("KalturaVolume");
				}
				catch (e : Error)
				{
					trace("[AnimatedVolBar] : No access to user's file system");
					//trace ("No access to user's file system");
				}
				var userVolume:Number	= -1;
				if(_volumeCookie && _volumeCookie.data.volume != null){
					userVolume	= 	Number(_volumeCookie.data.volume);
				}
				
				if(initialValue == -1 && userVolume != -1 && !forceInitialValue)
					initialValue	= userVolume;	
				
				//set initialValue default
				if(initialValue == -1)
					initialValue = .5;

		}
		
		override public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
			//	setStyle("skin", gray_bg); 
		}

		/**
		 * builds the equivalent uiconf layout of: 
		 *  
		 * <HBox id="animatedVolBar" width="100%" height="100%">
		 *  <Button id="volume" minHeight="100%"/>
		 * 	<Canvas id="volBarsCanas">
		 * 		<HBox id="volBarsContainer" width="100%" height="100%">
		 * 			<Button id="volumeBar_1" maxWidth="ASSET WIDTH" maxHeight="ASSET HEIGHT"/>
		 * 			<Button id="volumeBar_2" maxWidth="ASSET WIDTH" maxHeight="ASSET HEIGHT"/>
		 *	 		<Button id="volumeBar_3" maxWidth="ASSET WIDTH" maxHeight="ASSET HEIGHT"/>
		 *			...
		 * 		</HBox>
		 * 		<HBox id="volBarMask" width="100%" height="100%"/>  //this container masks the volBarsContainer when it's animated. 
		 * 	</Canvas>
		 * </HBox>
		 **/
		
		public function initLayout():void{
				defaultTooltip		= tooltip;
				
				_volumeBars			= new Array();
				
				var mouseTracker:Sprite	= new Sprite();
				mouseTracker.graphics.beginFill(0xFF0000,0);
				mouseTracker.graphics.drawRect(0,0,this.width,this.height);
				mouseTracker.graphics.endFill();
				
				//MUTE AND VOLUME BUTTON
				_volBtn	= new KButton();
				_volBtn.buttonType	= "iconButton";
				_volBtn.id = "volume";
				_volBtn.setStyle("upIcon", volumeUpIcon);
				_volBtn.setStyle("overIcon", volumeOverIcon);
				_volBtn.setStyle("downIcon", volumeDownIcon);
				_volBtn.setStyle("disabledIcon", volumeDisabledIcon);
				_volBtn.setStyle("selectedUpIcon", volumeSelectedUpIcon);
				_volBtn.setStyle("selectedOverIcon", volumeSelectedOverIcon);
				_volBtn.setStyle("selectedDownIcon", volumeSelectedDownIcon);
				_volBtn.setStyle("selectedDisabledIcon", volumeSelectedDisabledIcon);
				_volBtn.toggle		= true;
				_volBtn.minHeight	= this.height;
				
				/*
				var ct:ColorTransform	= new ColorTransform();
					ct.color			= 0xFF0000;
				(_volBtn.getStyle("upIcon") as DisplayObject).transform.colorTransform	= ct;
				*/
				
				_volBtn.color1	= color1;
				_volBtn.color2	= color2;
				
				//KColorUtil.colorDisplayObject(child,color5);
				
				addChild(_volBtn);
				
				//START VOLUME BARS CREATION
				_volBarsContainer					= new KHBox();
				_volBarsContainer.horizontalAlign	= HorizontalAlign.LEFT;
				_volBarsContainer.verticalAlign		= VerticalAlign.MIDDLE;
			//	_volBarsContainer.id				= "volBarsContrainer";
				_volBarsContainer.width				= this.width;
				_volBarsContainer.height			= this.height;
				
			var volBarsCanvas:KCanvas	= new KCanvas();
				volBarsCanvas.id		= "volBarsCanvas";
				
			
			var VolBarBtnClass:Class	= getDefinitionByName("animatedVolBar_active") as Class;
			
			var volBarBtnMC:MovieClip	= new VolBarBtnClass() as MovieClip;
				//get actual mc height and width
				var volBarWidth:Number	= volBarBtnMC.width;
				var volBarHeight:Number	= volBarBtnMC.height;

			for(var i:int=0;i<totalBars;i++){				
				var volBarBtn:KButton = new KButton();
				volBarBtn.id = "volumeBar_"+i;
				volBarBtn.setStyle("upIcon", volBarUpIcon);
				volBarBtn.setStyle("overIcon", volBarOverIcon);
				volBarBtn.setStyle("downIcon", volBarDownIcon);
				volBarBtn.setStyle("disabledIcon", volBarDisabledIcon);
				volBarBtn.setStyle("selectedUpIcon", volBarSelectedUpIcon);
				volBarBtn.setStyle("selectedOverIcon", volBarSelectedOverIcon);
				volBarBtn.setStyle("selectedDownIcon", volBarSelectedDownIcon);
				volBarBtn.setStyle("selectedDisabledIcon", volBarSelectedDisabledIcon);
				volBarBtn.toggle		= true;
				volBarBtn.enabled		= true;
				
				volBarBtn.maxWidth		= volBarWidth	+ volBarGap;
				volBarBtn.maxHeight		= volBarHeight	+ volBarGap;
				_volBarsContainer.addChild(volBarBtn);
				
				/*
				var ct:ColorTransform	= new ColorTransform();
					ct.color			= 0x00FF00;
				volBarBtn.transform.colorTransform		= ct;
				*/
				_volumeBars.push(volBarBtn);
			}
	
				volBarsCanvas.addChild(_volBarsContainer);

				var volBarMask:Sprite	= new Sprite();
					volBarMask.name		= "volBarMask";
					volBarMask.graphics.beginFill(0xFF0000,0);
					volBarMask.graphics.drawRect(0,0,this.width,this.height);
					volBarMask.graphics.endFill();
					_volBarsContainer.mask	= volBarMask;
					volBarsCanvas.addChild(volBarMask);
					

				var mouseTracker:Sprite	= new Sprite();
					mouseTracker.graphics.beginFill(0xFF0000,0);
					mouseTracker.graphics.drawRect(0,0,this.width,this.height);
					mouseTracker.graphics.endFill();
					volBarsCanvas.addChild(mouseTracker);
								
				//set sliding listeners
				if(animated){
					_volBarsContainer.x	= _volBarsContainer.x - (this.width - _volBtn.width);
				
					addEventListener(MouseEvent.MOUSE_OVER, onPluginMouseOver);
					addEventListener(MouseEvent.MOUSE_OUT, onPluginMouseOut);
				}
				
				_volBtn.addEventListener(MouseEvent.CLICK,onVolumeBtnClicked);
				
				volBarsCanvas.addEventListener(MouseEvent.MOUSE_MOVE,onVolBarsMouseMove);
				volBarsCanvas.addEventListener(MouseEvent.MOUSE_OVER,onVolBarsMouseOver);
				volBarsCanvas.addEventListener(MouseEvent.MOUSE_DOWN,onVolBarsMouseClick);
				volBarsCanvas.addEventListener(MouseEvent.MOUSE_OUT,onVolBarsMouseOut);
				
				addChild(volBarsCanvas);
				
				//set volume default;
				_currVolumeIdx	= Math.abs(Math.ceil(_volumeBars.length * initialValue))-1;
				setVolume();
				
		}
		
		protected function onVolBarsMouseOver(e:MouseEvent):void{
			tooltip		= "";
		}
		
		private function onVolumeBtnClicked(e:MouseEvent = null):void{
			if(_volBtn.selected){
				setVolume(0);
				tooltip		= selectedTooltip;
				ToolTipManager.getInstance().destroyToolTip();
				ToolTipManager.getInstance().showToolTip(tooltip, this);
			}else{
				tooltip		= defaultTooltip;
				ToolTipManager.getInstance().destroyToolTip();
				ToolTipManager.getInstance().showToolTip(tooltip, this);
				setVolume();
			}
			
		}
		
		private function onPluginMouseOver(e:MouseEvent):void{
			var ct:ColorTransform	= new ColorTransform();
				ct.color			= color2;
				
				_volBtn.transform.colorTransform	= ct;
			
			Tweener.addTween(_volBarsContainer,{
				x:0,
				time:.5,
				transition:"easeOutQuart"
				});
			
		}

		
		private function onPluginMouseOut(e:MouseEvent):void{
			var ct:ColorTransform	= new ColorTransform();
			ct.color			= color1;
			
			_volBtn.transform.colorTransform	= ct;
			
			
			Tweener.addTween(_volBarsContainer,{
				x:-(this.width - _volBtn.width),
				time:.5,
				transition:"easeOutQuart"
				});
			
		}
		
		private function onVolBarsMouseMove(e:MouseEvent):void{
			var ct:ColorTransform		= new ColorTransform();
			for(var i:int = 0;i<_volumeBars.length;i++){
				(_volumeBars[i] as KButton).enabled		= true;
				ct.color				= volBarActiveColor;
				if((_volumeBars[i] as KButton).x < e.localX){
					ct.color				= volBarActiveColor;
					(_volumeBars[i] as KButton).selected	= false;
				}else{
					ct.color				= volBarInactiveColor;
					(_volumeBars[i] as KButton).enabled		= false;
				}
				if(e.localX > (_volumeBars[i] as KButton).x && e.localX < (_volumeBars[i] as KButton).x+(_volumeBars[i] as KButton).width+horizontalGap){
					ct.color				= volBarActiveColor;
					(_volumeBars[i] as KButton).selected	= true;
				}
				(_volumeBars[i] as KButton).transform.colorTransform	= ct;
			}
		}
		
		private function onVolBarsMouseClick(e:MouseEvent):void{
			_volBtn.selected		= false;
			
			for(var i:int = 0;i<_volumeBars.length;i++){
				if(e.localX > (_volumeBars[i] as KButton).x && 
					e.localX < (_volumeBars[i] as KButton).x+(_volumeBars[i] as KButton).width+horizontalGap){
					_currVolumeIdx	= 	i+1
					setVolume();
					return;
				}
			}
		}
		
		private function setVolume(value:Number	= -1):void{
			var currVolume:Number	= -1;
			var barsToDisplay:Number= -1;
			if(value != -1){
				currVolume	= value;
				barsToDisplay	= _currVolumeIdx*value;
			}else {
				currVolume		= _currVolumeIdx/totalBars;
				barsToDisplay	= _currVolumeIdx;
			}
			_mediator.sendNotification("changeVolume",currVolume);
			displayBars(barsToDisplay);
			
		}

		private function displayBars(value:Number):void{
			var ct:ColorTransform		= new ColorTransform();
			for(var i:int = 0;i<_volumeBars.length;i++){
				(_volumeBars[i] as KButton).enabled		= true;
				ct.color				= volBarActiveColor;
				if(i < (value-1)){
					ct.color				= volBarActiveColor;
					(_volumeBars[i] as KButton).selected	= false;
				}else if(i == (value-1)){
					if(selectedOnOut){
						ct.color				= volBarActiveColor;
						(_volumeBars[i] as KButton).selected	= true;
					}else{ 
						ct.color				= volBarInactiveColor;
						(_volumeBars[i] as KButton).selected	= false;
					}
				}else{
					ct.color				= volBarInactiveColor;
					(_volumeBars[i] as KButton).enabled	= false;
				}
				(_volumeBars[i] as KButton).transform.colorTransform	= ct;
			}
		}
		
		
		private function onVolBarsMouseOut(e:MouseEvent = null):void{
			if(_volBtn.selected){//when selected, set default value and return, don't update bars. 
				tooltip		= selectedTooltip //reinsert tooltip after mouse out.  we clear it on mouse over of volbars canvas.
				onVolumeBtnClicked();
				return;
			}else{
				tooltip		= defaultTooltip //reinsert tooltip after mouse out
			}
			
			displayBars(_currVolumeIdx);
		}
	}
}