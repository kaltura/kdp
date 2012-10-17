package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.view.controls.KButton;
	
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class Shortcuts508Mediator extends Mediator
	{
		public static const NAME:String = "shortcuts508Mediator";
		
		private var _shortcutsMap : Object;

		public function Shortcuts508Mediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return  [
						NotificationType.LAYOUT_READY
					];
		}
		
		override public function handleNotification(note:INotification):void
		{
			var eventName:String = note.getName();
			var data:Object = note.getBody();
			var media : Object = facade.retrieveProxy("mediaProxy");
			var entry:String = media["vo"]["entry"]["id"];			

			switch (eventName)
			{
				// this means that the main container will be 100% X 100% always
				case NotificationType.LAYOUT_READY:
					setButtons();
					break;
			}
		}
		

		
	
		
		
		

		public function setButtons():void
		{
			var stage : Stage = (viewComponent as Shortcuts508PluginCode).stage;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_shortcutsMap = new Object();
			for (var prop : String in (viewComponent as Shortcuts508PluginCode))
			{
				if (prop.indexOf("kbtn_") != -1)
				{
					_shortcutsMap[(viewComponent as Shortcuts508PluginCode)[prop]] = prop.replace("kbtn_", "");
				}
			}
		}
		
		private function onKeyDown (e : KeyboardEvent) : void
		{
			if (_shortcutsMap[e.keyCode.toString()] && !(viewComponent as Shortcuts508PluginCode).disableShortcuts)
			{
				( facade["bindObject"][_shortcutsMap[e.keyCode.toString()]] as UIComponent).setFocus();
				(facade["bindObject"][_shortcutsMap[e.keyCode.toString()]] as UIComponent).dispatchEvent(new MouseEvent(MouseEvent.CLICK) );
			}
		}
		
		
	}
}