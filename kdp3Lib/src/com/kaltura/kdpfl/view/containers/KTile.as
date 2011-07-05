package com.kaltura.kdpfl.view.containers
{
	import com.kaltura.kdpfl.component.IComponent;
	import com.yahoo.astra.fl.containers.FlowPane;
	import com.yahoo.astra.layout.modes.HorizontalAlignment;
	import com.yahoo.astra.layout.modes.VerticalAlignment;

	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;

	public dynamic class KTile extends FlowPane implements IComponent
	{
		public function KTile(configuration:Array=null)
		{
			super(configuration);
			mouseEnabled = false;
		}

		public function initialize():void
		{
			this.horizontalGap = 20;
			this.verticalScrollPolicy = "off";
			this.horizontalScrollPolicy = "off";

			this.horizontalAlign = HorizontalAlignment.CENTER;
  			this.verticalAlign = VerticalAlignment.MIDDLE;
		}

		public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
			if (styleName != null && styleName != '')
				setStyle("skin", styleName);
			mouseEnabled = false;
		}

		override public function setStyle(type:String, name:Object):void
		{
			try{
				var cls:Class = getDefinitionByName(name.toString()) as Class;
				super.setStyle(type, name);
			}catch(ex:Error){}
		}
		
		public override function set enabled(arg0:Boolean):void
		{
			// do nothing - just override whatever this does
		}
	}
}