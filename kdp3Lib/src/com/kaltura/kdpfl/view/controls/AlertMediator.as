package com.kaltura.kdpfl.view.controls
{
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.LayoutProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.style.TextFormatManager;
	import com.kaltura.kdpfl.view.containers.KCanvas;
	import com.yahoo.astra.fl.events.AlertEvent;
	import com.yahoo.astra.fl.managers.AlertManager;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.facade.Facade;
	import org.puremvc.as3.patterns.mediator.Mediator;
	/**
	 * This class handles presenting KDP alerts to the user. 
	 * @author Hila
	 * 
	 */
	public class AlertMediator extends Mediator
	{
		public static const NAME:String = "AlertMediator";
		
		private var alertTimer : Timer;
		
		private var alertStylesApplied : Boolean = false;
		
		//Changeable parameters in the alerts
		protected var _messageFont : String;
		protected var _titleFont : String;
		protected var _titleFontSize : Number;
		protected var _messageFontSize : Number;
		protected var _titleFontColor : Number;
		protected var _messageFontColor : Number;
		protected var _buttonLabelFont : String;
		protected var _buttonLabelColor : Number;
		protected var _buttonLabelSize : Number;
		protected var _showButtonIfEmpty : String = "true";
		protected var _alertPadding : Number;
		protected var _maxWidth : Number;
		protected var _minWidth : Number;
		protected var _alertRemovalDelay : Number;
		
		/**
		 * Constructor 
		 * @param viewComponent the viewComponent for the AlertMedaitor
		 * 
		 */
		public function AlertMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
		}
		
		
		override public function listNotificationInterests():Array
		{
			return  [
						NotificationType.ALERT,
						NotificationType.REMOVE_ALERTS,
						NotificationType.CANCEL_ALERTS,
						NotificationType.LAYOUT_READY
					];
		}
		
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case NotificationType.LAYOUT_READY:
					styleAlert();
					alertStylesApplied = true;
					break;
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
						if (!alertStylesApplied)
							styleAlert();
						if(note.getBody() && note.getBody().message && note.getBody().title)
							AlertManager.createAlert(foreground,note.getBody().message,note.getBody().title, note.getBody().buttons, note.getBody().callbackFunction, note.getBody().iconClass, note.getBody().isModal != null ? note.getBody().isModal : true , note.getBody().props );
			            
						
						if (alertRemovalDelay)
						{
							alertTimer = new Timer(alertRemovalDelay*1000, 1);
							alertTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onAlertTimerComplete);
							AlertManager.getInstance().addEventListener( AlertEvent.ALERT_REMOVED, onAlertClosedByUser);
							alertTimer.start();
						}
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
		
		private function onAlertTimerComplete (e : TimerEvent) : void
		{
			alertTimer.stop();
			alertTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onAlertTimerComplete );
			AlertManager.getInstance().manageQueue();
		}
		
		private function onAlertClosedByUser (e : Event) : void
		{
			alertTimer.stop();
			alertTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onAlertTimerComplete );
		}
		/**
		 * Set the visual assets of the alert - font color, font size, padding, width, etc.
		 * 
		 */		
		private function styleAlert () : void
		{
			var tfManager:TextFormatManager = TextFormatManager.getInstance();
			var titleTextFormat:TextFormat = tfManager.getTextFormat("alertTitleLabel");
			titleTextFormat.font = _titleFont ? _titleFont : titleTextFormat.font;
			titleTextFormat.color = _titleFontColor ? _titleFontColor : titleTextFormat.color;
			titleTextFormat.size = _titleFontSize ? _titleFontSize : titleTextFormat.size;
			var bodyTextFormat:TextFormat = tfManager.getTextFormat("alertBodyText");
			bodyTextFormat.font = _messageFont ? _messageFont : bodyTextFormat.font;
			bodyTextFormat.color = _messageFontColor ? _messageFontColor : bodyTextFormat.color;
			bodyTextFormat.size = _messageFontSize ? _messageFontSize : bodyTextFormat.size;
			var buttonTextFormat:TextFormat = tfManager.getTextFormat("alertButtonLabel");
			buttonTextFormat.font = _buttonLabelFont ? _buttonLabelFont : buttonTextFormat.font;
			buttonTextFormat.color = _buttonLabelColor ? _buttonLabelColor : buttonTextFormat.color;
			buttonTextFormat.size = _buttonLabelSize ? _buttonLabelSize : buttonTextFormat.size;
			AlertManager.setTitleBarStyle("textFormat", titleTextFormat);
			AlertManager.setButtonStyle("textFormat", buttonTextFormat);
			AlertManager.setMessageBoxStyle("textFormat", bodyTextFormat);
			AlertManager.setButtonStyle("upSkin", "Button_upSkin_alert");
			AlertManager.setButtonStyle("overSkin", "Button_overSkin_alert");
			AlertManager.setButtonStyle("downSkin", "Button_downSkin_alert");
			AlertManager.setButtonStyle("focusRectSkin", "Button_focusRect_alert");
			AlertManager.showButtonIfEmpty = (showButtonIfEmpty == "true") ? true : false;
			AlertManager.padding = alertPadding ? alertPadding : AlertManager.padding ;
			AlertManager.minWidth = minWidth ? minWidth : AlertManager.minWidth;
			AlertManager.maxWidth = maxWidth ? maxWidth : AlertManager.maxWidth;
		}
		/**
		 * the font for the alert's message.
		 * @return 
		 * 
		 */		
		public function get messageFont():String
		{
			return _messageFont;
		}

		public function set messageFont(value:String):void
		{
			_messageFont = value;
		}
		/**
		 * the font for the alert's title.
		 * @return 
		 * 
		 */
		public function get titleFont():String
		{
			return _titleFont;
		}

		public function set titleFont(value:String):void
		{
			_titleFont = value;
		}
		/**
		 * font size for the alert's title
		 * @return 
		 * 
		 */
		public function get titleFontSize():Number
		{
			return _titleFontSize;
		}

		public function set titleFontSize(value:Number):void
		{
			_titleFontSize = value;
		}
		/**
		 * font size for the alert's message
		 * @return 
		 * 
		 */
		public function get messageFontSize():Number
		{
			return _messageFontSize;
		}

		public function set messageFontSize(value:Number):void
		{
			_messageFontSize = value;
		}
		/**
		 * text color for the alert's title
		 * @return 
		 * 
		 */
		public function get titleFontColor():Number
		{
			return _titleFontColor;
		}

		public function set titleFontColor(value:Number):void
		{
			_titleFontColor = value;
		}
		/**
		 * text color for the alert's message.
		 * @return 
		 * 
		 */
		public function get messageFontColor():Number
		{
			return _messageFontColor;
		}

		public function set messageFontColor(value:Number):void
		{
			_messageFontColor = value;
		}
		/**
		 * font for the alert's button labels.
		 * @return 
		 * 
		 */
		public function get buttonLabelFont():String
		{
			return _buttonLabelFont;
		}

		public function set buttonLabelFont(value:String):void
		{
			_buttonLabelFont = value;
		}
		/**
		 * color for the alert's button label texts.
		 * @return 
		 * 
		 */
		public function get buttonLabelColor():Number
		{
			return _buttonLabelColor;
		}

		public function set buttonLabelColor(value:Number):void
		{
			_buttonLabelColor = value;
		}
		/**
		 * size for the alert's button label texts.
		 * @return 
		 * 
		 */
		public function get buttonLabelSize():Number
		{
			return _buttonLabelSize;
		}

		public function set buttonLabelSize(value:Number):void
		{
			_buttonLabelSize = value;
		}
		/**
		 * flag indicating whether the default OK button should be shown if no buttons array was specified on the ALERT notification body.
		 * @return 
		 * 
		 */
		public function get showButtonIfEmpty():String
		{
			return _showButtonIfEmpty;
		}

		public function set showButtonIfEmpty(value:String):void
		{
			_showButtonIfEmpty = value;
		}
		/**
		 * controls the padding of the alert - this refers to the bottom, top, left and right padding, as the Astra DialogBox component does not offer individual padding values to set.
		 * @return 
		 * 
		 */
		public function get alertPadding():Number
		{
			return _alertPadding;
		}

		public function set alertPadding(value:Number):void
		{
			_alertPadding = value;
		}
		/**
		 * controls the maximum possible width of the alert.
		 * @return 
		 * 
		 */
		public function get maxWidth():Number
		{
			return _maxWidth;
		}

		public function set maxWidth(value:Number):void
		{
			_maxWidth = value;
		}
		/**
		 * controls the minimal possible width of the alert.
		 * @return 
		 * 
		 */
		public function get minWidth():Number
		{
			return _minWidth;
		}

		public function set minWidth(value:Number):void
		{
			_minWidth = value;
		}
		/**
		 * controls the number of seconds allowed to pass before the alert is removed automatically.
		 * @return 
		 * 
		 */	
		public function get alertRemovalDelay():Number
		{
			return _alertRemovalDelay;
		}

		public function set alertRemovalDelay(value:Number):void
		{
			_alertRemovalDelay = value;
		}

		
	}
}