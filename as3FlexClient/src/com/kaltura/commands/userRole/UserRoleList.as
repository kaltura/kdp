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
package com.kaltura.commands.userRole
{
	import com.kaltura.vo.KalturaUserRoleFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.userRole.UserRoleListDelegate;
	import com.kaltura.net.KalturaCall;

	/**
	 * Lists user role objects that are associated with an account.
	 * Blocked user roles are listed unless you use a filter to exclude them.
	 * Deleted user roles are not listed unless you use a filter to include them.
	 * 
	 **/
	public class UserRoleList extends KalturaCall
	{
		public var filterFields : String;
		
		/**
		 * @param filter KalturaUserRoleFilter
		 * @param pager KalturaFilterPager
		 **/
		public function UserRoleList( filter : KalturaUserRoleFilter=null,pager : KalturaFilterPager=null )
		{
			service= 'userrole';
			action= 'list';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			if (filter) { 
 			keyValArr = kalturaObject2Arrays(filter, 'filter');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
 			} 
 			if (pager) { 
 			keyValArr = kalturaObject2Arrays(pager, 'pager');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
 			} 
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new UserRoleListDelegate( this , config );
		}
	}
}
