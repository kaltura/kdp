package com.kaltura.kdpfl.view
{
	
	import com.kaltura.kdpfl.util.KAstraAdvancedLayoutUtil;
	import com.kaltura.kdpfl.view.containers.KVBox;
	import com.kaltura.kdpfl.view.strings.AnnotationStrings;
	import com.kaltura.vo.KalturaAnnotation;
	
	import fl.controls.List;
	import fl.controls.ScrollBarDirection;
	import fl.controls.ScrollPolicy;
	import fl.controls.listClasses.CellRenderer;
	import fl.core.UIComponent;
	import fl.data.DataProvider;
	import fl.events.DataChangeEvent;
	import fl.events.DataChangeType;
	import fl.events.ListEvent;
	import fl.events.ScrollEvent;
	import fl.managers.StyleManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.Sort;
	import mx.collections.errors.ItemPendingError;
	
	import org.osmf.net.SwitchingRuleBase;
	
	public dynamic class AnnotationsBox extends KVBox
	{
		private var _dataProvider : DataProvider;
		
		public static const ANNOTATION_ADDED : String = "annotationAdded";
		
		public static const KEY : String = "inTime";
		public static const DATA : String = "annotation";
		
		public function AnnotationsBox(configuration:Array=null)
		{
			reset();
			
			setVisualAttributes();
		}
		
		public function addAnnotation (n_annotation : Annotation) : void
		{
			if (findIndexByInTime(n_annotation.inTime) == -1)
			{
				this.dataProvider.addItem({inTime: n_annotation.inTime, annotation: n_annotation})
			}
		}
		
		public function removeAnnotation (annotation2Remove : Annotation) : void
		{
			this.dataProvider.removeItemAt(findIndexByAnnotation(annotation2Remove));
		}
		

		public function get dataProvider():DataProvider
		{
			return _dataProvider;
		}

		public function set dataProvider(value:DataProvider):void
		{
			_dataProvider = value;
		}
		
		protected function onDataProviderChange (e : DataChangeEvent) : void
		{
			switch (e.changeType)
			{
				case DataChangeType.ADD:
					this.dispatchEvent( new Event(ANNOTATION_ADDED) );
					this.dataProvider.sortOn("inTime",Array.NUMERIC);
					var newAnnotation : Annotation = e.items[0].annotation;
					KAstraAdvancedLayoutUtil.appendToLayoutAt(this, newAnnotation, dataProvider.getItemIndex(e.items[0]), 100, 100);
					break;
				case DataChangeType.REMOVE:
					var annotationToRemove : Annotation = e.items[0]["annotation"];
					KAstraAdvancedLayoutUtil.removeFromLayout(this, annotationToRemove);
					break;
				case DataChangeType.CHANGE:
					
					break;
			}
			
			this.dispatchEvent(new Event(AnnotationStrings.ANNOTATIONS_LIST_CHANGED_EVENT, true) );
				
		}
		
		
		protected function setVisualAttributes () : void
		{
			this.verticalGap = 3;
			this.paddingLeft = 5;
			this.paddingTop = 3;
			this.setSkin("feedback_bg");
			this.horizontalScrollPolicy = ScrollPolicy.OFF;
		}
		
		public function scrollToInTime (timeToSeek : Number) : void
		{
			var indexOfSeekTime : int = findIndexByInTime(timeToSeek);
			
			var annotationToSeek : Annotation = dataProvider.getItemAt(indexOfSeekTime)["annotation"] as Annotation;
			
			this.verticalScrollPosition = annotationToSeek.y;
		}
		
		public function findIndexByInTime (inTime : Number) : int
		{
			for (var i:int=0; i< dataProvider.length; i++)
			{
				if (dataProvider.getItemAt(i).inTime == inTime)
				{
					return i;
				}
			}
			
			return -1;
		}
		
		public function findIndexByAnnotation (annotation : Annotation) : int
		{
			for (var i:int=0; i< dataProvider.length; i++)
			{
				if (dataProvider.getItemAt(i).annotation == annotation)
				{
					return i;
				}
			}
			
			return -1;
		}
		
		public function getAllObjectsInFieldAsArray (fieldName : String) : Array
		{
			var re_array : Array = new Array();
			for (var index : int; index < dataProvider.length; index++ )
			{
				re_array.push(dataProvider.getItemAt(index)[fieldName]);
			}
			
			return re_array;
		}
		
		public function reset () : void
		{
			if (this.dataProvider && this.dataProvider.hasEventListener(DataChangeEvent.DATA_CHANGE))
			{
				this.dataProvider.removeEventListener(DataChangeEvent.DATA_CHANGE, onDataProviderChange );
			}
			
			this.dataProvider = new DataProvider();
			
			this.dataProvider.addEventListener(DataChangeEvent.DATA_CHANGE, onDataProviderChange );
			
			this.configuration = new Array();
		}
		
		public function get millisecTimesArray () : Array
		{
			var reArray : Array = new Array();
			var dpArray : Array = dataProvider.toArray();
			
			for each (var item:* in dpArray)
			{
				reArray.push(item["inTime"]*1000);
			}
			return reArray;
		}
		
		public function get annotationsAsKalturaAnnotationArray () : Array
		{
			var kAnnotationArr : Array = new Array();
			
			var dpArray : Array = dataProvider.toArray();
			
			for (var i:int =0; i < dpArray.length; i++)
			{
				var kAnnotation : KalturaAnnotation = (dpArray[i]["annotation"] as Annotation).kalturaAnnotation;
				kAnnotationArr.push(kAnnotation);
			}
			return kAnnotationArr;
		}
		
		public function changeAnnotationsViewMode (viewMode : String) : void
		{
			for (var i:int = 0; i< dataProvider.length; i++)
			{
				var curr_annotation : Annotation = dataProvider.getItemAt(i)["annotation"] as Annotation;
				curr_annotation.viewMode = viewMode;
			}
		}
	}
}