package {
	import com.sticksports.nativeExtensions.mopub.MoPubEvent;
	import com.sticksports.nativeExtensions.mopub.MoPubInterstitial;
	import com.sticksports.nativeExtensions.mopub.MoPubKeywords;
	
	/**
	 * A wrapper around MoPub interstitial ad system.
	 */
	public class MpInterstitial {
		
		// CONFIG :
		private static const MAX_LOAD_RETRY_ON_FAIL:int = 3;
		/** The delay when coming back from a displayed interstitial before calling the registered onComplete callback. */
		private static const APP_RESUME_DELAY:Number = .25;
		
		// PROPERTIES :
		/** The MoPubInterstitial instance used. */
		public var interstitial:MoPubInterstitial;
		private var onFetched:Function;
		private var onComplete:Function;
		
		private var nLoadRetries:int;
		
		/** Whether the interstitial has already been fetched. */
		public function get isFetched():Boolean {
			return interstitial.isReady;
		}
		
		
		// CONSTRUCTOR :
		public function MpInterstitial(adUnit:String) {
			interstitial = new MoPubInterstitial(adUnit);
			
			interstitial.addEventListener(MoPubEvent.AD_LOADED, onInterstitialLoaded);
			interstitial.addEventListener(MoPubEvent.AD_FAILED_TO_LOAD, onInterstitialFailToLoad);
			interstitial.addEventListener(MoPubEvent.INTERSTITIAL_EXPIRED, onInterstitialExpired);
			interstitial.addEventListener(MoPubEvent.AD_CLOSED, onInterstitialClosed);
			interstitial.addEventListener(MoPubEvent.INTERSTITIAL_SHOWN, onInterstitialShown);
		}
		
		
		//////////////
		// FETCHING //
		//////////////
		
		/**
		 * Preloads the interstitial ad.
		 */
		public function fetch(onFetched:Function):void {
			this.onFetched = onFetched;
			
			if(interstitial.isReady) {
				trace("MoPub interstitial ad already fetched.");
				if(onFetched != null)
					onFetched();
				return;
			}
			
			trace("Fetching a MoPub interstitial ad ...");
			nLoadRetries = 0;
			interstitial.load();
		}
		
		private function onInterstitialLoaded(ev:MoPubEvent):void {
			trace("MoPub interstitial ad loaded successfully.");
			if(onFetched != null)
				onFetched();
		}
		
		private function onInterstitialFailToLoad(ev:MoPubEvent):void {
			if(++nLoadRetries > MAX_LOAD_RETRY_ON_FAIL) {
				trace("MoPub interstitial ad failed to load too many times. Aborting.");
				return;
			}
			trace("MoPub interstitial ad failed to load, retrying ...");
			interstitial.load();
		}
		
		private function onInterstitialExpired(ev:MoPubEvent):void {
			trace("MoPub interstitial ad has expired, reloading another one ...");
			nLoadRetries = 0;
			interstitial.load();
		}
		
		
		////////////////
		// DISPLAYING //
		////////////////
		
		/**
		 * Displays the ad if the ad is already fetched.
		 */
		public function show(onComplete:Function):void {
			if(!isFetched) {
				trace("MoPub interstitial ad is not fetched, it cannot be displayed.");
				if(onComplete != null)
					onComplete();
				return;
			}
			
			this.onComplete = onComplete;
			showInterstitial();
		}
		
		/**
		 * Really displays the interstitial.
		 */
		private function showInterstitial():void {
			if(interstitial.show()) {
				trace("MoPub interstitial ad displayed successfully.");
			}
			else {
				trace("MoPub interstitial ad failed to display.");
				if(onComplete != null)
					onComplete();
			}
		}
		
		private function onInterstitialShown(ev:MoPubEvent):void {
			trace("MoPub interstitial ad shown (MoPubEvent).");
		}
		private function onInterstitialClosed(ev:MoPubEvent):void {
			trace("MoPub interstitial ad closed.");
			
			if (onComplete != null)
				onComplete();
		}
		
		
		//////////////
		// CLEAN UP //
		//////////////
		
		/**
		 * Cleans up the interstitial ad.
		 */
		public function dispose():void {
			interstitial.removeEventListener(MoPubEvent.AD_LOADED, onInterstitialLoaded);
			interstitial.removeEventListener(MoPubEvent.AD_FAILED_TO_LOAD, onInterstitialFailToLoad);
			interstitial.removeEventListener(MoPubEvent.INTERSTITIAL_EXPIRED, onInterstitialExpired);
			interstitial.removeEventListener(MoPubEvent.AD_CLOSED, onInterstitialClosed);
			interstitial.removeEventListener(MoPubEvent.INTERSTITIAL_SHOWN, onInterstitialShown);
			interstitial.dispose();
			interstitial = null;
			trace("MoPub interstitial ad disposed.");
		}
	}
}