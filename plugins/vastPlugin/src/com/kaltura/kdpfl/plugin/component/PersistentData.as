package com.kaltura.kdpfl.plugin.component
{
	import flash.net.SharedObject;
	
	import org.puremvc.as3.interfaces.IFacade;

	public class PersistentData {
		
		
		private var _soName:String = "kaltura/vast_";
		
		public static const millisecondsPerDay:int = 1000 * 60 * 60 * 24;
		
		/**
		 * the shared object used for storing data 
		 */
		private var _so:SharedObject;
		
		private var _config:Object
		
		public function PersistentData(){}
		
		
		public function init(facade:IFacade) :void {
			_config = facade.retrieveProxy("configProxy");
			_so = SharedObject.getLocal(_soName + _config.vo.kuiConf.id);
		}
		
		
		/**
		 * check if persistence data is from the last 24 hours
		 * @return true | false
		 */
		public function isPersistenceValid():Boolean {
			var result:Boolean = true;
			var pd:Object = _so.data;
			if (pd.date == null) {
				// no saved data
				result = false;
			}
			else {
				var date:Date = new Date();
				var dif:Number = date.getTime() - pd.date.getTime();
				if (dif > millisecondsPerDay) {
					// more than 24 hours
					result = false;
				}
			}
			return result;
		}
		
		/**
		 * resets persistent data
		 */
		public function resetPersistenceData():void {
			var pd:Object = _so.data;
			pd.date = new Date();
			// should reset to 1 and not 0 because the value would have been increased by now.
			pd.prerollEntries = 1;
			pd.prerollFirstShow = false;
			pd.postrollEntries = 1;
			pd.postrollFirstShow = false;
			if (_config.vo.flashvars.allowCookies=="true")
				_so.flush();
		}
		
		/**
		 * match persistent data with plugin state
		 * */
		public function updatePersistentData(o:Object):void {
			var pd:Object = _so.data;
			pd.prerollFirstShow = o.prerollFirstShow;
			pd.prerollEntries = o.prerollEntries;
			pd.postrollFirstShow = o.postrollFirstShow;
			pd.postrollEntries = o.postrollEntries;
			if (_config.vo.flashvars.allowCookies=="true")
				_so.flush();
		}
		
		
		/**
		 * saved data 
		 */		
		public function get data():Object {
			return _so.data;
		}
		
	}
}