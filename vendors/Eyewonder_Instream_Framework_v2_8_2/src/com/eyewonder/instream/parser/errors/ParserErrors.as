/*
ParserErrors.as

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

Class organizes all the errors by id numbers and description. Used by the parser.

*/
package com.eyewonder.instream.parser.errors {
	
import com.eyewonder.instream.parser.errors.Errors;
import com.eyewonder.instream.parser.events.ParserErrorEvent;

	public dynamic class ParserErrors extends Errors {
	// Standard errorsg
	// Do NOT change the numbers after release. Publishers may rely on these numbers (but shouldn't)
	public const ERROR_UNKNOWN:Object = 		{id:1,	desc:"Unknown XML error"};
	public const ERROR_URLNOTFOUND:Object = 	{id:2,	desc:"URL not found"};
	public const ERROR_CAPPEDTAG:Object = 		{id:3,	desc:"Capped ad tag"};
	public const ERROR_INVALIDTAG:Object = 		{id:4,	desc:"Invalid ad tag"};
	public const ERROR_MALFORMEDXML:Object = 	{id:5,	desc:"Malformed XML data"};
	
	public function ParserErrors()
	{
		super();
		defineError(ERROR_BASE);
		defineError(ERROR_UNKNOWN);
		defineError(ERROR_URLNOTFOUND);
		defineError(ERROR_CAPPEDTAG);
		defineError(ERROR_INVALIDTAG);
		defineError(ERROR_MALFORMEDXML);
		
		//_parseErrorArray.forEach(traceError);
	}
	
	public function traceError(item:Object, index:int, array:Array) : void
	{
		var msg:String = new String();
		var id:Number = item.id;
		var desc:String = item.desc;

		if (id >=	ERROR_BASE.id)
		{
			if (id >= WARNING_BASE.id)
			{
				if (id >= TAG_ERROR_BASE.id)
				{
					if (id >= TAG_WARNING_BASE.id)
					{
						if (id >= PUB_ERROR_BASE.id)
						{
							if (id >= PUB_WARNING_BASE.id)
							{	
								msg = "Publisher-specific XML Warning: ";
							}
							else
							{
								// PUB_ERROR_BASE
								msg = "Publisher-specific XML Warning: ";
							}
						}
						else
						{
							// TAG_WARNING_BASE
							msg = "Tag format specific XML Warning: ";
						}
					}
					else
					{
						// TAG_ERROR_BASE
						msg = "Tag format specific XML Error: ";
					}
				}
				else
				{
					// WARNING_BASE
					msg = "XML Warning: ";
				}
			}
			else
			{
				// ERROR_BASE
				msg = "XML Error: ";
			}
		}
		trace(msg +"#"+ id +" "+ desc);
    }
    
    public function getErrorEvent(id:int) : ParserErrorEvent
    {
    	return new ParserErrorEvent(ParserErrorEvent.XML_ERROR, id, _parseErrorArray[id].desc);
    }
}
}
