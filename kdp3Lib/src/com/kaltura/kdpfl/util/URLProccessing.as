package com.kaltura.kdpfl.util
{
	import mx.utils.Base64Encoder;
	
	public class URLProccessing
	{
		/**
		 * the path for the clipper service.
		 */
		static public var urlClipVideo:String = "flvclipper/entry_id/";
		
		/**
		 * this part is used to track the partner and sub_p when using cdn, will come as the first part of the request after
		 * the baseUrl of the cdn.
		 */
		static private var partnerInfoForTracking:String = "/p/#p#/sp/#sp#/";
		
		/**
		 * build the partner info part of the requests that require tracking (when using cdn).
		 * @param p_id		the partner id
		 * @param subp_id	the sub_partner id
		 */
		static public function getPartnerPartForTracking ( partnerId:String = null , subpId:String = null ):String
		{
			var partnerPart:String = partnerInfoForTracking;
			if(partnerId)
			{
				partnerPart = partnerPart.replace("#p#", partnerId);
				if(!subpId) subpId = partnerId + "00";
				partnerPart = partnerPart.replace("#sp#", subpId);
			}
			return partnerPart;
		}
	
	}
}