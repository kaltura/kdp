package com.kaltura.kdpfl.view.controls
{
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.LayoutProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.style.TextFormatManager;
	import com.kaltura.kdpfl.view.containers.KCanvas;
	import com.yahoo.astra.fl.managers.AlertManager;
	
	import flash.display.DisplayObject;
	import flash.text.TextFormat;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.facade.Facade;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class AlertMediator extends Mediator
	{
		public static const NAME:String = "AlertMediator";
		

		public function AlertMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
		}
		
		override public function listNotificationInterests():Array
		{
			return  [
						NotificationType.ALERT,
						NotificationType.REMOVE_ALERTS,
						NotificationType.CANCEL_ALERTS
					];
		}
		
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case NotificationType.ALERT:
				
				    var flashvars:Object = (facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy).vo.flashvars;
		            var disableAlerts:String = flashvars.disableAlerts;
		            var _disabled:Boolean;
		            if(disableAlerts=="true"){
		            	_disabled=true
		            }
		            if(!_disabled){
						var layoutProxy:LayoutProxy = Facade.getInstance().retrieveProxy( LayoutProxy.NAME ) as LayoutProxy;
						var foreground:KCanvas = layoutProxy.vo.foreground;
						// styling:
						
						var tfManager:TextFormatManager = TextFormatManager.getInstance();
						var titleTextFormat:TextFormat = tfManager.getTextFormat("alertTitleLabel");
						var bodyTextFormat:TextFormat = tfManager.getTextFormat("alertBodyText");
						var buttonTextFormat:TextFormat = tfManager.getTextFormat("alertButtonLabel");
						AlertManager.setTitleBarStyle("textFormat", titleTextFormat);
						AlertManager.setButtonStyle("textFormat", buttonTextFormat);
						AlertManager.setMessageBoxStyle("textFormat", bodyTextFormat);
						AlertManager.setButtonStyle("upSkin", "Button_upSkin_alert");
						AlertManager.setButtonStyle("overSkin", "Button_overSkin_alert");
						AlertManager.setButtonStyle("downSkin", "Button_downSkin_alert");
						AlertManager.setButtonStyle("focusRectSkin", "Button_focusRect_alert");
						//pop up an alert
						if(note.getBody() && note.getBody().message && note.getBody().title)
							AlertManager.createAlert(foreground,note.getBody().message,note.getBody().title, note.getBody().buttons, note.getBody().callbackFunction );
		            }
				break;
				case NotificationType.REMOVE_ALERTS:
				     _disabled=false;
					 AlertManager.getInstance().manageQueue();
				break;
				case NotificationType.CANCEL_ALERTS:
				     _disabled=true;
				break;
				  
			}

		}
		
		public function get view() : DisplayObject
		{
			return viewComponent as DisplayObject;
		}
		
	}
}