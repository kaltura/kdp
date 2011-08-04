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
package com.kaltura.assets.dataStructures.audio
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;

	import mx.collections.ArrayCollection;
	//xxx import mx.events.CollectionEvent;

	public class AudioGraph extends EventDispatcher
	{
		public static var DEFAULT_VOLUME:Number = 0.5;
		protected 	var _length:Number = 0;								//the maximum time of the graph
		protected 	var _audioVolumePoints:Array = [];					//the graph is represented as array of points
		protected 	var _audioVolumePointsCollection:ArrayCollection;	//access to the points is granted only through a collection to maintain binding mechanism

		/**
		 * the maxTime of the audio graph.
		 */
		public function get length ():Number
		{
			return _length;
		}
		public function set length (value:Number):void
		{
			_length = value;
			// if the len is shorter than the current length,
			// delete all the exceeding volume points and set the last point to the new length value.
			var point:Point;
			var N:int = graphCollection.length;
			var removes:Array = [];
			//Move the last point to the new length value
			point = graphCollection.getItemAt(N - 1) as Point;
			point.x = value;
			var i:int;
			for (i = 0; i < N; ++i)
			{
				point = graphCollection.getItemAt(i) as Point;
				if (point.x > value)
					removes.push(point);
			}
			N = removes.length;
			for (i = 0; i < N; ++i)
			{
				graphCollection.removeItemAt(graphCollection.getItemIndex(removes[i]));
			}
			if (graphCollection.length <= 1)
				setOverallVolume(0.5);
			dispatchEvent(new Event (Event.CHANGE));
		}

		/**
		 * Constructor.
		 * @param length	the length of the graph (maximum x value).
		 *
		 */
		public function AudioGraph(length:Number)
		{
			_length = length;
			_audioVolumePointsCollection = new ArrayCollection (_audioVolumePoints);
			setOverallVolume(DEFAULT_VOLUME, false);
		}

		/**
		 * give access to the collection of points representing the graph, direct access to the array is denide in order to maintain the binding mechanism.
		 * @return 		the collection of the points.
		 *
		 */
		public function get graphCollection ():ArrayCollection
		{
			return _audioVolumePointsCollection;
		}

		/**
		 * reset the graph to a given array of points.
		 * @param a		an array that contains points.
		 *
		 */
		public function set audioVolumePoints (a:Array):void
		{
			dispose ();
			_audioVolumePoints = a;
			_audioVolumePointsCollection.source = _audioVolumePoints;
			//xxx _audioVolumePointsCollection.refresh();
		}

		/**
		 * get the volume at a given time.
		 * @param seekTime		the given time to get the volume at
		 * @return 				the volume at the given time
		 *
		 */
		public function getVolumeAtTime (seekTime:Number):Number
		{
			var p:Point;
			var lastP:Point;
			if (_audioVolumePoints)
				var N:int = _audioVolumePoints.length;
			else
				return 1;
			var f:Number;

			if (isSilent())
			{
				return 0;
			}

			for (var i:int = 1; i < N; ++i)
			{
				p = _audioVolumePoints[i];
				if (p.x == seekTime)
					return p.y;
				else if (p.x > seekTime)
				{
					lastP = _audioVolumePoints[i-1];
					f = (seekTime - lastP.x) / (p.x - lastP.x);
					return Point.interpolate(p, lastP, f).y;
				}
			}
			return 1;
		}

		/**
		 * preforms a check, determine if this graph is silent (two points at 0).
		 * @return 	true if silent, false if not
		 *
		 */
		public function isSilent ():Boolean
		{
			var N:int = _audioVolumePoints.length;
			for (var i:int = 0; i < N; ++i)
			{
				if (_audioVolumePoints[i].y != 0)
				{
					return false;
				}
			}
			return true;
		}

		/**
		 * calculate the average volmue in the graph.
		 * @return average volume of the graph.
		 *
		 */
		public function getAverageVolume ():Number
		{
			var p:Point;
			var N:int = _audioVolumePoints.length;
			var f:Number = 0;

			for (var i:int = 0; i < N; ++i)
			{
				p = _audioVolumePoints[i];
				f += p.y;
			}
			var avg:Number = f / N * 100;
			return avg;
		}

		/**
		 *  preform a check to see if the volume graph is normalized (all points at the same y value).
		 * @return 		true if the graph is normalized
		 *
		 */
		public function isNormalized ():Boolean
		{
			var N:int = _audioVolumePoints.length;
			if (N == 0)
				return true;

			var p:Point = _audioVolumePoints[0];
			var lastVol:Number = p.y;
			var normalized:Boolean = true;

			for (var i:int = 1; i < N; ++i)
			{
				p = _audioVolumePoints[i];
				if ( ! (normalized = ( lastVol == p.y )) )
					break;
			}
			return normalized;
		}

		/**
		 *	resets the graph to a given volume value.
		 * @param vol		the volume to reset the graph to
		 * @param doEvent	if true, will dispatch a collection change event on the collection
		 *
		 */
		public function setOverallVolume (vol:Number, doEvent:Boolean = true):void
		{
			graphCollection.removeAll();
			graphCollection.addItem(new Point (0, vol));
			graphCollection.addItem(new Point (_length, vol));
			//xxx if (doEvent)
			//	graphCollection.dispatchEvent (new CollectionEvent (CollectionEvent.COLLECTION_CHANGE));
		}

		/**
		 *generates an XML representation of the volume graph
		 * @return
		 *
		 */
		public function toXML ():XML
		{
			var VolXML:XML = <VolumePoints />;
			var tempXML:XML;
			var N:int = _audioVolumePoints.length;
			var point:Point;
			for (var i:int = 0; i < N; ++i)
			{
				point = graphCollection.getItemAt(i) as Point;
				tempXML = new XML (<VolumePoint time={point.x} volume={point.y} />);
				VolXML.appendChild (tempXML);
			}
			return VolXML;
		}

		/**
		 *	parse an xml representation of the volume graph and creates the points array and the collection.
		 * @param VolumeXML		xml of the representing the volume graph.
		 *
		 */
		public function fromXML (VolumeXML:XML):void
		{
			graphCollection.removeAll();
			var point:Point;
			if (VolumeXML)
			{
				for each (var p:XML in VolumeXML.VolumePoint)
				{
					point = new Point (p.@time, p.@volume);
					if (!contains (point))
						graphCollection.addItem (point);
				}
			}
			sort();
			if (graphCollection.length > 1)
			{
				point = graphCollection.getItemAt(0) as Point;
				if (point.x > 0)
					point.x = 0;
			} else {
				setOverallVolume(0.5);
			}
		}

		/**
		 *test if a point with the same x and y values exists in the graph.
		 * @param point		the point to test.
		 * @return 			true if a similiar point exist, false if not.
		 */
		public function contains (point:Point):Boolean
		{
			var N:int = graphCollection.length;
			var p2:Point;
			for (var i:int = 0; i < N; ++i)
			{
				p2 = graphCollection.getItemAt(i) as Point;
				if (p2.equals(point))
					return true;
			}
			return false;
		}

		/**
		 * removes duplicate points from the graph.
		 */
		public function removeDuplicates ():void
		{
			//this function is not correct and hasn't been tested.
			sort ();
			var N:int = graphCollection.length;
			var p1:Point;
			var p2:Point;
			var removed:int = 0;
			for (var i:int = 0; (i + removed) < N; ++i)
			{
				p1 = graphCollection.getItemAt(i) as Point;
				p2 = getPointAtX(p1.x);
				if (p2 && p2.equals(p1))
				{
					//xxx graphCollection.disableAutoUpdate();
					graphCollection.removeItemAt(i);
					++removed;
					--i;
				}
			}
			//xxx graphCollection.enableAutoUpdate();
			if (graphCollection.length <= 1)
				setOverallVolume(0.5);
			//xxx graphCollection.refresh();
		}

		/**
		 * uses binary search to get a point at x value.
		 * note to sort the graph before using this function.
		 * @param xx		the x of the point.
		 * @return 			the point in the x position.
		 * @see #sort()
		 */
		public function getPointAtX (xx:int):Point
		{
			var low:int = 0;
			var high:int = graphCollection.length - 1;
			var mid:int;
			var point:Point;
			while (low <= high)
			{
				mid = (low + high) >>> 1;
				point = graphCollection.getItemAt(mid) as Point;

				if (point.x < xx)
					low = mid + 1;
				else if (point.x > xx)
					high = mid - 1;
				else
					return point;
			}
			return null;
		}

		/**
		 * sorts the graph collection.
		 */
		public function sort ():void
		{
			graphCollection.source.sortOn ('x', Array.NUMERIC);
			//xxx graphCollection.refresh();
		}

		/**
		 * clone the graph.
		 * @return 	returns a new audio graph.
		 *
		 */
		public function clone ():AudioGraph
		{
			var newGraph:AudioGraph = new AudioGraph (_length);
			var N:int = _audioVolumePoints.length;
			var p:Point;
			for (var i:int = 0; i < N; ++i)
			{
				p = _audioVolumePoints[i];
				newGraph.graphCollection.addItem(p.clone());
			}
			return newGraph;
		}

		/**
		 * clone the graph points to a given graph.
		 * use the <code>clone();</code> method to create a new audioGraph with the same values.
		 * <code>copy ();</code> is used to replicate the graph points to a given graph.
		 * the input graph points will be removed.
		 */
		public function copy (inGraph:AudioGraph):void
		{
			inGraph.graphCollection.removeAll();
			var N:int = _audioVolumePoints.length;
			var p:Point;
			for (var i:int = 0; i < N; ++i)
			{
				p = _audioVolumePoints[i];
				inGraph.graphCollection.addItem(p.clone());
			}
		}

		/**
		 *	disposes of the object from memory.
		 *
		 */
		public function dispose ():void
		{
			if (_audioVolumePoints != null)
			{
				if (graphCollection.source != _audioVolumePoints)
					graphCollection.source = _audioVolumePoints;
				graphCollection.removeAll();
			}
			_audioVolumePoints = null;
			_audioVolumePointsCollection = null;
		}
	}
}