package com.kaltura.kdpfl.plugin.component {

	import fl.data.DataProvider;
	
	import flash.events.Event;


	[Bindable]
	/**
	 * KDataProvider is the unique data provider for the PlaylistAPI Plugin
	 */	
	public class KDataProvider extends DataProvider implements IDataProvider {

		private var _selectedIndex:Number;


		public function KDataProvider(value:Object = null) {
			super(value);
		}

		/**
		 * @private
		 */
		public function set selectedIndex(index:Number):void {
			if (index == _selectedIndex)
				return;
			checkIndex(Math.round(index), data.length - 1);
			_selectedIndex = Math.round(index);

			var evt:Event = new Event(Event.CHANGE);
			this.dispatchEvent(evt);
		}

		/**
		 * currently selected index
		 */
		public function get selectedIndex():Number {
			return (_selectedIndex);
		}

		/**
		 * increment current selected index 
		 */		
		public function next():void {
			selectedIndex = ++_selectedIndex % data.length;
		}

		/**
		 * decrement current selected index 
		 */
		public function prev():void {
			selectedIndex = (--_selectedIndex + data.length) % data.length;
		}
		
		/**
		 * a reference to the data this instance manages
		 * */
		public function get content():Array {
			return data;
		}

	}
}