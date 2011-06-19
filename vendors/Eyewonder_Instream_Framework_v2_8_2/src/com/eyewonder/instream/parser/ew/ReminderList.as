/*
ReminderList.as

Universal Instream Framework
Copyright (c) 2006-2009, Eyewonder, Inc
All Rights Reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.
 * Neither the name of Eyewonder, Inc nor the
 names of contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY Eyewonder, Inc ''AS IS'' AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Eyewonder, Inc BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

This file should be accompanied with supporting documentation and source code.
If you believe you are missing files or information, please 
contact Eyewonder, Inc (http://www.eyewonder.com)



Description
-----------


*/
package com.eyewonder.instream.parser.ew 
{
	import com.eyewonder.instream.parser.base.ReminderListBase;
	
	/**
	 * @author mgolomb
	 */
	public dynamic class ReminderList extends ReminderListBase 
	{
		
		public function ReminderList() 
		{
			clear();
		}
	
		public function replaceAt(position:Number, reminder:ReminderUnit):void
		{
			if (position < 0) position = 0;
			reminderArray[position] = reminder;
			numReminders = reminderArray.length;
		}
		
		public function add(reminder:ReminderUnit):void
		{
			reminderArray.push(reminder);
			numReminders = reminderArray.length;
		}
		
		public function clear():void
		{
			reminderArray = new Array(0);
		}
		
		public function getOldest():ReminderUnit
		{
//			var oldestUnit:ReminderUnit = reminderArray.shift() as ReminderUnit;
			var oldestUnit:Object = reminderArray.shift();// as ReminderUnit;
			numReminders = reminderArray.length;
			return oldestUnit as ReminderUnit;
		}
		
		public function getNewest():ReminderUnit
		{
			var newestUnit:ReminderUnit = reminderArray.pop();
			numReminders = reminderArray.length;
			return newestUnit;
		}
		
		public function get reminderArray():Array
		{
			return _reminderArray;
		}
		
		public function set reminderArray(arr:Array):void
		{
			_reminderArray = arr;
		}
		
		public function get numReminders():Number
		{
			return _numReminders;
		}
		
		public function set numReminders(num:Number):void
		{
			_numReminders = num;
		}
		
	}
	
}
