package {
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.Shortcuts508;
	import com.kaltura.kdpfl.plugin.component.Shortcuts508Mediator;
	import com.kaltura.kdpfl.view.controls.KButton;
	
	import fl.core.UIComponent;
	
	import org.puremvc.as3.interfaces.IFacade;

	public class Shortcuts508PluginCode extends UIComponent implements IPlugin
	{
		private var _disableShortcuts : Boolean = false;
		
		private var _shortcuts508Mediator : Shortcuts508Mediator;
		private var _backBtn:KButton;
		private var _backBtnName:String;
		private var _fwdBtn:KButton;
		private var _fwdBtnName:String;
		private var _playBtn:KButton;
		private var _playBtnName:String;
		private var _muteBtn:KButton;
		private var _muteBtnName:String;
		private var _volDownBtn:KButton;
		private var _volDownBtnName:String;
		private var _volUpBtn:KButton;
		private var _volUpBtnName:String;
		private var _fsBtn:KButton;
		private var _fsBtnName:String;
		private var _ccBtn:KButton;
		private var _ccBtnName:String;
		private var _adBtn:KButton;
		private var _adBtnName:String;
		
		/**
		 * Constructor 
		 * 
		 */		
		public function Shortcuts508PluginCode()
		{
		}

		/**
		 *  
		 * @param facade
		 * 
		 */		
		public function initializePlugin( facade : IFacade ) : void
		{
			_backBtn = facade ["bindObject"][_backBtnName] as KButton;
			_fwdBtn = facade ["bindObject"][_fwdBtnName] as KButton;
			_playBtn = facade ["bindObject"][_playBtnName] as KButton;
			_muteBtn = facade ["bindObject"][_muteBtnName] as KButton;
			_volDownBtn = facade ["bindObject"][_volDownBtnName] as KButton;
			_volUpBtn = facade ["bindObject"][_volUpBtnName] as KButton;
			_fsBtn = facade ["bindObject"][_fsBtnName] as KButton;
			_ccBtn = facade ["bindObject"][_ccBtnName] as KButton;
			_adBtn = facade ["bindObject"][_adBtnName] as KButton;
			// Register Proxy
			//facade.retrieveProxy(
			
			// Register Mideator
			_shortcuts508Mediator = new Shortcuts508Mediator( new Shortcuts508() );
			_shortcuts508Mediator.setButtons (_playBtn, _backBtn, _fwdBtn, _muteBtn, _volDownBtn, _volUpBtn, _fsBtn, _ccBtn, _adBtn);
			facade.registerMediator( _shortcuts508Mediator);
			addChild( _shortcuts508Mediator.view );
			_shortcuts508Mediator.added ();
		}
		
 		public function setSkin(styleName:String, setSkinSize:Boolean=false):void{}
		
		public function get attributeShortcuts508() : String
		{
			return attributeShortcuts508;
		}
		
		[Bindable]
		public function set backBtn(value:String):void
		{
			_backBtnName = value;
		}

		public function get backBtn():String
		{
			return _backBtnName;
		}
		
		[Bindable]
		public function set fwdBtn(value:String):void
		{
			_fwdBtnName = value;
		}

		public function get fwdBtn():String
		{
			return _fwdBtnName;
		}
		
		[Bindable]
		public function set playBtn(value:String):void
		{
			_playBtnName = value;
		}

		public function get playBtn():String
		{
			return _playBtnName;
		}
		
		[Bindable]
		public function set muteBtn(value:String):void
		{
			_muteBtnName = value;
		}

		public function get muteBtn():String
		{
			return _muteBtnName;
		}
		
		[Bindable]
		public function set volDownBtn(value:String):void
		{
			_volDownBtnName = value;
		}

		public function get volDownBtn():String
		{
			return _volDownBtnName;
		}
		
		[Bindable]
		public function set volUpBtn(value:String):void
		{
			_volUpBtnName = value;
		}

		public function get volUpBtn():String
		{
			return _volUpBtnName;
		}
		
		[Bindable]
		public function set fsBtn(value:String):void
		{
			_fsBtnName = value;
		}

		public function get fsBtn():String
		{
			return _fsBtnName;
		}
		
		[Bindable]
		public function set ccBtn(value:String):void
		{
			_ccBtnName = value;
		}

		public function get ccBtn():String
		{
			return _ccBtnName;
		}
		
		[Bindable]
		public function set adBtn(value:String):void
		{
			_adBtnName = value;
		}

		public function get adBtn():String
		{
			return _adBtnName;
		}
		
		[Bindable]
		public function get disableShortcuts():Boolean
		{
			return _disableShortcuts;
		}

		public function set disableShortcuts(value:Boolean):void
		{
			_disableShortcuts = value;
			if (_shortcuts508Mediator.view)
			{
				(_shortcuts508Mediator.view as Shortcuts508).disableShortcuts = value;
			}
		}

	}
}
