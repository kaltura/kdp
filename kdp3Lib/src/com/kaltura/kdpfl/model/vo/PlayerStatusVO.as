package com.kaltura.kdpfl.model.vo
{
	public class PlayerStatusVO
	{
		public var kdpStatus : String;
		public var kdpVersion : String;
		
		public function PlayerStatusVO(version : String)
		{
			kdpVersion  = version;
		}
	}
}