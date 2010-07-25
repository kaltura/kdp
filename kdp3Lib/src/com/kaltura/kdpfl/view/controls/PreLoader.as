package com.kaltura.kdpfl.view.controls
{
	import com.yahoo.astra.fl.containers.BoxPane;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;

	public class PreLoader extends BoxPane
	{
		private var _tf:TextField;
		private var _aminInst : MovieClip;
		public function PreLoader()
		{
			super();
			init();
		}

		//PUBLIC FUNCTIONS
		///////////////////////////////////////////////////
		/**
		 * if you have a className of an asset you can swap the loading... with animation
		 * @param className
		 *
		 */
		public function swapLoadingWithAnimation( className : String ) : void
		{
			//TODO: Check if the animation was loaded if not report on it with trace
			try{
				var anim : Class = getDefinitionByName(className) as Class;
			}catch( e : Error ){
				return; //if the class don't exist stay with the loading label when shoing the loader
			}

			//remove all childern remove the label loading...
			while (this.numChildren > 0)
				this.removeChildAt(0);

			//add an animation insted
			_aminInst = new anim();
			//this.addChild( _aminInst );
			this.configuration = [{target:_aminInst,verticalAlign:"middle",horizontalAlign:"center"}];
		}
		
		//PRIVATE FUNCTIONS
		///////////////////////////////////////////////////

		private function init():void
		{
			createBox();
		}

		private function createBox():void
		{
			//var config:Object = {target:getText(), percen
			//_box.horizontalScrollPolicy = "on";
			this.verticalAlign = "middle"
			this.horizontalAlign = "center";
			this.addChild(getText());
		}

		//text field is temporary -> it'll be an animation
		private function getText():TextField
		{
			_tf = new TextField();
			_tf.text = "Loading...";
			return _tf;
		}
		
		//When the spinner becomes visible, we don't want the watermark, or any other clickable entities on the screen to become disabled.
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			this.mouseEnabled = false;
		}
		
	}
}