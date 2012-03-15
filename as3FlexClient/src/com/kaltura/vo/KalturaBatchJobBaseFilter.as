// ===================================================================================================
//                           _  __     _ _
//                          | |/ /__ _| | |_ _  _ _ _ __ _
//                          | ' </ _` | |  _| || | '_/ _` |
//                          |_|\_\__,_|_|\__|\_,_|_| \__,_|
//
// This file is part of the Kaltura Collaborative Media Suite which allows users
// to do with audio, video, and animation what Wiki platfroms allow them to do with
// text.
//
// Copyright (C) 2006-2011  Kaltura Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
// @ignore
// ===================================================================================================
package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseJobFilter;

	[Bindable]
	public dynamic class KalturaBatchJobBaseFilter extends KalturaBaseJobFilter
	{
		/** 
		* 		* */ 
		public var entryIdEqual : String = null;

		/** 
		* 		* */ 
		public var jobTypeEqual : String = null;

		/** 
		* 		* */ 
		public var jobTypeIn : String = null;

		/** 
		* 		* */ 
		public var jobTypeNotIn : String = null;

		/** 
		* 		* */ 
		public var jobSubTypeEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var jobSubTypeIn : String = null;

		/** 
		* 		* */ 
		public var jobSubTypeNotIn : String = null;

		/** 
		* 		* */ 
		public var onStressDivertToEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var onStressDivertToIn : String = null;

		/** 
		* 		* */ 
		public var onStressDivertToNotIn : String = null;

		/** 
		* 		* */ 
		public var statusEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var statusIn : String = null;

		/** 
		* 		* */ 
		public var statusNotIn : String = null;

		/** 
		* 		* */ 
		public var abortEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var checkAgainTimeoutGreaterThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var checkAgainTimeoutLessThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var progressGreaterThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var progressLessThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var updatesCountGreaterThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var updatesCountLessThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var priorityGreaterThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var priorityLessThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var priorityEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var priorityIn : String = null;

		/** 
		* 		* */ 
		public var priorityNotIn : String = null;

		/** 
		* 		* */ 
		public var twinJobIdEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var twinJobIdIn : String = null;

		/** 
		* 		* */ 
		public var twinJobIdNotIn : String = null;

		/** 
		* 		* */ 
		public var bulkJobIdEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var bulkJobIdIn : String = null;

		/** 
		* 		* */ 
		public var bulkJobIdNotIn : String = null;

		/** 
		* 		* */ 
		public var parentJobIdEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var parentJobIdIn : String = null;

		/** 
		* 		* */ 
		public var parentJobIdNotIn : String = null;

		/** 
		* 		* */ 
		public var rootJobIdEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var rootJobIdIn : String = null;

		/** 
		* 		* */ 
		public var rootJobIdNotIn : String = null;

		/** 
		* 		* */ 
		public var queueTimeGreaterThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var queueTimeLessThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var finishTimeGreaterThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var finishTimeLessThanOrEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var errTypeEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var errTypeIn : String = null;

		/** 
		* 		* */ 
		public var errTypeNotIn : String = null;

		/** 
		* 		* */ 
		public var errNumberEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var errNumberIn : String = null;

		/** 
		* 		* */ 
		public var errNumberNotIn : String = null;

		/** 
		* 		* */ 
		public var fileSizeLessThan : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var fileSizeGreaterThan : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var lastWorkerRemoteEqual : Boolean;

		/** 
		* 		* */ 
		public var schedulerIdEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var schedulerIdIn : String = null;

		/** 
		* 		* */ 
		public var schedulerIdNotIn : String = null;

		/** 
		* 		* */ 
		public var workerIdEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var workerIdIn : String = null;

		/** 
		* 		* */ 
		public var workerIdNotIn : String = null;

		/** 
		* 		* */ 
		public var batchIndexEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var batchIndexIn : String = null;

		/** 
		* 		* */ 
		public var batchIndexNotIn : String = null;

		/** 
		* 		* */ 
		public var lastSchedulerIdEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var lastSchedulerIdIn : String = null;

		/** 
		* 		* */ 
		public var lastSchedulerIdNotIn : String = null;

		/** 
		* 		* */ 
		public var lastWorkerIdEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var lastWorkerIdIn : String = null;

		/** 
		* 		* */ 
		public var lastWorkerIdNotIn : String = null;

		/** 
		* 		* */ 
		public var dcEqual : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var dcIn : String = null;

		/** 
		* 		* */ 
		public var dcNotIn : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('entryIdEqual');
			arr.push('jobTypeEqual');
			arr.push('jobTypeIn');
			arr.push('jobTypeNotIn');
			arr.push('jobSubTypeEqual');
			arr.push('jobSubTypeIn');
			arr.push('jobSubTypeNotIn');
			arr.push('onStressDivertToEqual');
			arr.push('onStressDivertToIn');
			arr.push('onStressDivertToNotIn');
			arr.push('statusEqual');
			arr.push('statusIn');
			arr.push('statusNotIn');
			arr.push('abortEqual');
			arr.push('checkAgainTimeoutGreaterThanOrEqual');
			arr.push('checkAgainTimeoutLessThanOrEqual');
			arr.push('progressGreaterThanOrEqual');
			arr.push('progressLessThanOrEqual');
			arr.push('updatesCountGreaterThanOrEqual');
			arr.push('updatesCountLessThanOrEqual');
			arr.push('priorityGreaterThanOrEqual');
			arr.push('priorityLessThanOrEqual');
			arr.push('priorityEqual');
			arr.push('priorityIn');
			arr.push('priorityNotIn');
			arr.push('twinJobIdEqual');
			arr.push('twinJobIdIn');
			arr.push('twinJobIdNotIn');
			arr.push('bulkJobIdEqual');
			arr.push('bulkJobIdIn');
			arr.push('bulkJobIdNotIn');
			arr.push('parentJobIdEqual');
			arr.push('parentJobIdIn');
			arr.push('parentJobIdNotIn');
			arr.push('rootJobIdEqual');
			arr.push('rootJobIdIn');
			arr.push('rootJobIdNotIn');
			arr.push('queueTimeGreaterThanOrEqual');
			arr.push('queueTimeLessThanOrEqual');
			arr.push('finishTimeGreaterThanOrEqual');
			arr.push('finishTimeLessThanOrEqual');
			arr.push('errTypeEqual');
			arr.push('errTypeIn');
			arr.push('errTypeNotIn');
			arr.push('errNumberEqual');
			arr.push('errNumberIn');
			arr.push('errNumberNotIn');
			arr.push('fileSizeLessThan');
			arr.push('fileSizeGreaterThan');
			arr.push('lastWorkerRemoteEqual');
			arr.push('schedulerIdEqual');
			arr.push('schedulerIdIn');
			arr.push('schedulerIdNotIn');
			arr.push('workerIdEqual');
			arr.push('workerIdIn');
			arr.push('workerIdNotIn');
			arr.push('batchIndexEqual');
			arr.push('batchIndexIn');
			arr.push('batchIndexNotIn');
			arr.push('lastSchedulerIdEqual');
			arr.push('lastSchedulerIdIn');
			arr.push('lastSchedulerIdNotIn');
			arr.push('lastWorkerIdEqual');
			arr.push('lastWorkerIdIn');
			arr.push('lastWorkerIdNotIn');
			arr.push('dcEqual');
			arr.push('dcIn');
			arr.push('dcNotIn');
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			return arr;
		}

	}
}
