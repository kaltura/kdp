package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.vo.KalturaBaseEntry;
	
	import mx.utils.ObjectProxy;

	[Bindable]
	/**
	 * This class represents related entry object 
	 * @author michalr
	 * 
	 */	
	public class RelatedEntryVO extends ObjectProxy
	{
		/**
		 * Kaltura entry object 
		 */		
		public var entry:KalturaBaseEntry;
		/**
		 * is this the next selected entry 
		 */		
		public var isUpNext:Boolean;
		
		public var isOver:Boolean;
		
		public function RelatedEntryVO(entry:KalturaBaseEntry, isUpNext:Boolean = false)
		{
			this.entry = entry;
			this.isUpNext = isUpNext;
		}
	}
}