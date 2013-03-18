package {
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	import com.kaltura.kdpfl.plugin.component.AssetsRefferencer;
	import com.kaltura.kdpfl.plugin.component.ModerationMediator;
	import com.kaltura.kdpfl.plugin.view.Message;
	import com.kaltura.kdpfl.plugin.view.ModerationScreen;
	import com.kaltura.kdpfl.view.containers.KHBox;
	import com.kaltura.types.KalturaModerationFlagType;
	import com.yahoo.astra.fl.containers.HBoxPane;
	import com.yahoo.astra.fl.containers.layoutClasses.AdvancedLayoutPane;
	import com.yahoo.astra.fl.containers.layoutClasses.BaseLayoutPane;
	
	import fl.containers.BaseScrollPane;
	import fl.core.UIComponent;
	
	import flash.events.Event;
	import flash.system.Security;
	
	import org.puremvc.as3.interfaces.IFacade;

	public class ModerationPlugin extends KHBox implements IPluginFactory, IPlugin {
		
		
		/**
		 * defines the value for the type property of the submit event
		 * dispatched by the screen  
		 */		
		public static const SUBMIT:String = "submit";
		
		/**
		 * defines the value for the type property of the cancel event  
		 * dispatched by the screen  
		 */		
		public static const CANCEL:String = "cancel";
		
		/**
		 * defines the value of the notification which triggers this plugin 
		 */		
		public static const FLAG_FOR_REVIEW:String = "flagForReview";
		
		
		/**
		 * flagging form header 
		 */		
		public var header:String;
		
		/**
		 * flagging form text (explanation) 
		 */		
		public var text:String;
		
		/**
		 * text to show in combobox for sexual content 
		 */		
		public var reasonSex:String = "Sexual content";
		
		/**
		 * text to show in combobox for violent content 
		 */		
		public var reasonViolence:String = "Violent or Repulsive";
		
		/**
		 * text to show in combobox for harmful content 
		 */		
		public var reasonHarmful:String = "Harmful or Dangerous act";
		
		/**
		 * text to show in combobox for spam content 
		 */		
		public var reasonSpam:String = "Spam/Commercials";
		
		/**
		 * message to show when flagging submition succeeded 
		 */		
		public var successMessage:String = "Thank you for sharing your concerns";
		
		/**
		 * message to show when flagging submition failed
		 * */
		public var failedMessage:String = "submission failed";
		
		/**
		 * time (in seconds) to wait before hiding end message 
		 */		
		public var hideTimeout:int = 3;
		
		/**
		 * position of close and cancel buttons on flagging form
		 */
		public var buttonsPosition:String = "right";
		/**
		 * If this is set to flase, the "select report reason" combo-box will be hidden
		 */
		public var showCombo:Boolean = true;
		/**
		 * This attribute will set the initial selected value of the combobox: 
		 * 0: Sexual content
		 * 1: Violent or Repulsive
		 * 2: Harmful or Dangerous act
		 * 3: Spam/Commercials
		 */
		public var comboSelectedIndex:Number = 0;
		/**
		 * include the assets class in the app
		 * */
		private var _ar:AssetsRefferencer;
		
		/**
		 * flagging form 
		 */		
		private var _ui:ModerationScreen;
		
		/**
		 * success / failure message 
		 */		
		private var _endMsg:Message;
		
		/**
		 * plugin mediator  
		 */		
		private var _mediator:ModerationMediator;
		
		
		
		public function ModerationPlugin() {
			Security.allowDomain("*");
			this.horizontalAlign = "center";
			this.verticalAlign = "middle";
		}

		
		/**
		 * @inheritDoc	
		 * */
		public function create(pluginName:String = null):IPlugin {
			return this;
		}


		/**
		 * @inheritDoc
		 * */
		public function initializePlugin(facade:IFacade):void {
			_mediator = new ModerationMediator(this);
			facade.registerMediator(_mediator);
			
		}


		/**
		 * set the given style to all visual parts
		 * */
		override public function setSkin(styleName:String, setSkinSize:Boolean = false):void {
			if (_ui) {
				_ui.setSkin(styleName);
			}
			if (_endMsg) {
				_endMsg.setSkin(styleName);
			}
		}

		/**
		 * shows the moderation ui over the player
		 * */
		public function showScreen():void {
			// disable KDP gui, stop entry from playing, exit fullscreen 
			_mediator.sendNotification(NotificationType.CLOSE_FULL_SCREEN);
			_mediator.sendNotification(NotificationType.ENABLE_GUI, {guiEnabled : false, enableType : "full"});
			_mediator.sendNotification(NotificationType.DO_PAUSE);
			
			// show flagging form
			if (_ui == null) {
				_ui = new ModerationScreen();
				_ui.buttonsPosition = buttonsPosition;
				if (header) {
					_ui.headerText = header;
				}
				if (text) {
					_ui.windowText = text;
				}
				
				_ui.reasonsDataProvider = [{label:reasonSex, type:KalturaModerationFlagType.SEXUAL_CONTENT}, 
									{label:reasonViolence, type:KalturaModerationFlagType.VIOLENT_REPULSIVE}, 
									{label:reasonHarmful, type:KalturaModerationFlagType.HARMFUL_DANGEROUS}, 
									{label:reasonSpam, type:KalturaModerationFlagType.SPAM_COMMERCIALS}]
				//set custom behaviour for reasons combo 
				_ui.comboSelectedIndex = comboSelectedIndex;
				
				_ui.showCombo = showCombo;
				
				_ui.addEventListener(ModerationPlugin.CANCEL, clearForm);
				_ui.addEventListener(ModerationPlugin.SUBMIT, onSubmitClicked);
			}
			addChild(_ui);
		}
		
		
		/**
		 * send data to server 
		 */		
		private function onSubmitClicked(e:Event):void {
			var o:Object = _ui.data;
			var comments:String = o.comments;
			var type:int = o.reason;
			_mediator.postModeration(comments, type);
		}
		
		
		/**
		 * close the form panel 
		 */		
		private function clearForm(e:Event = null):void {
			_ui.clearData();
			removeChild(_ui);
			end();
		}
		
		
		/**
		 * remove the end message 
		 * @param e
		 */		
		private function onMessageHide(e:Event):void {
			removeChild(_endMsg);
			end();
		}
		
		
		/**
		 * does everything that needs to be done before the plugin is closed
		 */ 
		private function end():void {
			_mediator.sendNotification(NotificationType.ENABLE_GUI, {guiEnabled : true, enableType : "full"});
		}
		
		/**
		 * notify the user and close panel
		 * */
		public function flagComplete(success:Boolean):void {
			clearForm();
			if (_endMsg == null) {
				_endMsg = new Message();
				_endMsg.addEventListener(Message.HIDE, onMessageHide);
			}
			if (success) {
				_endMsg.windowText = successMessage;
			}
			else {
				_endMsg.windowText = failedMessage;
			}
			addChild(_endMsg);
			_endMsg.close(hideTimeout);
		}
	}
}