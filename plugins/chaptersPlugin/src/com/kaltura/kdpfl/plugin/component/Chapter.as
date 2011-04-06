package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.view.controls.KLabel;
	
	import fl.controls.listClasses.CellRenderer;
	import fl.controls.listClasses.ListData;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.text.TextField;
	
	import mx.utils.ObjectProxy;

	public class Chapter extends CellRenderer
	{
		
		protected var _content:UIComponent;
		private var _chapterData:ObjectProxy = null;
		
		public function Chapter()
		{
		}
		
		private static var defaultStyles:Object =
			{
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
		
		public static function getStyleDefinition():Object { return defaultStyles; }
		
		
		override public function set data(value:Object):void
		{
			super.data = ObjectProxy( value );
			chapterData = ObjectProxy(data);
			invalidate( InvalidationType.DATA );
		}
		
		public function get chapterData():ObjectProxy
		{
			return _chapterData;
		}
		
		[Bindable]
		public function set chapterData(n_chapterData:ObjectProxy):void
		{
			_chapterData = n_chapterData;
		}
		
		override protected function configUI():void
		{
			super.configUI();
			textField.visible = false;
		}
		
		/**
		 * @private (protected)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */		
		override protected function draw():void
		{
			if( isInvalid(InvalidationType.STYLES,InvalidationType.STATE) )
			{
				drawBackground();
				invalidate(InvalidationType.SIZE,false);
			}
			if ( isInvalid(InvalidationType.DATA) )
			{
				drawContent();
			}
			if (isInvalid(InvalidationType.SIZE))
			{
				drawLayout();
			}
			if (isInvalid(InvalidationType.SIZE,InvalidationType.STYLES))
			{
				if (isFocused && focusManager.showFocusIndicator) { drawFocus(true); }
			}
			invalidate(InvalidationType.ALL,true);
			validate(); // because we're not calling super.draw
		}	
		
		private function drawContent():void
		{
			var contentFactory:Function = getStyleValue( "contentFactory" ) as Function;
			var contentLayout:XML = getStyleValue( "contentLayout" ) as XML;
			
			if( _content && this.contains( _content ) ) 
				this.removeChild( _content );
			
			_content = contentFactory( contentLayout, chapterData );
			_content.mouseEnabled = true;
			this.mouseChildren = true;
			addChild( _content ); 
		}
		
		
		override protected function drawLayout():void
		{
			super.drawLayout();
			
			if( _content )
			{
				_content.width = getWidestLabel();
				width = _content.width;
				_content.height = height;
			}
		}
		
		override public function toString():String
		{
			return( "ListItem " + listData.index );
		}
		override public function set enabled(value:Boolean):void
		{
			this._enabled = value;
		}
		
		override public function set listData(arg0:ListData):void
		{
			super.listData = arg0;
		}
		
		private function getWidestLabel () : Number
		{
			var maxWidth : Number = 0;
			var tf : TextField = new TextField();
			tf.text = this.data.text;
			
			maxWidth = tf.textWidth + 10;
			
			return maxWidth;
		}
	}
}