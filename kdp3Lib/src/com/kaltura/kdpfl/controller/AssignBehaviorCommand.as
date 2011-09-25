package com.kaltura.kdpfl.controller
{
	import com.kaltura.kdpfl.component.ComponentData;
	import com.kaltura.kdpfl.controller.media.PostSequenceEndCommand;
	import com.kaltura.kdpfl.controller.media.PreSequenceEndCommand;
	import com.kaltura.kdpfl.model.LayoutProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.view.controls.ComboFlavorMediator;
	import com.kaltura.kdpfl.view.controls.FullscreenMediator;
	import com.kaltura.kdpfl.view.controls.FuncWrapper;
	import com.kaltura.kdpfl.view.controls.PlayMediator;
	import com.kaltura.kdpfl.view.controls.ScreensMediator;
	import com.kaltura.kdpfl.view.controls.ScrubberMediator;
	import com.kaltura.kdpfl.view.controls.TimerMediator;
	import com.kaltura.kdpfl.view.controls.VolumeMediator;
	import com.kaltura.kdpfl.view.controls.WatermarkMediator;
	import com.kaltura.kdpfl.view.media.KMediaPlayer;
	import com.kaltura.kdpfl.view.media.KMediaPlayerMediator;
	
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * This class is responsible for registering command and mediators that "come to life" after the initial load of the skin and ui components.
	 */	
	public class AssignBehaviorCommand extends SimpleCommand
	{
		/**
		 * Goes over the visual components of the layout and registers their mediators.
		 * @param note
		 */		
		override public function execute(note:INotification):void
		{
			var layoutProxy:LayoutProxy = facade.retrieveProxy(LayoutProxy.NAME) as LayoutProxy;
				
			for each(var comp:ComponentData in layoutProxy.components)
			{
				//register mediator if needed
				switch(comp.className)
				{
					case "KMediaPlayer":
						facade.registerMediator( new KMediaPlayerMediator( KMediaPlayerMediator.NAME , comp.ui as KMediaPlayer ) );
					break;
					case "KScrubber":
						facade.registerMediator( new ScrubberMediator(comp.ui) );
					break;
					case "KTimer":
						facade.registerMediator( new TimerMediator(comp.ui) );
					break;
					case "KVolumeBar":
						facade.registerMediator( new VolumeMediator( comp.ui ) );
					break;
					case "KFlavorComboBox":
						facade.registerMediator( new ComboFlavorMediator( comp.ui ) );
					break
					case "Screens":
						facade.registerMediator( new ScreensMediator( comp.ui ) );
					break;
					case "Watermark":
						facade.registerMediator( new WatermarkMediator( comp.ui ) );
					break;
				}
				
				//If the component has a "command" attribute, register a special mediator for said component.
				switch(comp.attr["command"])
				{
					case "play":
						facade.registerMediator(new PlayMediator(comp.ui));
					break;
					case "fullScreen":
						facade.registerMediator(new FullscreenMediator(comp.ui));
					break;
				}
				//If the component has a "kClick" attribute, register a function to be executed when the component is clicked
				if(comp.attr["kClick"])
				{
					new FuncWrapper(facade, comp.ui as IEventDispatcher, MouseEvent.CLICK, comp.attr["kClick"]);
				}
				
				for (var att : String in comp.attr)
				{
					if (att.indexOf("kevent_") != -1)
					{
						new FuncWrapper(facade, comp.ui as IEventDispatcher, att.replace("kevent_", ""), comp.attr[att]);
					}
				}
			}
			
			var sequenceProxy : SequenceProxy = facade.retrieveProxy( SequenceProxy.NAME ) as SequenceProxy;
			
			facade.registerCommand( NotificationType.PRE_SEQUENCE_COMPLETE , PreSequenceEndCommand );

			facade.registerCommand( NotificationType.POST_SEQUENCE_COMPLETE , PostSequenceEndCommand );
			
			facade.registerCommand( NotificationType.MID_SEQUENCE_COMPLETE , MidSequenceEndCommand );
				
			//dispacth layout ready
			sendNotification(NotificationType.LAYOUT_READY);
		}	
	}
}