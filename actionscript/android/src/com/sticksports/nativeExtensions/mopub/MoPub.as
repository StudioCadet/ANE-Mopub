package com.sticksports.nativeExtensions.mopub
{
	import flash.desktop.NativeApplication;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	import flash.display.Stage;
	
	public class MoPub {
		
		private static var extensionContext:ExtensionContext;
		
		/** The logging function you want to use. Defaults to trace. */
		public static var logger:Function = trace;
		/** The prefix appended to every log message. Defaults to "[MoPub]". */
		public static var logPrefix:String = "[MoPub]";
		
		private static var scaleFactor:Number;
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
			if(extensionContext)
				return;
			extensionContext = ExtensionContext.createExtensionContext("com.sticksports.nativeExtensions.MoPub", "mopub");
			extensionContext.addEventListener(StatusEvent.STATUS, onStatusEvent);
		}
		
		public static function get adScaleFactor():Number {
			if(!scaleFactor) {
				createExtensionContextIfNull();
				scaleFactor = extensionContext.call("mopub_getAdScaleFactor") as Number;
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
			
			createExtensionContextIfNull();
			
			extensionContext.call("mopub_trackConversion");
			conversionTracked = true;
		}
		
		public static function init(stage:Stage = null):void {
			if(initialized)
				return;
				
			_stage = stage;
			
			createExtensionContextIfNull();
			
			const descriptor:XML = NativeApplication.nativeApplication.applicationDescriptor;
			const ns:Namespace = descriptor.namespace();
			const versionNumber:String = descriptor.ns::versionNumber.toString();
			extensionContext.call("mopub_init", versionNumber);
			initialized = true;
		}
		
		public static function getAppleIDFA():String {					
			return null;
		}
		
		public static function getAndroidId():String {					
			createExtensionContextIfNull();			
			return extensionContext.call("mopub_getAndroidId") as String;
		}
		
		public static function getAndroidIMEI():String {					
			createExtensionContextIfNull();			
			return extensionContext.call("mopub_getAndroidIMEI") as String;
		}
		
		public static function getAndroidAdvertisingId():String {					
			createExtensionContextIfNull();			
			return extensionContext.call("mopub_getAndroidAdvertisingId") as String;
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
		
		
		
		private static function onStatusEvent(ev:StatusEvent):void {
			if(ev.code == InternalMessages.log)
				log(ev.level);
		}
		
		/**
		 * Outputs the given message(s) using the provided logger function, or using trace.
		 */
		private static function log(message:String, ... additionnalMessages):void {
			if(logger == null) return;
			
			if(!additionnalMessages)
				additionnalMessages = [];
			
			logger((logPrefix && logPrefix.length > 0 ? logPrefix + " " : "") + message + " " + additionnalMessages.join(" "));
		}
	}
}
