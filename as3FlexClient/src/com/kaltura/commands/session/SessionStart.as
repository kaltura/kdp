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
package com.kaltura.commands.session
{
	import com.kaltura.delegates.session.SessionStartDelegate;
	import com.kaltura.net.KalturaCall;

	/**
	 * Start a session with Kaltura's server.
	 * The result KS is the session key that you should pass to all services that requires a ticket.
	 * 
	 **/
	public class SessionStart extends KalturaCall
	{
		public var filterFields : String;
		
		/**
		 * @param secret String
		 * @param userId String
		 * @param type int
		 * @param partnerId int
		 * @param expiry int
		 * @param privileges String
		 **/
		public function SessionStart( secret : String,userId : String='',type : int=0,partnerId : int=int.MIN_VALUE,expiry : int=86400,privileges : String = null )
		{
			service= 'session';
			action= 'start';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('secret');
			valueArr.push(secret);
			keyArr.push('userId');
			valueArr.push(userId);
			keyArr.push('type');
			valueArr.push(type);
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
			delegate = new SessionStartDelegate( this , config );
		}
	}
}
