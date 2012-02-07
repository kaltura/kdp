package com.kaltura.kdpfl.plugin {
	import fl.controls.Button;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.events.*;

	public class PPTWidgetVideoMarksContainer extends UIComponent {
		protected var _adminMode:Boolean = false;
		protected var _allMarksEnabled:Boolean = false;


		public function PPTWidgetVideoMarksContainer() {
		}

		private var _totalTime:Number;


		override protected function draw():void {
			if (isInvalid(InvalidationType.SIZE)) {
				width = parent.width;
				for (var i:int = 0; i < numChildren; i++) {
					(this.getChildAt(i) as PPTWidgetVideoMark).drawNow();
				}
			}
		}


		override public function set width(value:Number):void {
			super.width = value;
		}


		public function addMark(videoMarkObj:Object):void {
			var videoMark:PPTWidgetVideoMark = new PPTWidgetVideoMark();

			videoMark.totalTime = _totalTime;
			videoMark.text = "tool tip " + videoMarkObj.slide;
			videoMark.time = videoMarkObj.video;
			videoMark.markId = videoMarkObj.slide;
			videoMark.addEventListener(MouseEvent.MOUSE_DOWN, onMarkMouseDown);
			videoMark.addEventListener(PPTWidgetVideoMarkUpdateEvent.EVENT_VIDEO_MARK_UPDATE, onVideoMarkUpdate);
			videoMark.adminMode = _adminMode;
			videoMark.buttonMode = true;
			if (!_allMarksEnabled)
				videoMark.enabled = false;
			addChild(videoMark);
		}


		public function removedMark(videoMarkObj:Object):void {
			var videoTime:Number = videoMarkObj.video;

			for (var index:uint = 0; index < numChildren; index++) {
				if (PPTWidgetVideoMark(getChildAt(index)).time == videoTime) {
					// found the child to be removed
					removeChildAt(index);
					break;
				}
			}
		}


		protected function onMarkMouseDown(event:MouseEvent):void {
			var videoMark:PPTWidgetVideoMark = event.currentTarget as PPTWidgetVideoMark;
			dispatchEvent(new PPTWidgetVideoMarkClickedEvent(videoMark.time, videoMark.markId));
		}


		protected function onVideoMarkUpdate(event:PPTWidgetVideoMarkUpdateEvent):void {
			var targetVideoMark:PPTWidgetVideoMark = event.target as PPTWidgetVideoMark;
			var hittingSomething:Boolean = isHittingSomething(targetVideoMark);

			if (!hittingSomething) {
				targetVideoMark.time = event.newTime;
				targetVideoMark.drawNow();
			}
			else {
				targetVideoMark.drawNow();
				event.stopImmediatePropagation(); // don't let the mediator get this event
			}
		}


		public function set videoMarks(videoMarks:Array):void {
			if (this.numChildren > 0) {
				while (this.numChildren > 0) {
					removeChildAt(0);
				}
			}

			for each (var videoMark:Object in videoMarks) {
				addMark(videoMark);
			}
		}


		public function set totalTime(value:Number):void {
			_totalTime = value;
		}

		/**
		 * Highlight the last mark before given videotime, remove highlight from all others. 
		 * @param videoTime
		 * 
		 */
		public function highlightMarker(videoTime:Number):void {
			var videoMark:PPTWidgetVideoMark;
			for (var index:int = 0; index < numChildren; index++) {
				videoMark = (getChildAt(index) as PPTWidgetVideoMark);
				if (videoMark.time == videoTime) {
					videoMark.highlight();
				}
				else {
					videoMark.removeHighlight();
				}
			}
		}

		/**
		 * remove the highlights from all marks 
		 */		
		public function removeHighlights():void {
			var videoMark:PPTWidgetVideoMark;
			for (var index:uint = 0; index < numChildren; index++) {
				videoMark = (getChildAt(index) as PPTWidgetVideoMark);
				videoMark.removeHighlight();
			}
		}


		public function set adminMode(value:Boolean):void {
			_adminMode = value;

			// set to all mark so dragging will be enabled/disabled
			for (var index:uint = 0; index < numChildren; index++) {
				(getChildAt(index) as PPTWidgetVideoMark).adminMode = _adminMode;
			}
		}


		public function get adminMode():Boolean {
			return _adminMode;
		}


		public function isHittingSomething(targetVideoMark:PPTWidgetVideoMark):Boolean {
			for (var index:uint = 0; index < numChildren; index++) {
				var videoMark:PPTWidgetVideoMark = PPTWidgetVideoMark(getChildAt(index));
				if (videoMark != targetVideoMark) {
					if (targetVideoMark.hitTestObject(videoMark)) {
						return true;
					}
				}
			}
			return false;
		}


		public function enableAllMarks():void {
			for (var i:int = 0; i < this.numChildren; i++) {
				if (this.getChildAt(i) is PPTWidgetVideoMark) {
					(this.getChildAt(i) as Button).enabled = true;
				}
			}
			_allMarksEnabled = true;
		}
	}
}