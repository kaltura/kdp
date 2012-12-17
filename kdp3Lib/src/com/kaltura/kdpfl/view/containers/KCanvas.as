package com.kaltura.kdpfl.view.containers
{
	import com.kaltura.kdpfl.component.IComponent;
	import com.yahoo.astra.utils.NumberUtil;
	
	import fl.containers.BaseScrollPane;
	
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;
	/**
	 * Class KCanvas extends Astra's BaseScrollPane and provides a canvas, which is a container that positions
	 * its children absolutely - one on top of the next. 
	 * 
	 */	
	public dynamic class KCanvas extends BaseScrollPane implements IComponent
	{
		/**
		 * configuration for canvas - holds the canvas children with their configurations
		 * percentWidth and percentHeight
		 */
		private var _configuration:Array;

		public function KCanvas(configuration:Array=null)
		{
			super();
			//super(configuration);
		}

 		public function initialize():void
		{
 			this.verticalScrollPolicy = "off";
			this.horizontalScrollPolicy = "off";
		}

 		public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
			if (styleName != null && styleName != '')
				setStyle("skin", styleName);
			mouseEnabled = true;
		}

		override public function setStyle(type:String, name:Object):void
		{
 			try{
				var cls:Class = getDefinitionByName(name.toString()) as Class;
				super.setStyle(type, cls);
			}catch(ex:Error){
				//trace("Canvas setStyle:",name);
			}
		}

 		override public function set width(value:Number):void
		{
			resize();
			super.width = value;
		}
		override public function set height(value:Number):void
		{
			resize();
			super.height = value;
		}
		public function set configuration (value:Array):void
		{
			var i : int; //Loop index
			if (this._configuration && this._configuration.length > 0)
			{
				var oldConfigCount:int = this._configuration.length;
				for(i= 0; i < oldConfigCount; i++)
				{
					var configItem:Object = this._configuration[i];
					var child:DisplayObject = configItem.target as DisplayObject;
					if(!child)
					{
						continue;
					}
					
					//remove from the display list
					this.removeChild(child);
					
					//remove as a client
				}
			}
			
			_configuration = value;
			
			for(i=0;i<_configuration.length;i++)
			{
				if(_configuration[i]['target'])
					addChild(_configuration[i]['target']);
			}
		}
		public function get configuration ():Array
		{
			return _configuration;
		}

		protected function resize():void
		{
			if(_configuration)
			{
				for(var j:uint=0;j<_configuration.length;j++)
				{
				var dobj:DisplayObject = _configuration[j]['target'];

					if(_configuration[j]['percentHeight'])
					{
						var newH:Number =  this.height *_configuration[j]['percentHeight']/100 ;
						if (!NumberUtil.fuzzyEquals(dobj.height, newH, 10))
							dobj.height = newH
					}
					if(_configuration[j]['percentWidth'])
					{
						var newW:Number = this.width *_configuration[j]['percentWidth']/100 ;
						if (!NumberUtil.fuzzyEquals(dobj.width, newW, 10))
							dobj.width = newW;
					}

				}
			}
		}
		public override function set enabled(arg0:Boolean):void
		{
			// do nothing - just override whatever this does
		}
	}
}