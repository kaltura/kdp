package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.view.controls.KButton;
	import com.yahoo.astra.fl.controls.TabBar;
	
	import fl.data.DataProvider;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	
	public class TabBarKdp3 extends Sprite 
	{
		public var tabBar:TabBar; 
		public var prevBut:KButton = new KButton();
		public var nextBut:KButton = new KButton();
		public var padding:Number = 5;
		
		private var _tabData:Array;
		private var _localProvider:DataProvider = null;
		private var _firstVisibleButton:int= 0;
		private var _needToMove:Number = 0; 
		
		
		public function TabBarKdp3() 
		{		
			onComplete(null);
			prevBut.label = "";
			prevBut.buttonMode = true;
			prevBut.useHandCursor = true;
			prevBut.move(0, 0);
			prevBut.addEventListener(MouseEvent.CLICK, onPrevClicked);
			addChild(prevBut);	
			
			nextBut.label = "";
			nextBut.buttonMode = true;
			nextBut.useHandCursor = true;
			nextBut.addEventListener(MouseEvent.CLICK, onNextClicked);
			addChild(nextBut);	

			nextBut.visible = false;
			prevBut.visible = false;	
			
		}
		
		private function onNextClicked(event:MouseEvent):void {
			var j:int = 0;
			var currWidth:int = 0;
			var rect:Rectangle = this.tabBar.scrollRect;
			
			//if last button to scroll then stop
			if (_firstVisibleButton == this.tabBar.numChildren) return;
			
			//If there is enough space to show all buttons then stopm
			for (j=_firstVisibleButton; j < this.tabBar.numChildren; j++)	
			{
				currWidth += this.tabBar.getChildAt(j).width;
			}
			if (currWidth < rect.width) return;
			
			//Otherwise scroll one button a time
			_firstVisibleButton = _firstVisibleButton +1;
			rect.x = 0;
			for (j=0; j < _firstVisibleButton && j < this.tabBar.numChildren; j++)
			{
				rect.x += this.tabBar.getChildAt(j).width;				
			} 
			this.tabBar.scrollRect = rect;
		}

		private function onPrevClicked(event:MouseEvent):void 
		{
			var j:int = 0;
			var rect:Rectangle = this.tabBar.scrollRect;
			
			//if first button to scroll then stop
			if (_firstVisibleButton == 0) return;
			
			_firstVisibleButton = _firstVisibleButton - 1;
			rect.x = 0;
			for (j=0; j < _firstVisibleButton && j < this.tabBar.numChildren; j++)
			{
				rect.x += this.tabBar.getChildAt(j).width;				
			} 
			this.tabBar.scrollRect = rect;
		}

		private function onComplete(ev:Event):void
		{
			this.tabBar = new TabBar(); 
			tabBar.useHandCursor = true;
			tabBar.mouseChildren = true;
			tabBar.buttonMode = true;
			if (_localProvider != null)
			{
				this.tabBar.dataProvider = _localProvider;
			}
			//this.tabBar.selectedIndex = 0;
			this.tabBar.move(prevBut.width,0);
			this.tabBar.autoSizeTabsToTextWidth = true;

			this.tabBar.addEventListener( Event.CHANGE, tabBarChangeHandler );
			this.tabBar.addEventListener(Event.RENDER, tabBarRendered);
			
			if (_needToMove > 0)
			{
				this.tabBar.scrollRect = new Rectangle(0, 0, _needToMove - nextBut.width - prevBut.width, 200);
				nextBut.move(_needToMove-nextBut.width,0);			
			}
			addChild(this.tabBar);
		}

		override public function set width(value:Number):void
		{
			if (this.tabBar != null)
			{
				tabBar.scrollRect = new Rectangle(0, 0, value - nextBut.width - prevBut.width - (padding*2), 200);
				tabBar.width =  value - nextBut.width - prevBut.width - (padding*2);
				tabBar.move(prevBut.width ,0);
				nextBut.move(value-nextBut.width,0);			
			}
			else
			{
				_needToMove = value;
			}
		}	
		
		private function tabBarRendered( event:Event ):void
		{
			if(tabBar.scrollRect)
			{
				
				if (this.tabBar.scrollRect.width >= this.tabBar.width)
				{
					nextBut.visible = false;
					prevBut.visible = false;
				}
				else
				{
					nextBut.visible = true;
					prevBut.visible = true;				
				}
			}
		}
		
		private function tabBarChangeHandler( event:Event ):void
		{
			var tb:TabBar = ( event.currentTarget as TabBar );
			var index:int = tb.selectedIndex;
			var arr:Array = new Array(1);
			arr[0] = tb.dataProvider.getItemAt(index);
			(this.parent as tabBarCodePlugin).selectedDataProvider = new DataProvider(arr);
		}
		
		public function initialize(provider:DataProvider):void
		{
			_localProvider = provider;	
			if (this.tabBar != null)
			{
				this.tabBar.dataProvider = provider;
			}
		}
			
		public function setSkin(skinName:String, setSkinSize:Boolean=false):void
		{
		}
		
		
		/**
		 * currently selected index in the tab bar 
		 */		
		public function get selectedIndex():int {
			return tabBar.selectedIndex;
		}
		
		/**
		 * @private
		 */		
		public function set selectedIndex(value:int ) :void {
			var oldVal:int = tabBar.selectedIndex; 
			tabBar.selectedIndex = value;
			// when the value is set programatically change event is not dispatched.
			// we want to trigger tabBarChangeHandler(), so dispatch the event manualy:
			// (I really, really, really hope this'll work well)
			if (oldVal == value) {
				// in this case the tabbar won't send a change event, 
				// so we dispath it manualy
				tabBar.dispatchEvent(new Event(Event.CHANGE));
			}
		}
	}
}