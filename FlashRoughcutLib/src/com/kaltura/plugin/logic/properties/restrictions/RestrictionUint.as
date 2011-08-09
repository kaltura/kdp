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
	import com.kaltura.plugin.events.RestrictionErrorEvent;
	/**
	 * RestrictionNumber is a concrete restriction (extends @BaseRestriction [BaseRestriction]).
	 * It enables Number based restrictions like ranges and type checking
	 */	
	public class RestrictionUint extends BaseRestriction
	{
		public static const TYPE:String = "uint"
		/**
		* The minimum allowed value.
		*/		
		protected var _nMinLimit:uint = uint.MIN_VALUE;
		/**
		* The maximum allowed value.
		*/		
		protected var _nMaxLimit:uint = uint.MAX_VALUE;
		/**
		* Non-zero unit of change between values.
		 * @default 1
		*/		
		protected var _nStepSize:uint = 1;
		
		/**
		* Indicates whether a range restriction is set
		*/		
		protected var _bRangeRestriction:Boolean = true;
		
		/**
		 * @inheritDoc
		 */		
		public override function validateData(dataToCheck:*):Boolean
		{
			var nDataToCheck:uint = uint(dataToCheck);
			/*check if the data type can be casted to Number.*/
			if ( !isNaN(nDataToCheck) ){
				if (_bRangeRestriction)
				{
					if (validateRange(nDataToCheck)){
						return true;
					} else {
						return false;
					}
				} else {
					return true;
				}
				
				//dataToCheck is not a Number 
			} else {
				dispatchEvent(new RestrictionErrorEvent(RestrictionErrorEvent.NOT_A_NUMBER));
				return false
			}
		}
		/**
		 * Sets this RestrictionNumber restrictions.
		 * Must be called one time, before calling @see #validateData() [validateData() method]
		 * @param xmlRestriction 	Describes all of the applied restriction on this RestrictionNumber
		 * 
		 */		
		public override function setRestriction(xmlRestriction:XML):void
		{
			super.setRestriction(xmlRestriction);
			if (xmlRestriction.range.length()){
				_bRangeRestriction = true;
				if (xmlRestriction.range.min.length()){
					_nMinLimit = uint(xmlRestriction.range.min.@value);
				} else {
					_nMinLimit = uint.MIN_VALUE;
				}
				if (xmlRestriction.range.max.length()){
					_nMaxLimit = uint(xmlRestriction.range.max.@value);
				} else {
					_nMaxLimit = uint.MAX_VALUE;
				}
				if (xmlRestriction.range.stepSize.length()){
					_nStepSize = xmlRestriction.range.stepSize.@value;
				}
			}
			
		}
		/**
		 * validateRange() checks if a given number is between between _nMinLimit and _nMaxLimit
		 * @param nDataToCheck A NUmber to validate according to the defined range
		 * @return 
		 * 
		 */		
		protected function validateRange(nDataToCheck:Number):Boolean
		{
			var bValidated:Boolean;
			if ( nDataToCheck <= _nMaxLimit && nDataToCheck >= _nMinLimit ) {
				
				bValidated = true;
			} else {
				dispatchEvent(new RestrictionErrorEvent(RestrictionErrorEvent.OUT_RANGE));
				bValidated = false;
			}
			var nClosest:Number = findClosest(nDataToCheck, _nStepSize);
			if (nClosest != nDataToCheck){
				dispatchEvent(new RestrictionErrorEvent(RestrictionErrorEvent.STEP_ERROR, nClosest));
			}
			return bValidated;

		}
		protected function findClosest(nValue:Number, nStepSize:Number):Number
		{
						
			var closest:Number = nStepSize * Math.round(nValue / nStepSize);
			var parts:Array = (new String(1 + nStepSize)).split(".");
			if (parts.length == 2)
			{
				var scale:Number = Math.pow(10, parts[1].length);
				closest = Math.round(closest * scale) / scale;
			}
			return closest;
		}
		
		/**
		 * This Restriction min value
		 * @return 
		 * 
		 */		
		public function get min():Number
		{
			return _nMinLimit;
		}
		/**
		 * This Restriction max value
		 * @return 
		 * 
		 */	
		public function get max():Number
		{
			return _nMaxLimit;
		}
		/**
		 * Non-zero unit of change between values.
		 * @return 
		 * 
		 */		
		public function get stepSize():Number
		{
			return _nStepSize;
		}
		
		public override function getType():String
		{
			return TYPE;
		}
	}
}