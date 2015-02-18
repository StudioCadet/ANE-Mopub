package com.sticksports.nativeExtensions.mopub
{
	import flash.events.Event;

	public class MoPubEvent extends Event
	{
		// Common events :
		public static const AD_LOADED : String = "MoPubEvent.AD_LOADED";
		public static const AD_FAILED_TO_LOAD : String = "MoPubEvent.AD_FAILED_TO_LOAD";
		public static const AD_CLOSED : String = "MoPubEvent.AD_CLOSED";
		
		// Banner only :
		public static const BANNER_CLICKED : String = "MoPubEvent.BANNER_CLICKED";
		
		// Interstitial only :
		public static const INTERSTITIAL_SHOWN : String = "MoPubEvent.INTERSTITIAL_SHOWN";
		public static const INTERSTITIAL_EXPIRED : String = "MoPubEvent.INTERSTITIAL_EXPIRED"; // -> iOS only
		public static const INTERSTITIAL_CANCELLED : String = "MoPubEvent.INTERSTITIAL_CANCELLED"; // -> iOS only
		public static const INTERSTITIAL_CLICKED : String = "MoPubEvent.INTERSTITIAL_CLICKED";
		
		
		public function MoPubEvent( type : String, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			super( type, bubbles, cancelable );
		}
		
		override public function clone() : Event
		{
			return new MoPubEvent( type, bubbles, cancelable );
		}
	}
}
