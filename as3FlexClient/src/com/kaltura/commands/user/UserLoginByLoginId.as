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
package com.kaltura.commands.user
{
	import com.kaltura.delegates.user.UserLoginByLoginIdDelegate;
	import com.kaltura.net.KalturaCall;

	/**
	 * Logs a user into a partner account with a user login ID and a user password.
	 * 
	 **/
	public class UserLoginByLoginId extends KalturaCall
	{
		public var filterFields : String;
		
		/**
		 * @param loginId String
		 * @param password String
		 * @param partnerId int
		 * @param expiry int
		 * @param privileges String
		 **/
		public function UserLoginByLoginId( loginId : String,password : String,partnerId : int=int.MIN_VALUE,expiry : int=86400,privileges : String='*' )
		{
			service= 'user';
			action= 'loginByLoginId';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('loginId');
			valueArr.push(loginId);
			keyArr.push('password');
			valueArr.push(password);
			keyArr.push('partnerId');
			valueArr.push(partnerId);
			keyArr.push('expiry');
			valueArr.push(expiry);
			keyArr.push('privileges');
			valueArr.push(privileges);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new UserLoginByLoginIdDelegate( this , config );
		}
	}
}
