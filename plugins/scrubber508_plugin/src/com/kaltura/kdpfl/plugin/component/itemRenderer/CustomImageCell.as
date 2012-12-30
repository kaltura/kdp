package com.kaltura.kdpfl.plugin.component.itemRenderer
{
	import fl.controls.listClasses.ICellRenderer;
	import fl.controls.listClasses.ImageCell;
	import fl.controls.TileList;
	import fl.data.DataProvider;
	import fl.managers.StyleManager;
	import flash.events.EventDispatcher;
	import flash.text.*;
	import flash.events.*;
	import fl.containers.UILoader;
	import fl.controls.Button;
	import flash.display.Bitmap;
	
	public class CustomImageCell extends ImageCell implements ICellRenderer
	{  
		private var title	:	TextField;
		private var tf		: 	TextFormat;
		
    	public function CustomImageCell() 
		{
			super();
			
			// set skins
			setStyle("upSkin", CustomCellBg);
			setStyle("downSkin", CustomCellBg);
     	    setStyle("overSkin", CustomCellBgOver);
			
     	    setStyle("selectedUpSkin", CustomCellBgSelected);
    		setStyle("selectedDownSkin", CustomCellBgSelected);
    	    setStyle("selectedOverSkin", CustomCellBgSelected);
			
			
			// turn off text overlay
			setStyle("textOverlayAlpha", 0);
			
			title = new TextField ();
			
			title.autoSize = TextFieldAutoSize.LEFT;
			//title.defaultTextFormat = styles.Arial_11_white;
			title.antiAliasType = AntiAliasType.ADVANCED;
			title.embedFonts = StyleManager.getStyle("embedFonts");
			title.x = 120;
			title.width = 150;
			title.multiline = true;
			title.wordWrap = true;
			title.selectable = false;
			addChild(title);
			
			tf = new TextFormat();
			tf.font = "Tahoma";
			tf.color = 0xFFFFFF;
			
			loader.scaleContent = false;
		
			useHandCursor = true;
    	}
	
		override protected function drawLayout():void
		{
			var imagePadding:Number = getStyleValue("imagePadding") as Number;
			loader.move(11, 5);
			
			var w:Number = width-(imagePadding*2);
			var h:Number = height-imagePadding*2;
			if (loader.width != w && loader.height != h)
			{
				loader.setSize(w,h);
			}
			loader.drawNow(); // Force validation!

			title.text = data.label;
			title.setTextFormat(tf);
			
			background.width = width;
			background.height = height;
			textField.visible = false;
		}
	}
}