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
    import flash.utils.Dictionary;

    /**
     * IMap implementation which dynamically creates a HashMap of
     * key and value pairs as well as provides a atandard API for
     * working with the HashMap
     */
    dynamic public class HashMap extends Dictionary implements IMap
    {
    	/**
    	 *Constrcutor.
    	 */
    	public function HashMap ():void
    	{
    		super (true);
    	}

        /**
         * Adds a key / value to the current Map
         *
         * @param the key to add to the map
         * @param the value of the specified key
         */
        public function put(key:String, value:*):void
        {
            this[key] = value;
        }

        /**
         * reset a value of a key in the current Map
         *
         * @param the key to which to change value in the map
         * @param the value of the specified key
         */
        public function setValue(key:String, value:*):void
        {
        	if (this[key] != null) delete this[key];
        	this[key] = value;
        }

        /**
         * Removes a key / value from the current Map
         *
         * @param the key to remove from the map
         */
        public function remove(key:String):void
        {
            this[key] = null;
            delete this[key];
        }

        /**
         * Determines if a key exists in the current map
         *
         * @param  the key in which to determine existance in the map
         * @return true if the key exisits, false if not
         */
        public function containsKey(key:String):Boolean
        {
            return this[key] != null;
        }

        /**
         * Determines if a value exists in the current map
         *
         * @param  the value in which to determine existance in the map
         * @return true if the value exisits, false if not
         */
        public function containsValue(value:*):Boolean
        {
            for (var prop:String in this) {

                if (this[prop] === value)
                {
                    return true;
                }
            }
            return false;
        }

        /**
         * Returns a key value from the current Map
         *
         * @param  the key in which to retrieve the value of
         * @return the value of the specified key
         */
        public function getValue(key:String):*
        {
            if (this[key] != null)
            {
                return this[key];
            }
        }

        /**
         * Returns a value key from the current Map
         *
         * @param  the value in which to retrieve the key of
         * @return the key of the specified value
         */
        public function getKey(value:*):String
        {
        	var ret:*;
            for (var prop:String in this) {

                if (this[prop] === value)
                {
                    ret = prop;
                }
            }
            return ret;
        }

        /**
         * Returns the size of this map
         *
         * @return the current size of the map instance
         */
        public function size():int
        {
            var size:int = 0;

            for (var prop:String in this) {

                if (this[prop] != null)
                {
                    ++size;
                }
            }
            return size;
        }

        /**
         * Determines if the current map is empty
         *
         * @return true if the current map is empty, false if not
         */
        public function isEmpty():Boolean
        {
            var size:int = 0;

            for (var prop:String in this) {

                if (this[prop] != null)
                {
                    size++;
                }
            }
            return size <= 0;
        }

        /**
         * Resets all key / values in map to null
         */
        public function clear():void
        {
            for (var prop:String in this) {

                this[prop] = null;
            }
        }

        /**
         *creates a string representation of the contents sperated by commas.
         * <p>ie. for hashMap that contains:<br />
         * <code>
         * 	var a:HashMap = new HashMap ();
         *  a["element1"] = 12312; <br />
         * 	a["element2"] = asdas; <br />
         * 	a["element3"] = 45645; <br />
         * </code> a.toString(); will return: <code>"12312, asdas, 45645"</code></p>
         * @return 	String representation of the map's contents.
         */
        public function toString():String
        {
        	var str:String = "";
        	for (var prop:String in this)
        	{
                if (this[prop] != null)
                {
                    str += this[prop] + ", ";
                }
            }
            return str;
        }
    }
}