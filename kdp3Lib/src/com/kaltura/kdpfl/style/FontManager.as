package com.kaltura.kdpfl.style
{
	import flash.text.Font;
	import flash.utils.getQualifiedClassName;
	
	public class FontManager
	{
		protected static var instance : FontManager;
		private var embeddedFonts:Object = new Object; 

		public static function getInstance() : FontManager
		{
			if (instance == null) instance = new FontManager();
			return instance;
		}
		
/* 		public function getFont(fontName:String):Boolean
		{
			if (!embeddedFonts.hasOwnProperty([fontName]))
			{
				try
				{
					Font.registerFont(getDefinitionByName(fontName) as Class);
					embeddedFonts[fontName] = true;
				}
				catch(e:Error)
				{
					embeddedFonts[fontName] = false;
					//trace("registerFont", e);
				}
			}
			
			return embeddedFonts[fontName];			
		}  */
		
		/**
		 * return the Font by the Font class name, if the function return null 
		 * it's mean that there is no Embbeded Font by this ClassName
		 * @param fontClassName
		 * @return 
		 * 
		 */		
		public function getEmbeddedFont( fontClassName : String ) : Font
		{
			var embeddedFonts:Array = Font.enumerateFonts(false);
			var item : Font = null;
			
			for(var i:Number = 0; i < embeddedFonts.length; i++)
			{
				var currentFontName : String = getQualifiedClassName(embeddedFonts[i]);
				if( fontClassName && currentFontName ==  fontClassName)
				{
					item =  embeddedFonts[i];
	      			break;	
				}
	   		}
	   		
	   		return item;
		}
	}
}