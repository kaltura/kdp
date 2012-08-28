package com.kaltura.kdpfl.plugin
{
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.interfaces.INotification;
	
	/**
	 * Class PPTWidgetScreenMediator listens for slides loading events and sets the view accordingly
	 * @author Michal
	 * 
	 */	
	public class PPTWidgetScreenMediator extends Mediator
	{
		
		/**
		 * mediator name
		 */
		public static const NAME:String = "PPTWidgetScreenMediator";
		/**
		 * plugin code
		 * */
		private var _view:PPTWidgetScreenPluginCode;
		
		/**
		 * Constructor
		 * @param viewComponent	view component
		 */
		public function PPTWidgetScreenMediator(viewComponent:Object = null) {
			super(NAME, viewComponent);
			_view = viewComponent as PPTWidgetScreenPluginCode;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function handleNotification(note:INotification):void {
			switch (note.getName())
			{
				case "changeVideoPresentation":
					_view.isLoading = true;
					break;
				case "slidesLoaded":
					_view.isLoading = false;
					break;
			}
		}
		
		
		/**
		 * @inheritDoc
		 */
		override public function listNotificationInterests():Array {
			return [
				"changeVideoPresentation",
				"slidesLoaded"
			];
		}
	}
}