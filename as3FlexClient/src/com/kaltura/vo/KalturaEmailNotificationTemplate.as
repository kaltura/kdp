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
	import com.kaltura.vo.KalturaEmailNotificationRecipientProvider;

	import com.kaltura.vo.KalturaEmailNotificationRecipientProvider;

	import com.kaltura.vo.KalturaEmailNotificationRecipientProvider;

	import com.kaltura.vo.KalturaEmailNotificationRecipientProvider;

	import com.kaltura.vo.KalturaEventNotificationTemplate;

	[Bindable]
	public dynamic class KalturaEmailNotificationTemplate extends KalturaEventNotificationTemplate
	{
		/**
		* Define the email body format
		* 
		* @see com.kaltura.types.KalturaEmailNotificationFormat
		**/
		public var format : String = null;

		/**
		* Define the email subject
		* 
		**/
		public var subject : String = null;

		/**
		* Define the email body content
		* 
		**/
		public var body : String = null;

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
		* Email recipient emails and names
		* 
		**/
		public var to : KalturaEmailNotificationRecipientProvider;

		/**
		* Email recipient emails and names
		* 
		**/
		public var cc : KalturaEmailNotificationRecipientProvider;

		/**
		* Email recipient emails and names
		* 
		**/
		public var bcc : KalturaEmailNotificationRecipientProvider;

		/**
		* Default email addresses to whom the reply should be sent.
		* 
		**/
		public var replyTo : KalturaEmailNotificationRecipientProvider;

		/**
		* Define the email priority
		* 
		* @see com.kaltura.types.KalturaEmailNotificationTemplatePriority
		**/
		public var priority : int = int.MIN_VALUE;

		/**
		* Email address that a reading confirmation will be sent
		* 
		**/
		public var confirmReadingTo : String = null;

		/**
		* Hostname to use in Message-Id and Received headers and as default HELLO string.
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

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('format');
			arr.push('subject');
			arr.push('body');
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
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			return arr;
		}

		override public function getElementType(arrayName:String):String
		{
			var result:String = '';
			switch (arrayName) {
				case 'to':
					result = '';
					break;
				case 'cc':
					result = '';
					break;
				case 'bcc':
					result = '';
					break;
				case 'replyTo':
					result = '';
					break;
				case 'customHeaders':
					result = 'KalturaKeyValue';
					break;
				default:
					result = super.getElementType(arrayName);
					break;
			}
			return result;
		}
	}
}
