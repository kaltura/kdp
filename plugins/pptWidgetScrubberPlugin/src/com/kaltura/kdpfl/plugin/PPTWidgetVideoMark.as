package com.kaltura.kdpfl.plugin {
	import fl.controls.Button;
	import fl.core.UIComponent;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * Class PPTWidgetVideoMark represents the single sync-point marker.
	 * @author Hila
	 *
	 */
	public class PPTWidgetVideoMark extends Button {
		protected static var defaultStyles:Object = {keyFrameIcon_Over: "keyFrameIcon_Over",
				keyFrameIcon_Selected: "keyFrameIcon_Selected",
				keyFrameIcon_Up: "keyFrameIcon_Up"};

		protected var _adminMode:Boolean = false;

		[Bindable]
		private var _videoMarkContentText:String;
		private var _time:Number = 1;
		private var _totalTime:Number = 1;
		private var _markId:uint;
		private var _gapX:Number;
		private var _isDragging:Boolean = false;


		/**
		 *Constructor.
		 *
		 */
		public function PPTWidgetVideoMark() {
			this.setStyle("upSkin", defaultStyles["keyFrameIcon_Up"]);
			this.setStyle("downSkin", defaultStyles["keyFrameIcon_Over"]);
			this.setStyle("overSkin", defaultStyles["keyFrameIcon_Over"]);
			this.setStyle("disabledSkin", defaultStyles["keyFrameIcon_Up"]);
			this.setStyle("selectedDisabledSkin", defaultStyles["keyFrameIcon_Selected"]);
			this.setStyle("selectedUpSkin", defaultStyles["keyFrameIcon_Selected"]);
			this.setStyle("selectedDownSkin", defaultStyles["keyFrameIcon_Selected"]);
			this.setStyle("selectedOverSkin", defaultStyles["keyFrameIcon_Selected"]);

			toggle = true;
			width = (getDisplayObjectInstance(getStyleValue("upSkin")) as Sprite).width;
			height = (getDisplayObjectInstance(getStyleValue("upSkin")) as Sprite).height;
			_adminMode = adminMode;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
 

		protected function onAddedToStage(event:Event):void {
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}


		protected function onMouseDown(event:MouseEvent):void {
			if (_adminMode) {
				_gapX = this.x - event.stageX;
				this.startDrag(false, new Rectangle(parent.x, parent.y, parent.width - 50, parent.height));
				_isDragging = true;

			}
			root.addEventListener(MouseEvent.MOUSE_UP, onMouseUp); // event on root because the mouse can move outside of the dragged area
		}


		protected function onMouseUp(event:MouseEvent):void {
			root.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			if (_adminMode) {
				this.stopDrag();
				_isDragging = false;
				var oldTime:Number = _time;
				var newTime:int = int ((event.stageX + _gapX) * _totalTime / parent.width);

				if (oldTime != newTime) {
					dispatchEvent(new PPTWidgetVideoMarkUpdateEvent(oldTime, newTime, markId, true));
				}
			}
		}

		private var counter:Number = 0;


		override protected function draw():void {
			super.draw();

			if (parent) {
				// Check the limits (Dont cut in the edges)
				var newXValue:Number = (_time / _totalTime) * (parent.width);

				// Update the new x value
				if (!_isDragging)
					this.x = newXValue;
					//trace("x:",this.x);
			}
		}


		public function highlight():void {
			this.selected = true;
		}


		public function removeHighlight():void {
			this.selected = false;
		}


		public function set text(value:String):void {
			_videoMarkContentText = value;
			//invalidateDisplayList();		
		}


		public function set time(value:Number):void {
			_time = value;
		}


		public function get time():Number {
			return _time;
		}


		public function set totalTime(value:Number):void {
			_totalTime = value;
		}


		public function set markId(value:uint):void {
			_markId = value;
		}


		public function get markId():uint {
			return _markId;
		}


		public function set adminMode(value:Boolean):void {
			_adminMode = value;
		}


		public function get adminMode():Boolean {
			return _adminMode;
		}
	}
}