package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.model.vo.AddThisEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class RadioGroup extends EventDispatcher
	{
		public var name:String	= "";
		
		private var _group:Array 	= new Array();
		
		public function RadioGroup()
		{

		}
		
		public function resetToDefault():void{
			for each(var radioItem:RadioItem in _group){
				radioItem.resetToDefault();
			}
		}
		
		public function addItem(item:RadioItem):void{
			item.addEventListener(AddThisEvent.RADIO_BUTTON_EVENT, onRadioItem);
			_group.push(item);
		}
		
		public function get group():Array{
			return _group;
		}
		
		
		private function onRadioItem(e:AddThisEvent):void{
			for each(var radioItem:RadioItem in _group){
				if(radioItem.name	!= e.data.item.name){
					radioItem.item.selected  = false;
				}
			}
		}
		
		
	}
}