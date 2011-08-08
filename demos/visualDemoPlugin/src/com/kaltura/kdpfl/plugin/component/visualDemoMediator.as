package com.kaltura.kdpfl.plugin.component {
	import com.kaltura.kdpfl.model.type.NotificationType;
	
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	/**
	 * This class is the mediator for this plugin. it mediates between this plugin and the 
	 * the KDP application according to the PureMVC framework.
	 * @author Eitan
	 */
	public class visualDemoMediator extends Mediator {
		
		/**
		 * Mediator name. <br>
		 * The mediator will be registered with this name with the application facade
		 */		
		public static const NAME:String = "visualDemoMediator";
		
		
		/**
		 * Constructor.
		 * @param viewComponent		the view component for this mediator
		 * 
		 */
		public function visualDemoMediator(viewComponent:Object = null) {
			this.viewComponent = viewComponent;
			super(NAME,viewComponent);
		}

		
		/**
		 * This function lists the notifications to which the plugin will respond.  
		 * @return 	notifications list
		 * 
		 */
		override public function listNotificationInterests():Array {
			var notify:Array = [NotificationType.PLAYER_UPDATE_PLAYHEAD,
								NotificationType.VOLUME_CHANGED,
								NotificationType.KDP_EMPTY,
								NotificationType.KDP_READY
			];
			return notify;
		}

		
		/**
		 * This function handles received notifications  
		 * @param note		notification
		 * 
		 */
		override public function handleNotification(note:INotification):void {
			var data:Object = note.getBody();
			trace("visualDemoMediator > handleNotification" , note.getName());
			
			switch (note.getName()) {
				case NotificationType.PLAYER_UPDATE_PLAYHEAD:
					trace("new playhead value is : " , data);
				break;
				case NotificationType.VOLUME_CHANGED:
					trace("new volume value is : " , data);
				break;
				case NotificationType.KDP_EMPTY:
				break;
				case NotificationType.KDP_READY:
				break;
			}
		}

		
		/**
		 * visualDemoCode calls this method when it changes plugin size.
		 * If you need to do something when resizing - add it here.
		 * @param w		new width
		 * @param h		new height
		 * 
		 */		
		public function setScreenSize(w:Number, h:Number):void {
			view.width = w;
			view.height = h;
			
		}
		
		
		/**
		 * a reference to this mediator's view component.
		 */		
		public function get view():DisplayObject {
			return viewComponent as DisplayObject;
		}
	}
}