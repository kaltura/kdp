/*
Error.as

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

Defining the define error numbers.

*/
package com.eyewonder.instream.parser.errors {
	
public dynamic class Errors {
	protected var _parseErrorArray : Array;
	
	// Do NOT change the numbers after release. Publishers will rely on these numbers
	//Stand errors start at 0
	public const ERROR_BASE:Object = 			{id:0,	desc:"No error"};
	
	//  Standard warnings start at 5000
	public const WARNING_BASE:Object = 			{id:5000,	desc:"No error"};
	
	//  Tag format specific errors start at 10000. Change these in the subclass
	public const TAG_ERROR_BASE:Object = 		{id:10000,	desc:"No error"};
	
	//  Tag format specific warnings start at 15000. Change these in the subclass
	public const TAG_WARNING_BASE:Object = 		{id:15000,	desc:"No error"};
	
	//  Publisher-specific miscellaneous errors start at 20000
	public const PUB_ERROR_BASE:Object = 		{id:20000,	desc:"No error"};
	
	//  Publisher-specific miscellaneous warnings start at 25000
	public const PUB_WARNING_BASE:Object = 		{id:25000,	desc:"No error"};
		
	public function Errors()
	{
		_parseErrorArray = new Array();
	}
	
	protected function defineError(error:Object) : void
	{
        _parseErrorArray[error.id] = error;
	}
	
}
}
