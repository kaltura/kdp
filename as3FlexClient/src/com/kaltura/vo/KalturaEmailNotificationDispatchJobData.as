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
package com.kaltura.vo
{
	import com.kaltura.vo.KalturaEmailNotificationRecipientJobData;

	import com.kaltura.vo.KalturaEmailNotificationRecipientJobData;

	import com.kaltura.vo.KalturaEmailNotificationRecipientJobData;

	import com.kaltura.vo.KalturaEmailNotificationRecipientJobData;

	import com.kaltura.vo.KalturaEventNotificationDispatchJobData;

	[Bindable]
	public dynamic class KalturaEmailNotificationDispatchJobData extends KalturaEventNotificationDispatchJobData
	{
		/**
		 * Define the email sender email
		 * 
		 **/
		public var fromEmail : String = null;

		/**
		 * Define the email sender name
		 * 
		 **/
		public var fromName : String = null;

		/**
		 * Email recipient emails and names, key is mail address and value is the name
		 * 
		 **/
		public var to : KalturaEmailNotificationRecipientJobData;

		/**
		 * Email cc emails and names, key is mail address and value is the name
		 * 
		 **/
		public var cc : KalturaEmailNotificationRecipientJobData;

		/**
		 * Email bcc emails and names, key is mail address and value is the name
		 * 
		 **/
		public var bcc : KalturaEmailNotificationRecipientJobData;

		/**
		 * Email addresses that a replies should be sent to, key is mail address and value is the name
		 * 
		 **/
		public var replyTo : KalturaEmailNotificationRecipientJobData;

		/**
		 * Define the email priority
		 * 
		 * @see com.kaltura.types.KalturaEmailNotificationTemplatePriority
		 **/
		public var priority : int = int.MIN_VALUE;

		/**
		 * Email address that a reading confirmation will be sent to
		 * 
		 **/
		public var confirmReadingTo : String = null;

		/**
		 * Hostname to use in Message-Id and Received headers and as default HELO string.
		 * If empty, the value returned by SERVER_NAME is used or 'localhost.localdomain'.
		 * 
		 **/
		public var hostname : String = null;

		/**
		 * Sets the message ID to be used in the Message-Id header.
		 * If empty, a unique id will be generated.
		 * 
		 **/
		public var messageID : String = null;

		/**
		 * Adds a e-mail custom header
		 * 
		 **/
		public var customHeaders : Array = null;

		/**
		 * Define the content dynamic parameters
		 * 
		 **/
		public var contentParameters : Array = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('fromEmail');
			arr.push('fromName');
			arr.push('to');
			arr.push('cc');
			arr.push('bcc');
			arr.push('replyTo');
			arr.push('priority');
			arr.push('confirmReadingTo');
			arr.push('hostname');
			arr.push('messageID');
			arr.push('customHeaders');
			arr.push('contentParameters');
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			return arr;
		}
	}
}
