package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.model.vo.AddThisEvent;
	import com.kaltura.kdpfl.view.controls.KButton;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;

	public class RadioItem extends EventDispatcher
	{
		public static const RADIO:String	= "radio";
		private var _defaultSelection:Boolean;
		private var _item:*;
		public 	var name:String;
		public function set item(o:*):void{		
			
			name				= o.name;
			_item 				= o;
			//_defaultSelection	= item.selected;
			_defaultSelection	= _item.selected;
			_item.addEventListener(MouseEvent.CLICK, onClick);
			
		}
		
		public function resetToDefault():void{
			_item.selected		= _defaultSelection;
		}
		
		public function get item():*{
			return _item;
		}
		
		private function onClick(e:MouseEvent):void{
			dispatch();
		}

		private function dispatch():void{
			var addThisEvent:AddThisEvent	= new AddThisEvent(AddThisEvent.RADIO_BUTTON_EVENT);
			addThisEvent.data				= {item:this, type:"clicked"};
			dispatchEvent(addThisEvent);
		}
		
		public function RadioItem()
		{
			
		}
	}
}