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
package com.kaltura.plugin.logic.properties.restrictions
{
	import com.kaltura.utils.KStringUtil;

	/**
	 * RestrictionsFactory creates object of type BaseRestriction that reference to a
	 * concrete restriction instance the given type.
	 * Implements a factory method pattern to perform the above action.
	 */
	public class RestrictionFactory
	{
		public static function newRestriction(sType:String):BaseRestriction
		{
			var restriction:BaseRestriction;
			sType = KStringUtil.camelize(sType).toLowerCase();
			switch (sType)
			{
				case RestrictionTypes.RestrictionNumber:
					restriction = new RestrictionNumber();
					break;
				case RestrictionTypes.RestrictionString:
					restriction = new RestrictionString();
					break;
				case RestrictionTypes.RestrictionUint:
					restriction = new RestrictionUint();
					break;
				default:
					throw new Error("RestrictionFactory class doesn't support the passed type '" + sType + "'");
					break;
			}
			return restriction;
		}
	}
}