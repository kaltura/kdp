package com.kaltura.puremvc.as3.patterns.mediator
{
	public class SequenceMultiMediator extends MultiMediator
	{
		protected var preSequenceNotificationStartName:String ="";
		protected var preSequenceNotificationEndName:String ="";
		protected var postSequenceNotificationStartName:String ="";
		protected var postSequenceNotificationEndName:String ="";
		private var _preSequence : int;
		private var _postSequence : int;
		
		public function SequenceMultiMediator(viewComponent:Object=null)
		{
			super(viewComponent);
		}
		
		public function set preSequence( index : int ) : void 
		{
			_preSequence = index;
			preSequenceNotificationStartName = "pre" + _preSequence + "start";
			
		}
		
		public function set postSequence( index : int ) : void 
		{
			_postSequence = index;
			postSequenceNotificationStartName = "post" + _postSequence + "start";
		}
		public function get preSequence () : int
		{
			return _preSequence;
		}
		public function get postSequence () : int
		{
			return _postSequence;
		}
		
		
	
	}
}