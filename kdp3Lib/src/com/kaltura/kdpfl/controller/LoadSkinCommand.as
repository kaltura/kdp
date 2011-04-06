package com.kaltura.kdpfl.controller
{
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.style.KStyleManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.AsyncCommand;

	/**
	 * This class is responsible for loading KDP skin file 
	 */
	public class LoadSkinCommand extends AsyncCommand implements IResponder
	{
		/**
		 * load KDP skin 
		 * @param notification
		 */		
		override public function execute(notification:INotification):void
		{
			var styleManager:KStyleManager = new KStyleManager(this);
			styleManager.loadStyles();
		}

		/**
		 * notify app that load succeeded
		 * @param data
		 */		
		public function result(data:Object):void
		{
			facade.sendNotification( NotificationType.SKIN_LOADED );
			commandComplete();
		}
		
		/**
		 * notify app that load failed 
		 * @param data
		 */		
		public function fault(data:Object):void
		{
			facade.sendNotification( NotificationType.SKIN_LOAD_FAILED );
			commandComplete();
		}

	}
}