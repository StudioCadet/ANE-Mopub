package com.sticksports.nativeExtensions.mopub
{
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	
	public class MoPub {
		
		private static var extensionContext:ExtensionContext;
		private static var scaleFactor:Number;
		private static var conversionTracked:Boolean;
		
		public static function get adScaleFactor():Number {
			if(!scaleFactor) {
				
				if(!extensionContext)
					extensionContext = ExtensionContext.createExtensionContext("com.sticksports.nativeExtensions.MoPub", "mopub");
				
				scaleFactor = extensionContext.call("getAdScaleFactor") as Number;
			}
			
			return scaleFactor;
		}
		
		public static function get nativeScreenWidth():Number {
			return Capabilities.screenResolutionX;
		}
		
		public static function get nativeScreenHeight():Number {
			return Capabilities.screenResolutionY;
		}
		
		public static function trackConversion():void {
			if(conversionTracked)
				return;
			
			if(!extensionContext)
				extensionContext = ExtensionContext.createExtensionContext("com.sticksports.nativeExtensions.MoPub", "mopub");
			
			extensionContext.call("trackConversion");
			conversionTracked = true;
		}
	}
}
