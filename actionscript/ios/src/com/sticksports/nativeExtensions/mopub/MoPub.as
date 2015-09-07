package com.sticksports.nativeExtensions.mopub
{
	import flash.external.ExtensionContext;
	import flash.display.Stage;
	
	public class MoPub {
		
		
		/** The logging function you want to use. Defaults to trace. */
		public static var logger:Function = trace;
		/** The prefix appended to every log message. Defaults to "[MoPub]". */
		public static var logPrefix:String = "[MoPub]";
		
		private static var extensionContext:ExtensionContext;
		private static var scaleFactor:Number;
		private static var _nativeScreenWidth:Number;
		private static var _nativeScreenHeight:Number;
		private static var conversionTracked:Boolean;
		private static var initialized:Boolean;
		
		/**
		 * The stage passed through the init method.
		 */
		private static var _stage:Stage;
		public static function get stage():Stage {
			return _stage;
		}
		
		
		private static function createExtensionContextIfNull():void {
			if(!extensionContext)
				extensionContext = ExtensionContext.createExtensionContext("com.sticksports.nativeExtensions.MoPub", "mopub");
		}

		public static function get adScaleFactor():Number {
			if(!scaleFactor) {
				
				createExtensionContextIfNull();
				
				scaleFactor = extensionContext.call("mopub_getAdScaleFactor") as Number;
			}
			
			return scaleFactor;
		}
		
		
		public static function get nativeScreenWidth():Number {
			if(!_nativeScreenWidth) {
				
				createExtensionContextIfNull();
				
				_nativeScreenWidth = extensionContext.call("mopub_getNativeScreenWidth") as Number;
			}
			
			return _nativeScreenWidth;
		}
		
		public static function get nativeScreenHeight():Number {
			if(!_nativeScreenHeight) {
				
				createExtensionContextIfNull();
				
				_nativeScreenHeight = extensionContext.call("mopub_getNativeScreenHeight") as Number;
			}
			
			return _nativeScreenHeight;
		}
		
		public static function trackConversion():void {
			if(conversionTracked)
				return;
			
			createExtensionContextIfNull();
			
			extensionContext.call("mopub_trackConversion");
			conversionTracked = true;
		}

		public static function init(stage:Stage = null):void {
			if(initialized)
				return;
				
			_stage = stage;
			
			createExtensionContextIfNull();
			
			extensionContext.call("mopub_init");
			initialized = true;
		}

		public static function getAppleIDFA():String {				
			createExtensionContextIfNull();
			return extensionContext.call("mopub_getAppleIDFA") as String;
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
			createExtensionContextIfNull();
			extensionContext.call("mopub_setKeywords", 
				keywords.age, 
				keywords.dateOfBirthTimestamp, 
				keywords.gender, 
				keywords.language, 
				keywords.additionalKeywordsKeys, 
				keywords.additionalKeywordsValues,
				keywords.inMobiInterests != null ? keywords.inMobiInterests.join(",") : null
			);
		}
	}
}
