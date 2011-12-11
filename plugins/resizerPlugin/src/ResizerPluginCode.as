package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.ResizerMediator;
	import com.kaltura.kdpfl.view.controls.KSlider;
	
	import fl.controls.SliderDirection;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	import fl.events.SliderEvent;
	
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	public class ResizerPluginCode extends UIComponent implements IPlugin
	{
		public static const RESIZE_MODE_VERTICAL : String = "vertical";
		
		public static const RESIZE_MODE_HORIZONTAL : String = "horizontal";
		
		protected var _resizerMediator : ResizerMediator;
		
		protected var _resizeTarget : UIComponent;
		
		protected var _relativeTo : UIComponent;
		
		protected var _resizeMode : String;
		
		protected var _minimumValue : Number;
		
		protected var _maximumValue : Number;
		
		protected var _sliderBackground:DisplayObject;
		
		protected var _slider : KSlider;
		
		[Bindable]
		public var color1 : Number;
		[Bindable]
		public var color2 : Number;
		[Bindable]
		public var color3 : Number;
		
			
	
		
		public function ResizerPluginCode()
		{
			super();
		}
		
		public function initializePlugin(facade:IFacade):void
		{
			//register mediator
			_resizerMediator = new ResizerMediator (null, this);
			facade.registerMediator( _resizerMediator );
			// initialize the component attributes
			_slider = new KSlider;
			this.addChild( _slider );
			_slider.snapInterval = 0.05;
			_slider.maximum = 1;
			_slider.minimum = 0;
			_slider.liveDragging = true;
			
			try{
				this.setStyle( "thumbUpSkin" , "VolumeBar_sliderThumbUp_default" );
				
			}
			catch (e : Error)
			{
				
			}
			
			if (resizeMode == RESIZE_MODE_HORIZONTAL)
			{
				_minimumValue = _resizeTarget.width;
				_maximumValue = stage.stageWidth;
				_slider.direction = SliderDirection.HORIZONTAL;
			}
			else if (resizeMode == RESIZE_MODE_VERTICAL )
			{
				_minimumValue = _resizeTarget.height;
				_maximumValue = stage.stageHeight;
				_slider.direction = SliderDirection.VERTICAL;
			}
			
			
			_slider.addEventListener(SliderEvent.CHANGE , onSliderChange );
			
		}
		
		
		
		private function onSliderChange (e : SliderEvent ) : void
		{
			
			if (_relativeTo)
			{
				if (_relativeTo["configuration"])
				{
					var newConfig : Array = (_relativeTo["configuration"] as Array).concat();
					for each(var configObject : Object in newConfig)
					{
						if (configObject.target.name == _resizeTarget.name)
						{
							if (resizeMode == RESIZE_MODE_HORIZONTAL)
							{
								configObject.percentWidth = ((_minimumValue + (_maximumValue - _minimumValue)*_slider.value)/_maximumValue)*100;
							}
							else
							{
								configObject.percentHeight = ((_minimumValue + (_maximumValue - _minimumValue)*_slider.value)/_maximumValue)*100;
							}
						}
						else
						{
							if (resizeMode == RESIZE_MODE_HORIZONTAL)
							{
								configObject.percentWidth =((_maximumValue - _minimumValue - (_maximumValue - _minimumValue)*_slider.value)/_maximumValue * 100)/(newConfig.length - 1);
							}
							else
							{
								configObject.percentHeight = ((_maximumValue - _minimumValue - (_maximumValue - _minimumValue)*_slider.value)/_maximumValue * 100)/(newConfig.length - 1);
							}
						}
					}
					
					_relativeTo["configuration"] = newConfig;
				}
			}
			else
			{
				if (resizeMode == RESIZE_MODE_HORIZONTAL)
				{
					_resizeTarget.width = _minimumValue + (_maximumValue - _minimumValue)*_slider.value;
				}
				else
				{
					_resizeTarget.height = _minimumValue + (_maximumValue - _minimumValue)*_slider.value;
				}
			}
		}
		
		
		
	
		

		
		public function setSkin(skinName:String, setSkinSize:Boolean=false):void
		{
			
		}

		
		[Bindable]
		public function get resizeTarget():UIComponent
		{
			return _resizeTarget;
		}

		public function set resizeTarget(value:UIComponent):void
		{
			_resizeTarget = value;
		}
		[Bindable]
		public function get relativeTo():UIComponent
		{
			return _relativeTo;
		}

		public function set relativeTo(value:UIComponent):void
		{
			_relativeTo = value;
		}
		[Bindable]
		public function get resizeMode():String
		{
			return _resizeMode;
		}

		public function set resizeMode(value:String):void
		{
			_resizeMode = value;
		}


	}
}