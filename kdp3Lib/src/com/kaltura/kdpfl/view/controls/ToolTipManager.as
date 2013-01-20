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
		private var _edgeTolerance:Number	= .1;
		private var _showHook:Boolean		= false;
		private var _hookSize:Number		= 5;
		private var _autoSize:Boolean		= true;
		private var _cornerRadius:Number	= 0;
		private var _hookAlignment:String;
		private var _textBuffer:Number		= 10;
		private var _follow:Boolean			= false;
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
			//Set tooltip parameters
			_dataTip= new ToolTip();
			_dataTip.autoSize		= _autoSize;
			_dataTip.follow			= false;
			_dataTip.hook			= _showHook;
			_dataTip.cornerRadius	= _cornerRadius;
			_dataTip.hookSize		= _hookSize;
			_dataTip.follow			= _follow;
			if (_tooltipHeight)
				_dataTip.tipHeight = _tooltipHeight;
			if (_delay)
				_dataTip.delay = _delay;

			_dataTip.buffer = 		_textBuffer;


			//getting the possition of the stage
			var positionX : int = target.stage.mouseX;
			var targetPoint:Point=new Point(target.x,target.y);

			var rightLimitX : Number = target.root.parent.localToGlobal(new Point(target.root.parent.x, target.root.parent.y) ).x + target.root.parent.width;

			var leftLimitX : Number = target.root.parent.x;


			//find left rail
			var totalTolerancePixels:Number	= target.stage.width * _edgeTolerance;
			if(positionX < totalTolerancePixels)
				_dataTip.align			= "right";
			else if(positionX > (target.stage.width - totalTolerancePixels))
				_dataTip.align			= "left";
			else
				_dataTip.align			= "center";

			//override all settings it set
			if(!_hookAlignment)
				_dataTip.align			= _hookAlignment;


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
			//usage of new tooltip class
			//http://blog.hy-brid.com/flash/25/simple-as3-tooltip/
			if(message!=""){
				//_dataTip.show(_foregroundLayer,message,positionX,positionY,target.stage.width,target.stage.height,null)
				_dataTip.show(_foregroundLayer,message,null, positionX, positionY);
			}

		}

		public function updateTitle(value:String):void{
			if(_dataTip)
				_dataTip.updateTitle(value);
		}

		//tooltips that fall within this percentile to side edges will receive a different hook point.
		//hook values "left, right, center". value in decimals
		public function set edgeTolerance(value : Number):void{
			_edgeTolerance	 = value;
		}

		public function get edgeTolerance():Number{
			return _edgeTolerance;
		}

		public function set textBuffer(value : Number):void{
			_textBuffer	 = value;
		}

		public function get textBuffer():Number{
			return _textBuffer;
		}


		//left, right, center.
		public function set hookAlignment(value : String):void{
			_hookAlignment	 = value;
		}

		public function get hookAlignment():String{
			return _hookAlignment;
		}

		public function set hookSize(value : Number):void{
			_hookSize	 = value;
		}

		public function get hookSize():Number{
			return _hookSize;
		}


		public function set showHook(value:Boolean):void{
			_showHook 		= value;
		}

		public function get showHook():Boolean{
			return _showHook;
		}


		public function set cornerRadius(value:Number):void{
			_cornerRadius 		= value;
		}

		public function get cornerRadius():Number{
			return _cornerRadius;
		}

		public function set autoSize(value:Boolean):void{
			_autoSize 		= value;
		}

		public function get autoSize():Boolean{
			return _autoSize;
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

		public function get follow():Boolean
		{
			return _follow;
		}

		public function set follow(value:Boolean):void
		{
			_follow = value;
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
