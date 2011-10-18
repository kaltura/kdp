package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.util.KAstraAdvancedLayoutUtil;
	import com.kaltura.kdpfl.view.controls.KButton;
	import com.kaltura.kdpfl.view.controls.KLabel;
	import com.kaltura.kdpfl.view.controls.KTextField;
	import com.yahoo.astra.fl.containers.BoxPane;
	
	import fl.controls.ScrollPolicy;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	
	import mx.utils.ObjectProxy;

	public class Chapter extends BoxPane
	{
		
		protected var _content:UIComponent;
		protected var _chapterData:ObjectProxy = null;
		
		protected var _itemWidth : Number;
		
		protected var _itemHeight : Number;
		
		public static var constructionFunc : Function;
		
		public static var itemLayout : XML;
		
		protected var _setSkinSize : Boolean;
		
		public var prev_color : Number;
		
		
		
		public function Chapter()
		{
		}
		
		private static var defaultStyles:Object =
			{
				skin: "List_itemUp_default",
				upSkin: "List_itemUp_default",
				overSkin:"List_itemOver_default",
				downSkin:  "List_itemDown_default",
				disabledSkin: "List_itemDisabled_default",
				selectedUpSkin:"List_itemSelectedUp_default",
				selectedOverSkin:"List_itemSelectedOver_default",
				selectedDownSkin:"List_itemSelectedDown_default",
				selectedDisabledSkin: "List_itemSelectedDisabled_default",
				textFormat: null,
				disabledTextFormat: null,
				embedFonts: null,
				textPadding: 5
			};
		
		public function setSkin (skinName:String="default", setSkinSize:Boolean=false) : void
		{
			var styleType:String;
			var styleName:String;
			
			_setSkinSize = setSkinSize;
			
			for( var current:String in defaultStyles )
			{
				if( defaultStyles[current] is String && verifyStyle(defaultStyles[current]) )
				{
					styleType = getStyleType( defaultStyles[current] );
					styleName = styleType + "_" + skinName;
					setStyle( current, styleName );
				}
				// else case of Number values like style sliderVerticalGap
				// or skin not verified (possibly display object class not loaded to mem)
			}
		}
		
		private function getStyleType(styleName : String) : String
		{
			var type:String = styleName = styleName.slice( 0, styleName.lastIndexOf('_') );
			return( type );
		}
		
		private function verifyStyle( name:String ):Boolean
		{
			try
			{
				var styleClass:Class = getDefinitionByName(name) as Class;
			}
			catch( e:Error )
			{
				// TODO return warning of style not found
				return( false );
			}
			return( true );
		}
		
		override public function setStyle( type:String, name:Object ):void
		{
			if( verifyStyle(name as String) )
				super.setStyle( type, name );
		}
		
		
		[Bindable]
		public function get data():ObjectProxy
		{
			return _chapterData;
		}

		public function set data(value:ObjectProxy):void
		{
			_chapterData = ObjectProxy(value);
			
			if (value)
			{
				content = constructionFunc(itemLayout, _chapterData);
				this.mouseChildren = false;
				//content.addEventListener(Event.RESIZE, onContentInit);
				this.addChild (content);
					
			}
		}
		
		public function removeSeparator ( ) : void
		{
			if (content["configuration"][content["configuration"].length -1]["target"].name == "separator")
			{
				var currConfig : Array = content["configuration"].concat();
				
				currConfig.pop();
				
				content["configuration"] = currConfig;
			}
			
		}
		
		
		public function getWidestLabel (uicomponent : UIComponent) : Number
		{
			var maxWidth : Number = 0;
			if (uicomponent.hasOwnProperty("configuration") )
			{
				if (uicomponent["configuration"] && uicomponent["configuration"]["length"])
				{
					for each (var obj : Object in uicomponent["configuration"])
					{
						if (maxWidth < getWidestLabel(obj["target"]))
							maxWidth = getWidestLabel(obj["target"]);
					}
				}
			}
			else if (uicomponent is KLabel)
			{
				if (uicomponent["textField"]["textWidth"] > maxWidth)
				{
					maxWidth = uicomponent["textField"]["textWidth"];
				}
			}
			
			return maxWidth;
		}
		
		public function seLabelColor (uicomponent : UIComponent, color : Number) : void
		{
			//for 
			if (uicomponent.hasOwnProperty("configuration") && uicomponent["configuration"] && uicomponent["configuration"].length)
			{
				for each (var obj : Object in uicomponent["configuration"] )
				{
					seLabelColor (obj["target"], color);
				}
			}
			else
			{
				if (uicomponent is KLabel)
				{
					var textFormat : TextFormat = (uicomponent as KLabel).textField.getTextFormat();
					
					textFormat.color = color;
					
					(uicomponent as KLabel).textField.setTextFormat(textFormat);
				}
			}
			
		}
		
		public function getLabelColor (uicomponent : UIComponent) : Number
		{
			var labelColor : Number;
			if (uicomponent.hasOwnProperty("configuration") && uicomponent["configuration"] && uicomponent["configuration"].length)
			{
				for each (var obj : Object in uicomponent["configuration"] )
				{
					return getLabelColor(obj["target"])
				}
			}
			else
			{
				if (uicomponent is KLabel)
				{
					var textFormat : TextFormat = (uicomponent as KLabel).textField.getTextFormat();
					
					labelColor = textFormat.color as Number
				}
			}
			return labelColor;
		}
		
		public function get itemWidth():Number
		{
			return _itemWidth;
		}

		public function set itemWidth(value:Number):void
		{
			_itemWidth = value;
		}

		public function get itemHeight():Number
		{
			return _itemHeight;
		}

		public function set itemHeight(value:Number):void
		{
			_itemHeight = value;
		}

		public function get content():UIComponent
		{
			return _content;
		}

		public function set content(value:UIComponent):void
		{
			_content = value;
		}

		
	}
}