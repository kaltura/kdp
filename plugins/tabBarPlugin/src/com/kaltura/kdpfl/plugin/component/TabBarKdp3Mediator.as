package com.kaltura.kdpfl.plugin.component
{
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class TabBarKdp3Mediator extends Mediator
	{
		public static const NAME:String = "TabBarKdp3Mediator";
		
		public function TabBarKdp3Mediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return  [
					];
		}
		
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				// this means that the main container will be 100% X 100% always
			}
		}
		
		public function get view() : DisplayObject
		{
			return viewComponent as DisplayObject;
		}
		
	}
}