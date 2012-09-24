////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2005-2007 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package mx.collections 
{
    
import flash.utils.Proxy;
import flash.utils.flash_proxy;

/**
 *  @private
 *  A simple implementation of IList that uses a backing Array.
 *  This base class will not throw ItemPendingErrors but it
 *  is possible that a subclass might.
 */
public class ArrayCollection extends Proxy
{
   //--------------------------------------------------------------------------
    //
    // Proxy methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Attempts to call getItemAt(), converting the property name into an int.
     */
    override flash_proxy function getProperty(name:*):*
    {
		///////////////////////////////////////////////////////////////
		//Doesn't compile with flash player 10.2, remove it for now
		////////////////////////////////////////////////////////////
        /*if (name is QName)
            name = name.localName;
*/
        var index:int = -1;
        try
        {
            // If caller passed in a number such as 5.5, it will be floored.
            var n:Number = parseInt(String(name));
            if (!isNaN(n))
                index = int(n);
        }
        catch(e:Error) // localName was not a number
        {
        }

        if (index == -1)
        {
/*             var message:String = resourceManager.getString(
                "collections", "unknownProperty", [ name ]);
            throw new Error(message);
 */        }
        else
        {
            return getItemAt(index);
        }
    }
    
    /**
     *  @private
     *  Attempts to call setItemAt(), converting the property name into an int.
     */
    override flash_proxy function setProperty(name:*, value:*):void
    {
		///////////////////////////////////////////////////////////////
		//Doesn't compile with flash player 10.2, remove it for now
		////////////////////////////////////////////////////////////
       /* if (name is QName)
            name = name.localName;
*/
        var index:int = -1;
        try
        {
            // If caller passed in a number such as 5.5, it will be floored.
            var n:Number = parseInt(String(name));
            if (!isNaN(n))
                index = int(n);
        }
        catch(e:Error) // localName was not a number
        {
        }

        if (index == -1)
        {
/*             var message:String = resourceManager.getString(
                "collections", "unknownProperty", [ name ]);
            throw new Error(message);
 */        }
        else
        {
            setItemAt(value, index);
        }
    }
    
    /**
     *  @private
     *  This is an internal function.
     *  The VM will call this method for code like <code>"foo" in bar</code>
     *  
     *  @param name The property name that should be tested for existence.
     */
    override flash_proxy function hasProperty(name:*):Boolean
    {
		///////////////////////////////////////////////////////////////
		//Doesn't compile with flash player 10.2, remove it for now
		////////////////////////////////////////////////////////////
		/*
        if (name is QName)
            name = name.localName;
*/
        var index:int = -1;
        try
        {
            // If caller passed in a number such as 5.5, it will be floored.
            var n:Number = parseInt(String(name));
            if (!isNaN(n))
                index = int(n);
        }
        catch(e:Error) // localName was not a number
        {
        }

        if (index == -1)
            return false;

        return index >= 0 && index < length;
    }

    /**
     *  @private
     */
    override flash_proxy function nextNameIndex(index:int):int
    {
        return index < length ? index + 1 : 0;
    }
    
    /**
     *  @private
     */
    override flash_proxy function nextName(index:int):String
    {
        return (index - 1).toString();
    }
    
    /**
     *  @private
     */
    override flash_proxy function nextValue(index:int):*
    {
        return getItemAt(index - 1);
    }    

    /**
     *  @private
     *  Any methods that can't be found on this class shouldn't be called,
     *  so return null
     */
    override flash_proxy function callProperty(name:*, ... rest):*
    {
        return null;
    }


    //--------------------------------------------------------------------------
    //
    // Constructor
    // 
    //--------------------------------------------------------------------------

    /**
     *  Construct a new ArrayList using the specified array as its source.
     *  If no source is specified an empty array will be used.
     */
    public function ArrayCollection(source:Array = null)
    {
        this.source = source;
        //_uid = UIDUtil.createUID();
    }
    
    //--------------------------------------------------------------------------
    //
    // Variables
    // 
    //--------------------------------------------------------------------------


    //--------------------------------------------------------------------------
    //
    // Properties
    // 
    //--------------------------------------------------------------------------
    
    //----------------------------------
    // length
    //----------------------------------

    /**
     *  Get the number of items in the list.  An ArrayList should always
     *  know its length so it shouldn't return -1, though a subclass may 
     *  override that behavior.
     *
     *  @return int representing the length of the source.
     */
    public function get length():int
    {
    	if (source)
        	return source.length;
        else
        	return 0;
    }
    
    //----------------------------------
    // source
    //----------------------------------
    
    /**
     *  The source array for this ArrayList.  
     *  Any changes done through the IList interface will be reflected in the 
     *  source array.  
     *  If no source array was supplied the ArrayList will create one internally.
     *  Changes made directly to the underlying Array (e.g., calling 
     *  <code>theList.source.pop()</code> will not cause <code>CollectionEvents</code> 
     *  to be dispatched.
     *
	 *  @return An Array that represents the underlying source.
     */
    public function get source():Array
    {
        return _source;
    }
    
    public function set source(s:Array):void
    {
        var i:int;
        var len:int;
        if (_source && _source.length)
        {
            len = _source.length;
        }
        _source  = s ? s : [];
        len = _source.length;
    }
    
    //----------------------------------
    // uid -- mx.core.IPropertyChangeNotifier
    //----------------------------------
    
    /**
     *  Provides access to the unique id for this list.
     *  
     *  @return String representing the internal uid. 
     */  
    public function get uid():String
    {
    	return _uid;
    }
    
    public function set uid(value:String):void
    {
    	_uid = value;
	}

    //--------------------------------------------------------------------------
    //
    // Methods
    // 
    //--------------------------------------------------------------------------

    /**
     *  Get the item at the specified index.
     * 
     *  @param 	index the index in the list from which to retrieve the item
     *  @param	prefetch int indicating both the direction and amount of items
     *			to fetch during the request should the item not be local.
     *  @return the item at that index, null if there is none
     *  @throws ItemPendingError if the data for that index needs to be 
     *                           loaded from a remote location
     *  @throws RangeError if the index < 0 or index >= length
     */
    public function getItemAt(index:int, prefetch:int = 0):Object
    {
        if (index < 0 || index >= length)
		{
			/*
			var message:String = resourceManager.getString(
				"collections", "outOfBounds", [ index ]);
        	throw new RangeError(message);
        	*/
		}
            
        return source[index];
    }
    
    /**
     *  Place the item at the specified index.  
     *  If an item was already at that index the new item will replace it and it 
     *  will be returned.
     *
     *  @param 	item the new value for the index
     *  @param 	index the index at which to place the item
     *  @return the item that was replaced, null if none
     *  @throws RangeError if index is less than 0 or greater than or equal to length
     */
    public function setItemAt(item:Object, index:int):Object
    {
        if (index < 0 || index >= length) 
		{
			/*
			var message:String = resourceManager.getString(
				"collections", "outOfBounds", [ index ]);
        	throw new RangeError(message);
        	*/
		}
        
        var oldItem:Object = source[index];
        source[index] = item;
        
        return oldItem;    
    }
    
    /**
     *  Add the specified item to the end of the list.
     *  Equivalent to addItemAt(item, length);
     * 
     *  @param item the item to add
     */
    public function addItem(item:Object):void
    {
        addItemAt(item, length);
    }
    
    /**
     *  Add the item at the specified index.  
     *  Any item that was after this index is moved out by one.  
     * 
     *  @param item the item to place at the index
     *  @param index the index at which to place the item
     *  @throws RangeError if index is less than 0 or greater than the length
     */
    public function addItemAt(item:Object, index:int):void
    {
        if (index < 0 || index > length) 
		{
			/*
			var message:String = resourceManager.getString(
				"collections", "outOfBounds", [ index ]);
        	throw new RangeError(message);
        	*/
		}
        	
        source.splice(index, 0, item);
    }
    
    /**
     *  Return the index of the item if it is in the list such that
     *  getItemAt(index) == item.  
     *  Note that in this implementation the search is linear and is therefore 
     *  O(n).
     * 
     *  @param item the item to find
     *  @return the index of the item, -1 if the item is not in the list.
     */
    public function getItemIndex(item:Object):int
    {
    	//fixme return ArrayUtil.getItemIndex(item, source);
    	return null;
    }
    
    /**
     *  Removes the specified item from this list, should it exist.
     *
     *	@param	item Object reference to the item that should be removed.
     *  @return	Boolean indicating if the item was removed.
     */
    public function removeItem(item:Object):Boolean
    {
    	var index:int = getItemIndex(item);
    	var result:Boolean = index >= 0;
    	if (result)
    		removeItemAt(index);

    	return result;
    }
    
    /**
     *  Remove the item at the specified index and return it.  
     *  Any items that were after this index are now one index earlier.
     *
     *  @param index the index from which to remove the item
     *  @return the item that was removed
     *  @throws RangeError is index < 0 or index >= length
     */
    public function removeItemAt(index:int):Object
    {
        if (index < 0 || index >= length)
		{
/* 			var message:String = resourceManager.getString(
				"collections", "outOfBounds", [ index ]);
        	throw new RangeError(message);
 */		}

        var removed:Object = source.splice(index, 1)[0];
        return removed;
    }
    
    /** 
     *  Remove all items from the list.
     */
    public function removeAll():void
    {
        if (length > 0)
        {
            source.splice(0, length);
        }    
    }
    
    
    /**
     *  Return an Array that is populated in the same order as the IList
     *  implementation.  
     * 
     *  @throws ItemPendingError if the data is not yet completely loaded
     *  from a remote location
     */ 
    public function toArray():Array
    {
        return source.concat();
    }
    
	/**
     *  Pretty prints the contents of this ArrayList to a string and returns it.
     */
    public function toString():String
	{
		/*
		if (source)
			return source.toString();
		else
			return getQualifiedClassName(this);
		*/
		return "";	
	}	
    
    //--------------------------------------------------------------------------
    //
    // Internal Methods
    // 
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //
    // Variables
    // 
    //--------------------------------------------------------------------------

	/**
	 *  indicates if events should be dispatched.
	 *  calls to enableEvents() and disableEvents() effect the value when == 0
	 *  events should be dispatched. 
	 */
    private var _source:Array;
    private var _uid:String;
}

}
