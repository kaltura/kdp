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
package com.kaltura.dataStructures
{

    /**
     * Defines the contract for HashMap implementations
     */
    public interface IMap
    {
        /**
         * Adds a key / value to the current Map
         */
        function put(key:String, value:*):void

        /**
         * reset a value of a key in the current Map
         */
        function setValue(key:String, value:*):void

        /**
         * Removes a key / value from the current Map
         */
        function remove(key:String):void

        /**
         * Returns a key value from the current Map
         */
        function getValue(key:String):*

         /**
         * Returns a value key from the current Map
         */
        function getKey(value:*):String

        /**
         * Determines if a key exists in the current map
         */
        function containsKey(key:String):Boolean

        /**
         * Determines if a value exists in the current map
         */
        function containsValue(value:*):Boolean

        /**
         * Returns the size of this map
         */
        function size():int

        /**
         * Determines if the current map is empty
         */
        function isEmpty():Boolean


        /**
         * Resets all key / values in map to null
         */
        function clear():void
    }
}