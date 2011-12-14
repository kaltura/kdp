package com.kaltura.kdpfl.util
{
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	
	public class KColorUtil
	{
		public function KColorUtil()
		{
		}

		/**
		 *takes 2 colors (in 0x###### format or as uint) and a fraction between 0 to 1
		 * and returns the mixed color between the color with the fraction precentage where 0 is fully startValue
		 * @param fraction
		 * @param startValue
		 * @param endValue
		 * @return 
		 * 
		 */
		public static function interpolateColor(fraction:Number, startValue:*, endValue:*):*
		{
		    var startR:int;
		    var startG:int;
		    var startB:int;
		    var endR:int;
		    var endG:int;
		    var endB:int;
		    var deltaR:int;
		    var deltaG:int;
		    var deltaB:int;
		    fraction = Math.min(1, Math.max(0, fraction));
		    startR = (uint(startValue) & 0xff0000) >> 16;
		    startG = (uint(startValue) & 0xff00) >> 8;
		    startB = uint(startValue) & 0xff;
		    endR = (uint(endValue) & 0xff0000) >> 16;
		    endG = (uint(endValue) & 0xff00) >> 8;
		    endB = uint(endValue) & 0xff;
		    deltaR = endR - startR;
		    deltaG = endG - startG;
		    deltaB = endB - startB;
		    var newR:uint = startR + deltaR * fraction;
		    var newG:uint = startG + deltaG * fraction;
		    var newB:uint = startB + deltaB * fraction;
		    return newR << 16 | newG << 8 | newB;
		}

		/**
		 * Get a display object and color and color it  
		 */
		public static function colorDisplayObject(displayObject:DisplayObject,color:uint = undefined):void
		{
				var colorTransform:ColorTransform = new ColorTransform();
				colorTransform.color = color;
				displayObject.transform.colorTransform = colorTransform;
		}

	}
}