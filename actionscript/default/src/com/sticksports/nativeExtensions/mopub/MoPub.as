package com.sticksports.nativeExtensions.mopub
{
	import flash.display.Stage;
	import flash.system.Capabilities;

	public class MoPub {
		
		/** The logging function you want to use. Defaults to trace. */
		public static var logger:Function = trace;
		/** The prefix appended to every log message. Defaults to "[MoPub]". */
		public static var logPrefix:String = "[MoPub]";
		
		/**
		 * The stage passed through the init method.
		 */
		private static var _stage:Stage;
		public static function get stage():Stage {
			return _stage;
		}
		
		
		public static function get adScaleFactor():Number {
			return 1;
		}
		
		public static function get nativeScreenWidth():Number {
			return Capabilities.screenResolutionX;
		}
		
		public static function get nativeScreenHeight():Number {
			return Capabilities.screenResolutionY;
		}
		
		public static function init(stage:Stage = null):void {
			_stage = stage;
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
		
		public static function setKeywords(keywords:MoPubKeywords):void {
		}
	}
}
