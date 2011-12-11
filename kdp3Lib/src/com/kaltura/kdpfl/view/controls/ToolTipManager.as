package com.kaltura.kdpfl.view.controls
{
	import com.hybrid.ui.ToolTip;
	import com.kaltura.kdpfl.style.TextFormatManager;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	public class ToolTipManager extends Sprite
	{
		private static var _instance:ToolTipManager;
		private var _labelText:TextField;
		private var _foregroundLayer:DisplayObjectContainer;
		private var _timerLapse:int=1000
		private var _timer:Timer=new Timer(_timerLapse,1)
		private var _dataTip:ToolTip;
		private var _zeroPoint : Point = new Point(0,0);
		
		protected var _offsetX : Number = 0;
		protected var _offsetY : Number = 30;
		protected var _tooltipWidth : Number = 100;
		protected var _tooltipHeight : Number;
		//Tooltip delay in milliseconds
		protected var _delay : Number;
		protected var _paddingX : Number = 0;
		
		
		public function ToolTipManager(enforcer:Enforcer){}

        public static function getInstance():ToolTipManager
		{
			if(_instance == null)
				_instance = new ToolTipManager(new Enforcer());

			return _instance;
		}
       
		public function set foregroundLayer(value:DisplayObjectContainer):void
		{
			_foregroundLayer = value;
		}
      
		public function showToolTip(message:String,target:DisplayObject):void
		{
		    //Set the parameters for the tooltip
			_dataTip= new ToolTip();
		    _dataTip.tipWidth= _tooltipWidth;
			
			if (_tooltipHeight)
				_dataTip.tipHeight = _tooltipHeight;
			if (_delay)
				_dataTip.delay = _delay;
			
			_dataTip.buffer = 0;
			//getting the possition of the stage	
			var positionX : int = target.stage.mouseX;
			var targetPoint:Point=new Point(target.x,target.y);
			
			var rightLimitX : Number = target.root.parent.localToGlobal(new Point(target.root.parent.x, target.root.parent.y) ).x + target.root.parent.width;
			
			var leftLimitX : Number = target.root.parent.x;
			
			if (target.parent.localToGlobal(targetPoint).x + _tooltipWidth + offsetX  > rightLimitX)
			{
				positionX = rightLimitX - tooltipWidth + offsetX + paddingX;
			}
			else if (target.parent.localToGlobal(targetPoint).x + offsetX  < leftLimitX)
			{
				//In case of negative offsetX
				positionX = - target.parent.localToGlobal(targetPoint).x - offsetX + paddingX;
			}
			else
			{
				positionX = target.parent.localToGlobal(targetPoint).x + offsetX + paddingX;
			}
			var positionY : int = target.stage.mouseY 
			
			if(target.localToGlobal(targetPoint).y - _offsetY >0)
			{
			   	positionY=(target.localToGlobal(targetPoint).y-_offsetY);
			}
			else
			{
				positionY=(target.localToGlobal(targetPoint).y+_offsetY);
			}	
		    _dataTip.titleFormat = TextFormatManager.getInstance().getTextFormat( "toolTip_label" );
			  
		    if(message!="")
				_dataTip.show(_foregroundLayer,message,positionX,positionY,target.stage.width,target.stage.height,null)	
		}
			     
		public function destroyToolTip():void
		{
			if (_dataTip)
		 		_dataTip.hide()
		}

		public function get offsetX():Number
		{
			return _offsetX;
		}

		public function set offsetX(value:Number):void
		{
			_offsetX = value;
		}

		public function get offsetY():Number
		{
			return _offsetY;
		}

		public function set offsetY(value:Number):void
		{
			_offsetY = value;
		}

		public function get tooltipWidth():Number
		{
			return _tooltipWidth;
		}

		public function set tooltipWidth(value:Number):void
		{
			_tooltipWidth = value;
		}

		public function get tooltipHeight():Number
		{
			return _tooltipHeight;
		}

		public function set tooltipHeight(value:Number):void
		{
			_tooltipHeight = value;
		}

		public function get delay():Number
		{
			return _delay;
		}

		public function set delay(value:Number):void
		{
			_delay = value;
		}

		public function get paddingX():Number
		{
			return _paddingX;
		}

		public function set paddingX(value:Number):void
		{
			_paddingX = value;
		}


	}
}

class Enforcer{}
        