package com.sticksports.nativeExtensions.mopub
{
	import flash.external.ExtensionContext;
	
	public class MoPub {
		
		private static var extensionContext:ExtensionContext;
		private static var scaleFactor:Number;
		private static var _nativeScreenWidth:Number;
		private static var _nativeScreenHeight:Number;
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
			if(!_nativeScreenWidth) {
				
				if(!extensionContext)
					extensionContext = ExtensionContext.createExtensionContext("com.sticksports.nativeExtensions.MoPub", "mopub");
				
				_nativeScreenWidth = extensionContext.call("getNativeScreenWidth") as Number;
			}
			
			return _nativeScreenWidth;
		}
		
		public static function get nativeScreenHeight():Number {
			if(!_nativeScreenHeight) {
				
				if(!extensionContext)
					extensionContext = ExtensionContext.createExtensionContext("com.sticksports.nativeExtensions.MoPub", "mopub");
				
				_nativeScreenHeight = extensionContext.call("getNativeScreenHeight") as Number;
			}
			
			return _nativeScreenHeight;
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
