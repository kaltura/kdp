package com.kaltura
{
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.plugin.IPlugin;
	
	import fl.core.UIComponent;
	
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	public class cuePointPluginCode extends UIComponent implements IPlugin
	{
		
		private var _cuePointContainer : CuePointContainer;
		private var _cuePointArray : Array;
		private var _cuePointMediator : CuePointMediator;
		private var _entryDuration : Number;
		
		public function cuePointPluginCode()
		{
			super();
		}
		
		public function initializePlugin(facade:IFacade):void
		{
			_cuePointContainer = new CuePointContainer();
			addChild(_cuePointContainer);
			_cuePointMediator = new CuePointMediator(null, this);
			facade.registerMediator(_cuePointMediator);
			this.addEventListener(MouseEvent.CLICK, onCuePointClick );
			
		}
		
		public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
		}
		
		[Bindable]
		public function get cuePointArray():Array { return _cuePointArray; }
		public function set cuePointArray(value:Array):void 
		{ 
			_cuePointArray = value; 
		}

		public function get cuePointContainer():CuePointContainer { return _cuePointContainer; }
		public function set cuePointContainer(value:CuePointContainer):void { _cuePointContainer = value; }
		
		public function set entryDuration (value:Number) : void { _entryDuration = value;}
		public function get entryDuration () : Number { return _entryDuration; }

		override public function set width(value:Number):void
		{
			super.width = value;
			_cuePointContainer.width = value;
		}
		override public function set height(value:Number):void
		{
			super.height = value;
			_cuePointContainer.height = value;
		}
		
		public function addCuePoints () : void
		{
			_cuePointContainer.addCuePoints(_cuePointArray, _entryDuration);
		}
		public function cleanCuePoints () : void
		{
			_cuePointContainer.cleanCuePoints ();
		}
		
		private function onCuePointClick (e : MouseEvent) : void
		{
			var cuePoint : CuePoint = e.target as CuePoint;
			
			_cuePointMediator.sendNotification(NotificationType.DO_SEEK, cuePoint.cuePointTime/1000 );
		}
		
	}
}