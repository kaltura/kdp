package com.kaltura.types
{
	public class KalturaBatchJobType
	{
		public static const CONVERT : String = '0';
		public static const IMPORT : String = '1';
		public static const DELETE : String = '2';
		public static const FLATTEN : String = '3';
		public static const BULKUPLOAD : String = '4';
		public static const DVDCREATOR : String = '5';
		public static const DOWNLOAD : String = '6';
		public static const OOCONVERT : String = '7';
		public static const CONVERT_PROFILE : String = '10';
		public static const POSTCONVERT : String = '11';
		public static const PULL : String = '12';
		public static const REMOTE_CONVERT : String = '13';
		public static const EXTRACT_MEDIA : String = '14';
		public static const MAIL : String = '15';
		public static const NOTIFICATION : String = '16';
		public static const CLEANUP : String = '17';
		public static const SCHEDULER_HELPER : String = '18';
		public static const BULKDOWNLOAD : String = '19';
		public static const DB_CLEANUP : String = '20';
		public static const PROVISION_PROVIDE : String = '21';
		public static const CONVERT_COLLECTION : String = '22';
		public static const STORAGE_EXPORT : String = '23';
		public static const PROVISION_DELETE : String = '24';
		public static const STORAGE_DELETE : String = '25';
		public static const EMAIL_INGESTION : String = '26';
		public static const METADATA_IMPORT : String = '27';
		public static const METADATA_TRANSFORM : String = '28';
		public static const FILESYNC_IMPORT : String = '29';
		public static const CAPTURE_THUMB : String = '30';
		public static const VIRUS_SCAN : String = 'virusScan.VirusScan';
		public static const DISTRIBUTION_SUBMIT : String = 'contentDistribution.DistributionSubmit';
		public static const DISTRIBUTION_UPDATE : String = 'contentDistribution.DistributionUpdate';
		public static const DISTRIBUTION_DELETE : String = 'contentDistribution.DistributionDelete';
		public static const DISTRIBUTION_FETCH_REPORT : String = 'contentDistribution.DistributionFetchReport';
		public static const DISTRIBUTION_SYNC : String = 'contentDistribution.DistributionSync';
	}
}
