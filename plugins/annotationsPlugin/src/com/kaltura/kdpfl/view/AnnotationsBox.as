package com.kaltura.kdpfl.view
{
	
	import com.kaltura.kdpfl.util.KAstraAdvancedLayoutUtil;
	import com.kaltura.kdpfl.view.containers.KVBox;
	import com.kaltura.kdpfl.view.strings.AnnotationStrings;
	import com.kaltura.vo.KalturaAnnotation;
	
	import fl.controls.ScrollPolicy;
	import fl.data.DataProvider;
	import fl.events.DataChangeEvent;
	import fl.events.DataChangeType;
	
	import flash.events.Event;
	
	public dynamic class AnnotationsBox extends KVBox
	{
		private var _dataProvider : DataProvider;
		
		public static const ANNOTATION_ADDED : String = "annotationAdded";
		
		public static const KEY : String = "inTime";
		public static const DATA : String = "annotation";
		public var initialTabIndex:int;
		
		public function AnnotationsBox(configuration:Array=null)
		{
			reset();
			
			setVisualAttributes();
		}
		
		public function addAnnotation (n_annotation : Annotation) : void
		{
			if (findIndexByInTime(n_annotation.inTime) == -1)
			{
				//each annotation holds 3 buttons with tabIndex
				initialTabIndex += 3;
				this.dataProvider.addItem({inTime: n_annotation.inTime, annotation: n_annotation});
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
		/**
		 * Method to scroll down to the required annotation in the annotations box.
		 * @param timeToSeek the in-time of the annotation to scroll to.
		 * 
		 */		
		public function scrollToInTime (timeToSeek : Number) : void
		{
			var indexOfSeekTime : int = findIndexByInTime(timeToSeek);
			
			var annotationToSeek : Annotation = dataProvider.getItemAt(indexOfSeekTime)["annotation"] as Annotation;
			
			this.verticalScrollPosition = annotationToSeek.y;
		}
		/**
		 * Method to retrieve an annotation's index by its in-time.
		 * @param inTime the in-time of the annotation to retrieve.
		 * @return an integer signifying the annotation's index in the data provider.
		 * 
		 */		
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
		/**
		 * Method to retrieve an annotation's index in the data provider.
		 * @param annotation the annotation whose index needs too be retrieved.
		 * @return the index of the annotation.
		 * 
		 */		
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
		/**
		 * 
		 * @param fieldName
		 * @return 
		 * 
		 */		
		public function getAllObjectsInFieldAsArray (fieldName : String) : Array
		{
			var re_array : Array = new Array();
			for (var index : int; index < dataProvider.length; index++ )
			{
				re_array.push(dataProvider.getItemAt(index)[fieldName]);
			}
			
			return re_array;
		}
		/**
		 * Method to empty the annotations data provider.
		 * 
		 */		
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
		/**
		 * Method to retrieve the annotation in-times as an array of millisecond times.
		 * @return an array containing the feedback sessions's annotations' in-times in milliseconds.
		 * 
		 */		
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
		/**
		 * Method to retrieve the feedback session as an array of KalturaAnnotation objects.
		 * @return Array of KalturaAnnotation objects.
		 * 
		 */		
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
		/**
		 * Method to change the view mode of the entire feedback session.
		 * @param viewMode the view mode to switch to. Possible values: view/edit.
		 * 
		 */		
		public function changeAnnotationsViewMode (viewMode : String) : void
		{
			for (var i:int = 0; i< dataProvider.length; i++)
			{
				var curr_annotation : Annotation = dataProvider.getItemAt(i)["annotation"] as Annotation;
				curr_annotation.viewMode = viewMode;
			}
		}
		/**
		 * Function to retrieve the annotations in the required XML form for external interface use.
		 * @param saveMode the mode in which the feedback session is saved - draft/final.
		 * @return an XML representing the current feedback session.
		 * 
		 */		
		public function annotationsXML (saveMode : String, entryId : String, partnerId : int) : XML
		{
			var dpArray : Array = dataProvider.toArray();
			
			
			var feedbackSessionXML : XML = new XML("<annotations status='" + saveMode + "' entryId='" + entryId + "' partnerId='" + partnerId +"'></annotations>");
			var annotationXML : XML;
			var annotation : Annotation;
			for (var i:int =0; i < dpArray.length; i++)
			{
				annotation = dpArray[i]["annotation"] as Annotation;	
				annotationXML = new XML ("<annotation><createdAt></createdAt><updatedAt></updatedAt><text>" + escape(annotation.annotationText) + "</text><startTime>"+ annotation.inTime +"</startTime>" +
					"<endTime>" + annotation.kalturaAnnotation.endTime + "</endTime><userId>" + annotation.kalturaAnnotation.userId + "</userId></annotation>");
				feedbackSessionXML.appendChild( annotationXML );
			}
			
			return feedbackSessionXML;
			
		}
		/**
		 * Function to convert a feedback session from XML form into an array of annotations. 
		 * @param annotationsXML feedback session in XML form
		 * 
		 */		
		public function xmlToAnnotations (annotationsXML : XML) : void
		{
			var annotationsXMLList : XMLList = annotationsXML..annotation;
			
			var entryId :String = annotationsXML.@entryId.toString();
			
			var partnerId : int = int(annotationsXML.@partnerId.toString());
			
			var parentId : String = annotationsXML.@id[0].toString();
			
			
			for each(var annotationXML : XML in annotationsXMLList) 
			{
				var kalturaAnnotation : KalturaAnnotation = new KalturaAnnotation();
				var annotation : Annotation;
				kalturaAnnotation.entryId = entryId;
				kalturaAnnotation.partnerId = partnerId;
				kalturaAnnotation.parentId = parentId;
				for each(var property : XML in annotationXML.children())
				{
					kalturaAnnotation[property.localName().toString()] = property.children()[0] ? property.children()[0].toString() : "";
				}
				
				annotation = new Annotation (AnnotationStrings.VIEW_MODE, -1,"","",kalturaAnnotation, initialTabIndex);
				this.addAnnotation( annotation );
				
			}
		}
		
	}
}