package com.kaltura.kdpfl.plugin.component
{
	//import com.kaltura.kdpfl.component.IComponent;
	
	import com.kaltura.kdpfl.view.containers.KHBox;
	
	import fl.controls.TextInput;
	import fl.data.DataProvider;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;

	public class Search extends Sprite //implements IComponent
	{
		private var searchForm:KHBox = new KHBox();
		private var searchInput:TextInput = new TextInput();  
		private var submitButton : SimpleButton;
		
		private var _paddingLeft:Number = 15;
		private var _paddingTop:Number = 3;
		private var _inputHeight:Number;
		
//		public static const INPUT_PROMPT :String = "Search";
		private var _inputPrompt:String			= "Search";
		public function Search(obj:Object=null)
		{	
			_inputPrompt			= obj.searchBoxLabel;
			var cls:* = getDefinitionByName("searchButtonIcon") as Class;
			submitButton = new cls as SimpleButton;
		  	submitButton.addEventListener(MouseEvent.CLICK, searchSubmit);
			if (obj && obj.hasOwnProperty('inputHeight'))
				_inputHeight = obj.inputHeight;
			if (_inputHeight)
				searchInput.height = _inputHeight;
		 	searchInput.addEventListener(MouseEvent.CLICK, onInputClicked );
			searchInput.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut );
			searchInput.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed );
		  	searchInput.text = _inputPrompt;
		  
		  	if (obj && obj.hasOwnProperty('paddingLeft'))
				_paddingLeft = obj.paddingLeft;
		  	if (obj && obj.hasOwnProperty('paddingTop'))
				_paddingTop = obj.paddingTop;
				
				
		  	searchForm.paddingLeft = _paddingLeft;
			searchForm.paddingTop = _paddingTop;
		  // define dataSource with data array. 
		 // searchForm.dataSource = myFormDataArr;
		  
		  	this.addChild(searchForm);   
					
		}
		
		private function onFocusOut ( e : FocusEvent ) : void
		{
			searchInput.text = _inputPrompt;
			searchInput.removeEventListener( FocusEvent.FOCUS_OUT, onFocusOut );
			searchInput.addEventListener( MouseEvent.CLICK, onInputClicked );
		}
		
		private function onKeyPressed ( e : KeyboardEvent ) : void
		{
			if ((e.keyCode == Keyboard.ENTER) && (searchInput.focusManager.getFocus() == searchInput))
			{
				searchSubmit();
			}
		}
		
		private function onInputClicked (e : MouseEvent ) : void
		{
			if (searchInput.text == _inputPrompt)
			{
				searchInput.text = "";
			}
			searchInput.removeEventListener(MouseEvent.CLICK, onInputClicked );
			searchInput.addEventListener( FocusEvent.FOCUS_OUT, onFocusOut );
		}
		
		private function searchSubmit(mouseClicked:Event=null):void
		{
			var arr:Array = new Array(1);
			arr[0] = {value:searchInput.text};
			(this.parent as SearchPluginCode).searchDataProvider = new DataProvider(arr);

		}			
		public function initialize():void
		{
		}
		
		public function setSkin(skinName:String, setSkinSize:Boolean=false):void
		{
		}
		
		public function constructForm (value : Number) : void
		{
			searchForm.width = value;
			searchForm.addChild(searchInput);
			searchForm.addChild(submitButton);
			searchInput.width = searchForm.parent.width *0.8;
		}
	}
}