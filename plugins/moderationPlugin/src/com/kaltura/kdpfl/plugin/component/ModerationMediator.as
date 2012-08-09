package com.kaltura.kdpfl.plugin.component {
	import com.kaltura.KalturaClient;
	import com.kaltura.commands.MultiRequest;
	import com.kaltura.commands.baseEntry.BaseEntryFlag;
	import com.kaltura.commands.baseEntry.BaseEntryGet;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.vo.KalturaModerationFlag;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class ModerationMediator extends Mediator {

		/**
		 * Mediator name. <br>
		 * The mediator will be registered with this name with the application facade
		 */
		public static const NAME:String = "ModerationMediator";


		public function ModerationMediator(viewComponent:Object = null) {
			this.viewComponent = viewComponent;
			super(NAME, viewComponent);
		}


		/**
		 * This function lists the notifications to which the plugin will respond.
		 * @return 	notifications list
		 */
		override public function listNotificationInterests():Array {
			var notify:Array = [ModerationPlugin.FLAG_FOR_REVIEW];
			return notify;
		}


		/**
		 * This function handles received notifications
		 * @param note		notification
		 */
		override public function handleNotification(note:INotification):void {
//			var data:Object = note.getBody();
			if (note.getName() == ModerationPlugin.FLAG_FOR_REVIEW) {
				mod.showScreen();
			}
		}


		/**
		 * send flagging data to server
		 * */
		public function postModeration(comments:String, type:int):void {
			var mediaProxy:Proxy = (facade.retrieveProxy("mediaProxy") as Proxy);
			var kClient:KalturaClient = facade.retrieveProxy("servicesProxy")["kalturaClient"] as KalturaClient;
			var entryId:String = mediaProxy["vo"]["entry"]["id"];
			var flag:KalturaModerationFlag = new KalturaModerationFlag();
			flag.comments = comments;
			flag.flaggedEntryId = entryId;
			flag.flagType = type;
			var flagCommand:BaseEntryFlag = new BaseEntryFlag(flag);
			flagCommand.addEventListener(KalturaEvent.COMPLETE, moderationComplete);
			flagCommand.addEventListener(KalturaEvent.FAILED, moderationFailed);
			kClient.post(flagCommand);
		}


		/**
		 * notify user success
		 * */
		private function moderationComplete(e:KalturaEvent):void {
			mod.flagComplete(true);
		}

		
		/**
		 * notify user failure
		 * */
		private function moderationFailed(e:KalturaEvent):void {
			mod.flagComplete(false);
		}


		/**
		 * cast the view component to its real type so we
		 * can use type check and autocomplete.
		 * */
		private function get mod():ModerationPlugin {
			return viewComponent as ModerationPlugin;
		}
	}
}