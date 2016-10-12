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
		private static const BANNER_ANDROID_PHONE:String = "d155e1925a79445bb9ded7b4ef3494aa";
		private static const BANNER_ANDROID_TABLET:String = "438aaf74d7704d50b582ae230fe09f9c";
		private static const INTERSTITIAL_ANDROID_PHONE:String = "7f5741cce07a44579010db133571c629";
		private static const INTERSTITIAL_ANDROID_TABLET:String = "0766693b7f9b40f09f62529355d197db";
		
		private static const BANNER_IOS_PHONE:String = "3070aeff71fa47629aac248bbc1ce53a";
		private static const BANNER_IOS_TABLET:String = "e97ac539cd384d37af967aac30656922";
		private static const INTERSTITIAL_IOS_PHONE:String = "0b31201ae26d49029eedc8a7ae4a266c";
		private static const INTERSTITIAL_IOS_TABLET:String = "17a4103c976e4083ade956a9d4aac5ff";

		
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