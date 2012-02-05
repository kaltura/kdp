package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.BlackScreenMediator;
	
	import fl.core.UIComponent;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	public class BlackScreenPluginCode extends UIComponent implements IPlugin
	{

		protected var _clipStartTime : Number = -1;
		
		protected var _clipEndTime : Number = -1;
		
		protected var _blackLayer : Sprite;
		
		protected var _mediator : BlackScreenMediator;
		
		public function BlackScreenPluginCode()
		{
			Security.allowDomain("*");
		}
		
		public function initializePlugin(facade:IFacade):void
		{
			_blackLayer = new Sprite();
			_blackLayer.graphics.beginFill(0x000000);
			_blackLayer.graphics.drawRect(0,0,10,10);
			_blackLayer.graphics.endFill();
			this.addChild(_blackLayer);
			_blackLayer.width = this.width;
			_blackLayer.height = this.height;
			_blackLayer.visible = false;
			
			_mediator = new BlackScreenMediator(null, this );
			facade.registerMediator( _mediator );
		}
		
		public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
		}
		
		[Bindable]
		public function get clipStartTime():Number
		{
			return _clipStartTime;
		}

		public function set clipStartTime(value:Number):void
		{
			if (value != -1)
			{
				_clipStartTime = value;
			}
		}

		[Bindable]
		public function get clipEndTime():Number
		{
			return _clipEndTime;
		}

		public function set clipEndTime(value:Number):void
		{
			if (value != -1)
			{
				_clipEndTime = value;
			}
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			if (_blackLayer)
			{
				_blackLayer.width = value;
			}
			
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			if (_blackLayer)
			{
				_blackLayer.height = value;
			}
		}
		
		public function showBlackLayer() : void
		{
			if (_blackLayer)
			{
				_blackLayer.visible = true;
			}
		}
		
		public function hideBlackLayer() : void
		{
			if (_blackLayer)
			{
				_blackLayer.visible = false;
			}
		}


	}
}