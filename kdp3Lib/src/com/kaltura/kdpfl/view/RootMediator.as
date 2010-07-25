package com.kaltura.kdpfl.view
{
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.view.controls.PreLoader;
	import com.kaltura.kdpfl.view.controls.PreLoaderMediator;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class RootMediator extends Mediator
	{
		public static const NAME:String = 'stageMediator';
		
		private var _kdp3Preloader : PreLoader;
		
		/**
		 * Constructor 
		 * @param viewComponent
		 * 
		 */		
		public function RootMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			if(root.stage == root.parent)
				root.stage.addEventListener(Event.RESIZE, onResize);
			else
				root.parent.addEventListener(Event.RESIZE, onResize);
		}
		/**
		 * Handle the notification in root interests 
		 * @param note
		 * 
		 */		
		override public function handleNotification(note:INotification):void
		{
			//trace("StageMediator - handleNotification - note.getName(): " + note.getName() );
			
			switch(note.getName())
			{
				case NotificationType.PLAYER_DIMENSION_CHANGE:
					onResize();
				break;
				case NotificationType.CLOSE_FULL_SCREEN:
					root.stage.displayState=StageDisplayState.NORMAL;
				break;
				case NotificationType.OPEN_FULL_SCREEN:
					try{
						root.stage.displayState=StageDisplayState.FULL_SCREEN;
					} catch(e:Error)
					{
						trace("fullscrren action failed. make sure you have flash tag 'allowFullScreen' with value 'true' in your embed code");
					}
				break;
			}
		}
		
		/**
		 * Add views - Register mediators
		 */		
		override public function onRegister():void
		{
			//TODO: add this child to the player continer so it will be in it's center and not in the root center
			_kdp3Preloader = new PreLoader();
			root.addChild(_kdp3Preloader);
			facade.registerMediator(new PreLoaderMediator(_kdp3Preloader));

			//create the alert mediator
			
			onResize();
		}
				
		/**
		 * The notification that the root need to listen to 
		 * @return 
		 * 
		 */		
		override public function listNotificationInterests():Array
		{
			return [
					NotificationType.PLAYER_DIMENSION_CHANGE,
					NotificationType.CLOSE_FULL_SCREEN,
					NotificationType.OPEN_FULL_SCREEN
				   ];
		}
		
		/**
		 * When the root is resize we need to whom needed resize  
		 * @param event
		 * 
		 */		
		public function onResize( event : Event = null ):void
		{
			var size : Object
			//if this is standalone application the root parent is the stage so resize by it
			if(root.stage && root.parent && root.stage == root.parent)
			{
				size = {width:root.stage.stageWidth, height:root.stage.stageHeight};
			}
			else
			{
				//if the KDP was loaded using a flex application SWFLoader get its dimensions
				if(root.parent && root.parent is Loader &&
					getQualifiedClassName(root.parent.parent).split("::")[1] == "SWFLoader")
				{
					size = {width:root.parent.parent.width, height:root.parent.parent.height};
				}
				else
				{
					// use the requested dimensions of the KDP3 as set by the loading application	 
					size = {width:root.width,height:root.height};
				}
			}
			
 			if( _kdp3Preloader && root.contains(_kdp3Preloader) )
			{
				_kdp3Preloader.width = size.width;
				_kdp3Preloader.height = size.height;
			} 
			//notify whom needed that the root size have been changed
			
			//trace("SIZE ", size.width, size.height);
			sendNotification(NotificationType.ROOT_RESIZE, size);
		}
		
		
		
		/**
		 * Get a hold of the viewComponents that this class holds 
		 * @return 
		 * 
		 */		
		public function get root() : DisplayObjectContainer{
            return viewComponent as DisplayObjectContainer;
        }
		
	}
}