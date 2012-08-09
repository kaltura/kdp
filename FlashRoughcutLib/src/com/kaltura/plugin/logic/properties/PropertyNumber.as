/*
This file is part of the Kaltura Collaborative Media Suite which allows users 
to do with audio, video, and animation what Wiki platfroms allow them to do with 
text.

Copyright (C) 2006-2008  Kaltura Inc.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

@ignore
*/
package com.kaltura.plugin.logic.properties
{
	import com.kaltura.plugin.events.RestrictionErrorEvent;
	import com.kaltura.plugin.logic.properties.restrictions.BaseRestriction;
	import com.kaltura.plugin.logic.properties.restrictions.RestrictionNumber;
	
	/**
	 * PropertyNumber is a concrete property (extends @Property [Property]).
	 * It enables Number based restriction like range and type validations
	 * 
	 */	
	public class PropertyNumber extends Property
	{	
		/**
		 * 
		 * @param xmlPropertyDef
		 * 
		 */		
		public override function setDefinition(restriction:BaseRestriction):void
		{
			super.setDefinition(restriction);
			RestrictionNumber(_Restriction).addEventListener(RestrictionErrorEvent.STEP_ERROR, dispatchErrors);
		}
		public function dispatchErrors(evtRestrictionError:RestrictionErrorEvent):void
		{
			if (evtRestrictionError.correctValue)
			{
				_nValue = evtRestrictionError.correctValue;
			}
			dispatchEvent(evtRestrictionError);
		}
		protected var _nValue:Number;
		/**
		 * @inheritDoc
		 */	
		public override function set value(newValue:*):void
		{
			_nValue = newValue;
			super.value = newValue;
		}
		/**
		 * @inheritDoc
		 */	
		public override function get value():*
		{
			return _nValue;
		}

	}
}