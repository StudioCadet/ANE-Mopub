package com.sticksports.nativeExtensions.mopub
{
	import flash.desktop.NativeApplication;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	
	public class MoPub {
		
		private static var extensionContext:ExtensionContext;
		private static var scaleFactor:Number;
		private static var conversionTracked:Boolean;
		private static var initialized:Boolean;
		
		public static function get adScaleFactor():Number {
			if(!scaleFactor) {
				
				if(!extensionContext)
					extensionContext = ExtensionContext.createExtensionContext("com.sticksports.nativeExtensions.MoPub", "mopub");
				
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
			
			if(!extensionContext)
				extensionContext = ExtensionContext.createExtensionContext("com.sticksports.nativeExtensions.MoPub", "mopub");
			
			extensionContext.call("mopub_trackConversion");
			conversionTracked = true;
		}
		
		public static function init():void {
			if(initialized)
				return;
			
			if(!extensionContext) 
				extensionContext = ExtensionContext.createExtensionContext("com.sticksports.nativeExtensions.MoPub", "mopub");
			
			const descriptor:XML = NativeApplication.nativeApplication.applicationDescriptor;
			const ns:Namespace = descriptor.namespace();
			const versionNumber:String = descriptor.ns::versionNumber.toString();
			extensionContext.call("mopub_init", versionNumber);
			initialized = true;
		}
	}
}
