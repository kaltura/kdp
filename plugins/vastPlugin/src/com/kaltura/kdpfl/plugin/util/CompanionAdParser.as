package com.kaltura.kdpfl.plugin.util
{
	public class CompanionAdParser
	{
		
		public function CompanionAdParser()
		{
		}
		
		public function parseCompanionAds ( encryptedCompanionAds : String ) : Array
		{
			var companionAds : Array = new Array();
			if (encryptedCompanionAds)
			{
				var compAds : Array = encryptedCompanionAds.split(";");
				
				for each (var compAd : String in compAds)
				{
					var parsedAd : Array = compAd.split(":");
					var companionAd : Object;
					if (parsedAd.length == 4)
						companionAd = {compId : parsedAd[0], compRelativity : parsedAd[1], compWidth : parsedAd[2], compHeight : parsedAd[3]};
					else if (parsedAd.length == 3)
						companionAd = {compId : parsedAd[0], compWidth : parsedAd[1], compHeight : parsedAd[2]};
					companionAds.push(companionAd);
				}
			}
			return companionAds;
		}
		
		

	}
}