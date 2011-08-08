/*
This file is part of the Kaltura Collaborative Media Suite which allows users
to do with audio, video, and animation what Wiki platfroms allow them to do with
text.

Copyright (C) 2006-2008  Kaltura Inc.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

@ignore
*/
package com.kaltura.base.context
{
	import com.kaltura.utils.KStringUtil;

	import mx.utils.URLUtil;

	//[Bindable]
	public class PartnerInfo
	{
		public var ks:String = "";
		public var uid:String = "";
		public var partner_id:String = "";
		public var subp_id:String = "";

		public function get partnerId ():String { return partner_id; }
		public function get subpId ():String { return subp_id; }
		public function set partnerId (id:String):void { partner_id = id; }
		public function set subpId (id:String):void { subp_id = id; }

		/**
		 *Constructor.
		 * @param partner_info		a dynamic object with the parameters of a partner info.
		 */
		public function PartnerInfo (partner_info:Object = null):void
		{
			if (partner_info)
			{
				ks = partner_info.ks.toString();
				uid = partner_info.uid.toString();
				if (partner_info.hasOwnProperty("partner_id"))
					partnerId = partner_info.partner_id.toString();
				else
					partnerId = partner_info.partnerId.toString();
				if (partner_info.hasOwnProperty("subp_id"))
					subpId = partner_info.subp_id.toString();
				else
					subpId = partner_info.subpId.toString();
			}
		}

		/**
	    * parese partner info object as url string represented as "name=value" pairs.
	    * @return 			the partner info represented as url.
	    */
	   	public function toUrlString ():String
		{
			var partnerInfoStr:String = "";
			if (partnerId != "")
				partnerInfoStr += "partner_id=" + escape(partnerId.toString());
			if (subpId != "")
				partnerInfoStr += "&subp_id=" + escape(subpId.toString());
			if (uid != "")
				partnerInfoStr += "&uid=" + escape(uid.toString());
			if (ks != "")
				partnerInfoStr += "&ks=" + escape(ks);
			if (partnerInfoStr.substr(0,1) == "&")
				partnerInfoStr = partnerInfoStr.substr(1);
			return partnerInfoStr;
		}

		/**
		 *parses url string to get the partner info.
		 * @param urlVars	a string url that holds the partner info variables.
		 * @return			the partnerInfo object.
		 */
		public function fromUrlString (urlVars:String):Object
		{
			var partnerObj:Object = URLUtil.stringToObject(urlVars, "&");
			partnerObj = KStringUtil.camelizeObjectParams(partnerObj);
			partnerObj = KStringUtil.underscoreObjectParams(partnerObj);
			if (partnerObj.hasOwnProperty("ks"))
				ks = partnerObj.ks;
			if (partnerObj.hasOwnProperty("uid"))
				uid = partnerObj.uid;
			if (partnerObj.hasOwnProperty("partnerId"))
				partnerId = partnerObj.partnerId;
			if (partnerObj.hasOwnProperty("subpId"))
				subpId = partnerObj.subpId;
			return partnerObj;
		}
	}
}