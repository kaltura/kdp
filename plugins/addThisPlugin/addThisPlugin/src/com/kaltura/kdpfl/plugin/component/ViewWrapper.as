package com.kaltura.kdpfl.plugin.component
{
	import com.yahoo.astra.fl.containers.BoxPane;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class ViewWrapper
	{
		public var view:DisplayObjectContainer;
		public var definition:XML;
		
		private var _loadedItems:Array;
		private var _targetName:String;
		private var _loader:Loader;
		public function ViewWrapper()
		{
		
		}
		
		public function loadAndAddChildAt(url:String, targetName:String):void{
			_loader			= new Loader()
			_targetName		= targetName;
			if(!_loadedItems)
				_loadedItems	= new Array();
			
			
			
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete,false,0,true);
			_loader.load(new URLRequest(url));
			
			
		}
		
		private function onComplete(e:Event):void{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			
			_loadedItems.push(e.target.content);
			addItemToTarget(view,_targetName,e.target.content);
		}
		
		public function clearContainer(targetName:String):void{
			for (var i:int = 0; i< view.numChildren;i++){
				if(view.getChildAt(i).name == targetName){
					while((view.getChildAt(i) as DisplayObjectContainer).numChildren > 0){
						(view.getChildAt(i) as DisplayObjectContainer).removeChildAt(0);
					}
					if(_loadedItems)//if loaded items exist and is not available on stage, remove from memory
					for(var x:int=0;x<_loadedItems.length;x++){
						if(!DisplayObjectContainer(view.getChildAt(i)).contains(_loadedItems[x])){
							_loadedItems[x]	= null;
						}
					}
					break;
				}
			}
			
			
		}
		
		//TODO::: loop through children elements
		public function addItemToTarget(currView:DisplayObjectContainer,targetName:String, item:*):void{
			for (var i:int = 0; i< currView.numChildren;i++){
				if(view.getChildAt(i).name == targetName){
					(view.getChildAt(i) as DisplayObjectContainer).addChild(item);
					break;
				}/*else if(view.getChildAt(i) is DisplayObjectContainer){
					addItemToTarget(DisplayObjectContainer(view.getChildAt(i)),targetName,item);
				}*/
			}
			//return;
		}
	}
}