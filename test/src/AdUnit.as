package {
	import flash.system.Capabilities;
	
	/**
	 * A singleton managing the ad units and their IDs. Use <code>AdUnits.getId(MP_INTERSTITIAL_INCENTIVE)</code> 
	 * to get the ad unit ID to pass to Ads.
	 */
	internal final class AdUnit {
		
		// INTERNAL AD UNITS :
		/** MoPub banner. */
		public static const MP_BANNER:String = "AdUnit.MoPub.Banner";
		/** MoPub interstitial. */
		public static const MP_INTERSTITIAL:String = "AdUnit.MoPub.Interstitial";
		
		// MOPUB AD UNITS IDS :
		private static const BANNER_ANDROID_PHONE:String = "44299f091a53424aae7c0e05065288ee";
		private static const BANNER_ANDROID_TABLET:String = "e7ce950d4d444cdb9d243d859f016248";
		private static const INTERSTITIAL_ANDROID_PHONE:String = "b3e4dae0310f464b9d1d0903494dcc5a";
		private static const INTERSTITIAL_ANDROID_TABLET:String = "f5451b6962de4f4b99df56e4ed47e725";
		
		private static const BANNER_IOS_PHONE:String = "9ffc32d8454a42bc93effafe5d38ecc2";
		private static const BANNER_IOS_TABLET:String = "6f1a4bb4590d4d9b968ac47480f94a51";
		private static const INTERSTITIAL_IOS_PHONE:String = "4f2b794e09674857a06c364b63e4f177";
		private static const INTERSTITIAL_IOS_TABLET:String = "165c4733c1694b83b7f476c9328581a7";
		
		
		// AD UNIT IDS TO USE :
		private static var bannerID:String;
		private static var interstitialID:String;
		
		/** Whether the device is a tablet or a phone. */
		internal static var isTablet:Boolean;
		
		
		////////////////
		// PUBLIC API //
		////////////////
		
		/**
		 * Initializes the AdUnit IDs matching their corresponding AdUnit.
		 */
		internal static function init():void {
			
			// -> iPad
			if(Capabilities.os.indexOf("iPad") > -1) {
				trace("Using iPad ad units.");
				bannerID = BANNER_IOS_TABLET;
				interstitialID = INTERSTITIAL_IOS_TABLET;
				isTablet = true;
			}
				
			// -> iPhone/iPod
			else if(Capabilities.os.indexOf("iPhone") > -1 || Capabilities.os.indexOf("iPod") > -1) {
				trace("Using iPhone/iPod ad units.");
				bannerID = BANNER_IOS_PHONE;
				interstitialID = INTERSTITIAL_IOS_PHONE;
				isTablet = false;
			}
				
			else {
				isTablet = Math.max(Capabilities.screenResolutionX , Capabilities.screenResolutionY) / Capabilities.screenDPI >= 5;
				
				// Android tablet :
				if(isTablet) {
					trace("Using Android tablet ad units.");
					bannerID = BANNER_ANDROID_TABLET;
					interstitialID = INTERSTITIAL_ANDROID_TABLET;
				}
					
					// Android phone :
				else {
					trace("Using Android phone ad units.");
					bannerID = BANNER_ANDROID_PHONE;
					interstitialID = INTERSTITIAL_ANDROID_PHONE;
				}
			}
		}
		
		/**
		 * Returns the AdUnitID to give to Ads for the desired AdUnit.
		 * 
		 * @param adUnit One of the AdUnits.* constants
		 */
		internal static function getId(adUnit:String):String {
			if(adUnit == MP_BANNER) 
				return bannerID;
			if(adUnit == MP_INTERSTITIAL)
				return interstitialID;
			
			throw new Error("Invalid AdUnit : " + adUnit + ". Use one of the AdUnit constants to get the corresponding ID.");
		}
	}
}