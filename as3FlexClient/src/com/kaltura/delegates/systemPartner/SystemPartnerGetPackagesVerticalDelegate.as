// ===================================================================================================
//                           _  __     _ _
//                          | |/ /__ _| | |_ _  _ _ _ __ _
//                          | ' </ _` | |  _| || | '_/ _` |
//                          |_|\_\__,_|_|\__|\_,_|_| \__,_|
//
// This file is part of the Kaltura Collaborative Media Suite which allows users
// to do with audio, video, and animation what Wiki platfroms allow them to do with
// text.
//
// Copyright (C) 2006-2011  Kaltura Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
// @ignore
// ===================================================================================================
package com.kaltura.delegates.systemPartner
{
	import com.kaltura.vo.KalturaSystemPartnerPackage;KalturaSystemPartnerPackage;;

	import com.kaltura.core.KClassFactory;

	import com.kaltura.config.KalturaConfig;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.delegates.WebDelegateBase;
	import flash.utils.getDefinitionByName;

	public class SystemPartnerGetPackagesVerticalDelegate extends WebDelegateBase
	{
		public function SystemPartnerGetPackagesVerticalDelegate(call:KalturaCall, config:KalturaConfig)
		{
			super(call, config);
		}

		override public function parse(result:XML) : *
		{
			var arr : Array = new Array();
			for( var i:int=0; i<result.result.children().length() ; i++)
			{
				var cls : Class = getDefinitionByName('com.kaltura.vo.'+ result.result.children()[i].objectType) as Class;
				var obj : * = (new KClassFactory( cls )).newInstanceFromXML( XMLList(result.result.children()[i]) );
				arr.push(obj);
			}
			return arr;
		}

	}
}
