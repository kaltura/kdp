package tv.freewheel.logging {
	import tv.freewheel.ad.behavior.*;
	/**
	 * How to use this class
	 *   DivRenderer can be used as an example.
	 *   1. In module(renderer/translator/extension) main class
	 *      public static var logger:Logger = null;
	 *      ....
	 *      public function init(context:IRendererContext, controller:IRendererController):void {
	 * 			  logger = Logger.getLogger(controller, context.getConstants());
	 * 				logger.debug("blarblar");
	 *      	...
	 * 			}
	 *   2. In other class of module, see common Transformer as an example
	 *    	private function debug(str:String):void
	 *    	{
	 *    		Logger.current.debug("Transformer: " + str);
	 *    	}
	 */
	public class Logger {
		public static var current:Logger = null;

		private var logHolder:Object;
		private var consts:IConstants;
		private var prefix:String;
		public function Logger() { }

		public static function getLogger(logHolder:Object, constants:IConstants, prefix:String = ""):Logger {
			var l:Logger = new Logger();
			l.logHolder = logHolder;
			l.consts = constants;
			l.prefix = prefix;
			current = l;
			return l;
		}

		public static function getSimpleLogger(prefix:String = ""):Logger {
			var l:Logger = new Logger();
			l.prefix = prefix;
			current = l;
			return l;
		}

		public function log(msg:String, level:int=0, code:uint=0, details:Object=null):void {
			if(this.logHolder) {
				this.logHolder.log(this.prefix + msg, level);
			} else {
				trace(this.prefix + msg);
			}
		}

		public function debug(msg:String):void {
			var level:int = consts ? consts.LEVEL_DEBUG : 0;
			log(msg, level);
		}

		public function info(msg:String):void {
			var level:int = consts ? consts.LEVEL_INFO : 1;
			log(msg, level);
		}

		public function warn(msg:String):void {
			var level:int = consts ? consts.LEVEL_WARNING : 2;
			log(msg, level);
		}

		public function error(msg:String):void {
			var level:int = consts ? consts.LEVEL_ERROR : 3;
			log(msg, level);
		}
	}
}
