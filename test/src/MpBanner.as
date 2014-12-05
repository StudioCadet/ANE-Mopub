package {
	import com.sticksports.nativeExtensions.mopub.MoPub;
	import com.sticksports.nativeExtensions.mopub.MoPubBanner;
	import com.sticksports.nativeExtensions.mopub.MoPubEvent;
	import com.sticksports.nativeExtensions.mopub.MoPubKeywords;
	import com.sticksports.nativeExtensions.mopub.MoPubNativeAdOrientation;
	import com.sticksports.nativeExtensions.mopub.MoPubSize;
	
	import flash.display.InterpolationMethod;
	import flash.display.Stage;
	import flash.system.Capabilities;
	
	
	/**
	 * A wrapper around MoPub banner system.
	 */
	public class MpBanner {
		
		// CONFIG :
		private static const MAX_LOAD_RETRY_ON_FAIL:int = 20;
		
		// NATIVE SCREEN SCALE :
		private static var _nativeScreenScaleX:Number;
		public static function get nativeScreenScaleX():Number { return _nativeScreenScaleX; }
		private static var _nativeScreenScaleY:Number;
		public static function get nativeScreenScaleY():Number { return _nativeScreenScaleY; }
		
		// PROPERTIES :
		/** The stage instance. */
		private var stage:Stage;
		/** The MoPubBanner instance. */
		public var banner:MoPubBanner;
		private var adUnit:String;
		private var isTablet:Boolean;
		/** An external callback for when the banner is displayed on screen. */
		public var onDisplayed:Function;
		/** An external callback for when the banner is removed from screen. */
		public var onRemoved:Function;
		
		private var nLoadRetries:int;
		
		private var _isDisplayed:Boolean;
		/** Whether the banner is currently displayed on the screen. */
		public function get isDisplayed():Boolean { return _isDisplayed; }
		
		
		// CONSTRUCTOR :
		public function MpBanner(stage:Stage, adUnit:String, isTablet:Boolean) {
			this.stage = stage;
			this.adUnit = adUnit;
			this.isTablet = isTablet;
			
			initNativeScreenScale();
		}
		
		/**
		 * Guess the scale of the AS screen against the native screen.
		 */
		private function initNativeScreenScale():void {
			if(!nativeScreenScaleX) {
				_nativeScreenScaleX = MoPub.nativeScreenWidth / Capabilities.screenResolutionX; 
				_nativeScreenScaleY = MoPub.nativeScreenHeight / Capabilities.screenResolutionY; 
			}
		}
		
		/**
		 * Fetches then displays the banner. Once displayed, onDisplayed() will be called.
		 */
		public function display(onDisplayed:Function, onRemoved:Function):void {
			this.onDisplayed = onDisplayed;
			this.onRemoved = onRemoved;
			
			if(banner)
				throw new Error("You must remove the old banner first !");
			
			banner = new MoPubBanner(adUnit, isTablet ? MoPubSize.leaderboard : MoPubSize.banner);
			banner.nativeAdsOrientation = MoPubNativeAdOrientation.portrait;
			banner.x = (stage.fullScreenWidth * nativeScreenScaleX - banner.width) / 2;
			banner.y = stage.fullScreenHeight * nativeScreenScaleY;
			
			banner.addEventListener(MoPubEvent.AD_LOADED, onBannerLoaded);
			banner.addEventListener(MoPubEvent.AD_FAILED_TO_LOAD, onBannerFailToLoad);
			banner.addEventListener(MoPubEvent.BANNER_CLICKED, onBannerClicked);
			
			trace("Loading MoPub banner ...");
			nLoadRetries = 0;
			banner.load();
		}
		
		private function onBannerLoaded(ev:MoPubEvent):void {
			trace("MoPub banner loaded, displaying it.");
			
			if(banner.width != banner.creativeWidth) banner.width = banner.creativeWidth;
			if(banner.height != banner.creativeHeight) banner.height = banner.creativeHeight;
			
			banner.x = (stage.fullScreenWidth * nativeScreenScaleX - banner.width) / 2;
			banner.y = stage.fullScreenHeight * nativeScreenScaleY - banner.height;
			
			banner.show();
		}
		
		private function onBannerDisplayed():void {
			trace("MoPub banner displayed.");
			_isDisplayed = true;
			if(onDisplayed != null)
				onDisplayed();
		}
		
		private function onBannerFailToLoad(ev:MoPubEvent):void {
			if(++nLoadRetries > MAX_LOAD_RETRY_ON_FAIL) {
				trace("MoPub banner failed to load too many times. Aborting.");
				return;
			}
			trace("MoPub banner failed to load, retrying ...");
			banner.load();
		}
		
		private function onBannerClicked(ev:MoPubEvent):void {
			trace("MoPub banner clicked.");
		}
		
		/**
		 * Removes the banner from the screen. Call dispose() to release memory.
		 */
		public function remove():void {
			if(banner) {
				banner.autorefresh = false;
				banner.removeEventListener(MoPubEvent.AD_LOADED, onBannerLoaded);
				banner.removeEventListener(MoPubEvent.AD_FAILED_TO_LOAD, onBannerFailToLoad);
				banner.removeEventListener(MoPubEvent.BANNER_CLICKED, onBannerClicked);

				banner.remove();
				banner.dispose();
				
				banner = null;
			}
			_isDisplayed = false;
			
			trace("MoPub banner removed.");
			if(onRemoved != null)
				onRemoved();
		}
	}
}