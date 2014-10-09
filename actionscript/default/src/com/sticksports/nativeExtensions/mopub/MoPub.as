package com.sticksports.nativeExtensions.mopub
{
	import flash.system.Capabilities;

	public class MoPub {
		
		/** The logging function you want to use. Defaults to trace. */
		public static var logger:Function = trace;
		/** The prefix appended to every log message. Defaults to "[MoPub]". */
		public static var logPrefix:String = "[MoPub]";
		
		
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
		
		public static function getAppleIDFA():String {					
			return null;
		}
		
		public static function getAndroidId():String {					
			return null;
		}
		
		public static function getAndroidIMEI():String {					
			return null;
		}
		
		public static function getAndroidAdvertisingId():String {					
			return null;
		}
	}
}
