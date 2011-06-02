package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.plugin.constants.NotificationStrings;
	import com.kaltura.kdpfl.plugin.events.ChapterEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ChapterListMediator extends Mediator
	{
		public static const NAME : String = "chapterListMediator"
		
		public function ChapterListMediator(viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
			
		}
		
		override public function onRegister():void
		{
			viewComponent.addEventListener(ChapterList.CHAPTER_LIST_READY, onChapterListReady);
			viewComponent.addEventListener(ChapterEvent.CHAPTER_CLICKED, onChapterClicked);
		}
		
		override public function listNotificationInterests():Array
		{
			var arr : Array = new Array("activeChapterChanged", "activeChapterChangeFailed", NotificationStrings.CHAPTERS_UI_READY);
			return arr;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName() )
			{
				case "activeChapterChanged":
					(viewComponent as ChapterList).selectedChapterId = notification.getBody().activeChapter;
					break;
				case "activeChapterChangeFailed":
					break;
				case NotificationStrings.CHAPTERS_UI_READY:
					(viewComponent as ChapterList).allowClicks();
					break;
			}
		}
		
		protected function onChapterListReady (e : Event) : void
		{
			sendNotification (NotificationStrings.CHAPTERS_UI_READY);
		}
		
		protected function onChapterClicked (e : ChapterEvent) : void
		{
			sendNotification( "skipToChapter", {id: e.chapterId} );	
		}
	}
}