package com.sticksports.nativeExtensions.mopub
{
	import flash.system.Capabilities;

	public class MoPub {
		
		public static function get adScaleFactor():Number {
			return 1;
		}
		
		public static function get nativeScreenWidth():Number {
			return Capabilities.screenResolutionX;
		}
		
		public static function get nativeScreenHeight():Number {
			return Capabilities.screenResolutionY;
		}
		
		public static function init():void {
		}
		
		public static function trackConversion():void {
		}
		
	}
}
