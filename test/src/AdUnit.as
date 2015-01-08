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
		private static const BANNER_ANDROID_PHONE:String = "de63996bf3f94e4e8ff187af08634920";
		private static const BANNER_ANDROID_TABLET:String = "8243ba627fbd439f980f5a37b03384d9";
		private static const INTERSTITIAL_ANDROID_PHONE:String = "befd6d8c0be64b82ae82c344af80ffcd";
		private static const INTERSTITIAL_ANDROID_TABLET:String = "a804bb16844d427faf0a42f57f17280d";
		
		private static const BANNER_IOS_PHONE:String = "cdb21cb5ba924d108ecaeafb0f01d7fd";
		private static const BANNER_IOS_TABLET:String = "de0f282607fd4fdf9e17f49286129304";
		private static const INTERSTITIAL_IOS_PHONE:String = "12fea700dbfb47fca73ac0040d6b59ac";
		private static const INTERSTITIAL_IOS_TABLET:String = "86af00cfe03f40248a65914945d6a768";
		
		
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