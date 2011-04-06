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
			//getting the possition of the stage	
			var positionX : int = target.stage.mouseX;
			var targetPoint:Point=new Point(target.x,target.y);
			
			if(positionX<(target.stage.localToGlobal(targetPoint).x)+ target.width)
			     positionX=((target.stage.localToGlobal(targetPoint).x)+ target.width)+5
			
			if(positionX>target.stage.stageWidth-100)
			     positionX=target.stage.stageWidth-105;
			     
			var positionY : int = target.stage.mouseY 
			
			if(positionY>target.localToGlobal(targetPoint).y)
			   positionY=(target.localToGlobal(targetPoint).y-30);
			   
			 if(positionY>target.stage.stageHeight-60)
			    positionY=target.stage.stageHeight-60
			
		    _dataTip= new ToolTip();
		    _dataTip.tipWidth=100;
		    _dataTip.alpha=0;
		    _dataTip.buffer=0;
		    _dataTip.titleFormat = TextFormatManager.getInstance().getTextFormat( "toolTip_label" );
			  
		    if(message!="")
				_dataTip.show(_foregroundLayer,message,positionX,positionY,target.stage.width,target.stage.height,null)	
		}
			     
		public function destroyToolTip():void
		{
			if (_dataTip)
		 		_dataTip.hide()
		}
	}
}

class Enforcer{}
        