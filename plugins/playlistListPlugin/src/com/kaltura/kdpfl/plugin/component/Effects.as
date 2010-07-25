package com.kaltura.kdpfl.plugin.component
{
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.BlurFilter;
	
	public class Effects extends Object
	{
		//
		
		public function Effects()
		{
			
		}
		
		public static function desaturate(obj:DisplayObject, n:Number=1):void
		{
			var filt:Array = obj.filters;
			n = Math.round(n*10)/10;
			//trace("des: "+n);
			n=Math.min(n,1);
			n=Math.max(n,0);
			//
			var am1:Number = n/3;
			var am2:Number = 1-(2*am1);
			//
			var matrix:Array = new Array();
            matrix = matrix.concat([am2, am1, am1, 0, 0]); // red
            matrix = matrix.concat([am1, am2, am1, 0, 0]); // green
            matrix = matrix.concat([am1, am1, am2, 0, 0]); // blue
            matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha
			var cmf:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			//
			var none:Boolean=true;
			if(filt.length>0)
			{
				for(var i:uint=0; i<filt.length; i++)
				{
					if(filt[i] is ColorMatrixFilter)
					{
						none=false;
						filt.splice(i,1,cmf);
					}
				}
			}
			if(none)
			{
				filt.push(cmf);
			}
			obj.filters = filt;
		}
		
		public static function undesaturate(obj:DisplayObject):void
		{
			var filt:Array = obj.filters;
			if(filt.length>0)
			{
				for(var i:uint=0; i<filt.length; i++)
				{
					if(filt[i] is ColorMatrixFilter)
					{
						filt.splice(i,1);
					}
				}
			}
			obj.filters = filt;
		}
		
		public static function blur(obj:DisplayObject, amount:Number=8, n:Number=1, fx:Number=1, fy:Number=1):void
		{
			var bf:BlurFilter = new BlurFilter(amount*n*fx,amount*n*fy);
			var filt:Array = obj.filters;
			//
			var none:Boolean=true;
			if(filt.length>0)
			{
				for(var i:uint=0; i<filt.length; i++)
				{
					if(filt[i] is BlurFilter)
					{
						none=false;
						filt.splice(i,1,bf);
					}
				}
			}
			if(none)
			{
				filt.push(bf);
			}
			obj.filters = filt;
		}
		
		public static function unblur(obj:DisplayObject):void
		{
			var filt:Array = obj.filters;
			if(filt.length>0)
			{
				for(var i:uint=0; i<filt.length; i++)
				{
					if(filt[i] is BlurFilter)
					{
						filt.splice(i,1);
					}
				}
			}
			obj.filters = filt;
		}
		
		public static function tint(obj:DisplayObject,clr:Number,pc:Number):void
		{
			var red:Number = int(clr/Math.pow(256,2));
			var green:Number = int(clr/(256)) - (red*256);
			var blue:Number = clr - (red*Math.pow(256,2)) - (green*256);
			//trace(red+","+green+","+blue);
			var ct:ColorTransform = new ColorTransform(1-pc,1-pc,1-pc,1,Math.round(red*pc),Math.round(green*pc),Math.round(blue*pc),0);
			obj.transform.colorTransform = ct;
		}
		
		public static function untint(obj:DisplayObject):void
		{
			obj.transform.colorTransform = new ColorTransform();
		}
	}
}
