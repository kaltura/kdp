/*
InstreamFrameworkUtility.as

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

EyeWonder instream framework Flash-in-Flash Interface
	
A class that manipulates Strings for the Universal Instream Framework. 
 
This module contains useful utilities for string manipulation, etc

 Don't rename this class. Instead, extend it if you would like to use a different class name
 See legacy class IInstreamFramework for an example
*/
package com.eyewonder.instream.modules
{
 
public dynamic class InstreamFrameworkUtility {

	
	/* Replace searchStr in origStr with replaceStr and then returns the new string. This is a global replace */
	public static function strreplace (origStr:String, searchStr:String, replaceStr:String):String
	{
		var result:Array = origStr.split(searchStr); 
		return result.join(replaceStr);
	}
	
	/* Replace searchStr in origStr with replaceStr only n times*/
	public static function strnreplace(origStr:String, searchStr:String, replaceStr:String, nReplaces:Number):String
	{
		var counter:Number,i:Number = 0;	
		var newStr:String = origStr;
		while (counter<newStr.length) 
		{
			var matchLoc:Number = newStr.indexOf(searchStr, counter);
			if (matchLoc == -1) {
				break;
			} 
			else 
			{
				if (i == nReplaces) counter = newStr.length;
				var beforeStr:String = newStr.substr(0, matchLoc);
				var afterStr:String = newStr.substr(matchLoc+searchStr.length, newStr.length);
				newStr = beforeStr+replaceStr+afterStr;
				counter = beforeStr.length+replaceStr.length;
				i++;
			}
		}
		return newStr;
	}
}

/* End package */

}