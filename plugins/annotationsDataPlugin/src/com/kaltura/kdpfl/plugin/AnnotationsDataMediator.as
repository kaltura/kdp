package com.kaltura.kdpfl.plugin
{
	import com.kaltura.KalturaClient;
	import com.kaltura.commands.annotation.AnnotationList;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.kdpfl.model.ServicesProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.plugin.strings.NotificationStrings;
	import com.kaltura.kdpfl.plugin.strings.SortOrderString;
	import com.kaltura.vo.KalturaAnnotationFilter;
	import com.kaltura.vo.KalturaFilter;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class AnnotationsDataMediator extends Mediator
	{
		public static const NAME : String = "retrieveAnnotationsMediator";
		
		public function AnnotationsDataMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			var arr : Array = [NotificationStrings.RETRIEVE_ANNOTATIONS, NotificationStrings.SKIP_TO_CHAPTER];
			return arr;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationStrings.RETRIEVE_ANNOTATIONS:
					
					retrieveAnnotationGroup (viewComponent.rootAnnotationId);
					
					break;
				case NotificationStrings.SKIP_TO_CHAPTER:
					
					attemptSkipToChapter(notification.getBody().id)
					
					break;
			}
		}
		
		private function retrieveAnnotationGroup (groupId : String) : void
		{	
			var kc : KalturaClient = (facade.retrieveProxy(ServicesProxy.NAME) as ServicesProxy).kalturaClient;
			
			var annotationsListFilter : KalturaAnnotationFilter = new KalturaAnnotationFilter();
			
			annotationsListFilter.parentIdEqual = groupId;
			
			var listAnnotationGroup : AnnotationList = new AnnotationList(annotationsListFilter);
			
			listAnnotationGroup.addEventListener(KalturaEvent.COMPLETE, onAnnotationGroupLoaded);
			
			listAnnotationGroup.addEventListener(KalturaEvent.FAILED, onAnnotationGroupLoadFailed );
			
			kc.post(listAnnotationGroup);
			
		}
		
		private function onAnnotationGroupLoaded (e : KalturaEvent) : void
		{
			(viewComponent as AnnotationsDataPluginCode).annotationsGroup = e.data.objects as Array;
			
			if ((viewComponent as AnnotationsDataPluginCode).sortOrder)
			{
				sortArray ((viewComponent as AnnotationsDataPluginCode).sortOrder);
			}
			
			sendNotification( NotificationStrings.ANNOTATIONS_LOADED );
			
			(viewComponent as AnnotationsDataPluginCode).activeChapterId = (viewComponent as AnnotationsDataPluginCode).annotationsGroup[0].id;
		}
		
		private function onAnnotationGroupLoadFailed ( e : KalturaEvent) : void
		{
			
		}
		
		private function sortArray (sortType : String) : void
		{
			if ((viewComponent as AnnotationsDataPluginCode).annotationsGroup && (viewComponent as AnnotationsDataPluginCode).annotationsGroup.length)
			{
				switch (sortType)
				{
					case SortOrderString.START_TIME:
						(viewComponent as AnnotationsDataPluginCode).annotationsGroup.sortOn("startTime");
						break;
					case SortOrderString.TEXT:
						(viewComponent as AnnotationsDataPluginCode).annotationsGroup.sortOn("text");
						break;
				}
			}
			
		}
		
		private function attemptSkipToChapter (id : String) : void
		{
			if ((viewComponent as AnnotationsDataPluginCode).annotationsGroup && (viewComponent as AnnotationsDataPluginCode).annotationsGroup.length)
			{
				for each (var annotation : Object in (viewComponent as AnnotationsDataPluginCode).annotationsGroup)
				{
					if (annotation.id == id)
					{
						(viewComponent as AnnotationsDataPluginCode).activeChapterId = id;
						return;
					}
				}
			}
			sendNotification(NotificationStrings.ACTIVE_CHAPTER_CHANGE_FAILED);
		}
	}
}