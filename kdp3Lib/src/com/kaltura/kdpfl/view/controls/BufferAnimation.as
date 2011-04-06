package com.kaltura.kdpfl.view.controls
{
	import com.yahoo.astra.fl.containers.BoxPane;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;

	public class BufferAnimation extends BoxPane
	{
		private var _tf:TextField;
		private var _animInst : MovieClip;
		public function BufferAnimation()
		{
			super();
			init();
		}

		//PUBLIC FUNCTIONS
		///////////////////////////////////////////////////
		/**
		 * if you have a className of an asset you can swap the loading... with animation
		 * @param className
		 */
		public function setBufferingAnimation(className : String) : void
		{
			trace("SET BUFFER ANIMATION!!!");
			try {
				var anim:Class = getDefinitionByName(className) as Class;
			} catch ( e : Error ){
				trace("couldn't find needed class:", className);
				return; //if the class don't exist stay with the loading label when showing the loader
			}

			// add an animation instead
			_animInst = new anim();
			this.configuration = [{target:_animInst,verticalAlign:"middle",horizontalAlign:"center"}];
			trace ("ANIMATION PARAMS: WIDTH: "+_animInst.width + " HEIGHT: " + _animInst.height + " X: " + _animInst.x + " Y: " + _animInst.y);
		}
		
		//PRIVATE FUNCTIONS
		///////////////////////////////////////////////////

		private function init():void
		{
		//	createBox();
			positionElements();
		}

		public function positionElements():void {
			this.verticalAlign = "middle"
			this.horizontalAlign = "center";
			
		}
//		private function createBox():void
//		{
//			//var config:Object = {target:getText(), percen
//			//_box.horizontalScrollPolicy = "on";
//			this.verticalAlign = "middle"
//			this.horizontalAlign = "center";
//			this.addChild(getText());
//		}

//		/**
//		 * text field is temporary -> it'll be an animation
//		 * */
//		private function getText():TextField
//		{
//			_tf = new TextField();
//			_tf.text = "Loading...";
//			return _tf;
//		}
		
		/**
		 * When the spinner becomes visible, we don't want the watermark, 
		 * or any other clickable entities on the screen to become disabled.
		 * */
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			this.mouseEnabled = false;
		}
		override public function set width(value:Number):void
		{
			super.width = value;
			trace("NEW BUFFER ANIMATION WIDTH: " + value);
		}
		
	}
}