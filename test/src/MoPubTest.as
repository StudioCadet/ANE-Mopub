package {
	import com.sticksports.nativeExtensions.mopub.MoPub;
	import com.sticksports.nativeExtensions.mopub.MoPubBanner;
	import com.sticksports.nativeExtensions.mopub.MoPubKeywords;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;
	
	
	/**
	 *
	 */
	public class MoPubTest extends Sprite {
		
		// PROPERTIES :
		private var banner:MpBanner;
		private var interstitial:MpInterstitial;
		
		private var dy:Number;
		
		// CONSTRUCTOR
		public function MoPubTest() {
			super();
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			
			trace("### Starting time : " + getTimer() + "ms");
			
			initDisplay();
			initMoPub();
		}
		
		
		/////////////
		// DISPLAY //
		/////////////
		
		private function initDisplay():void {
			dy = 30;
			
			addButton("Track conversion", trackConversion);
			addButton("Set keywords", setKeywords);
			addButton("Show banner", showBanner);
			addButton("Remove banner", removeBanner);
			addButton("Fetch interstitial", fetchInterstitial);
			addButton("Interstitial is fetched ?", interstitialIsReady);
			addButton("Show interstitial", showInterstitial);
			addButton("Apple IDFA", appleIDFA);
			addButton("Android AdvertisingID", androidAdvertisingId);
			addButton("Android IMEI", androidIMEI);
			addButton("Android ID", androidId);
			
		}
		
		private function addButton(label:String, onClick:Function):void {
			var b:Sprite = new Sprite();
			b.graphics.beginFill(0xbbbbbb);
			b.graphics.lineStyle(1, 0x222222, 1, true);
			b.graphics.drawRect(0, 0, stage.stageWidth - 20, 40);
			b.graphics.endFill();
			b.x = 10;
			b.y = dy;
			dy += 70;
			
			var tf:TextField = new TextField();
			tf.defaultTextFormat = new TextFormat("Arial", 14, 0, true, null, null, null, null, TextFormatAlign.CENTER);
			tf.text = label;
			tf.x = 10;
			tf.y = 10;
			tf.selectable = false;
			tf.width = stage.stageWidth - 40;
			tf.height = 20;
			b.addChild(tf);
			
			b.addEventListener(MouseEvent.CLICK, function(ev:MouseEvent):void { onClick(); });
			
			addChild(b);
		}
		
		///////////
		// MOPUB //
		///////////
		
		/**
		 * Initializes MoPub ANE.
		 */
		private function initMoPub():void {
			trace("Initializing MoPub ...");
			MoPub.init();
			AdUnit.init();
			banner = new MpBanner(stage, AdUnit.getId(AdUnit.MP_BANNER), AdUnit.isTablet);
			interstitial = new MpInterstitial(AdUnit.getId(AdUnit.MP_INTERSTITIAL));
			trace("MoPub initialized.");
		}
		
		private function trackConversion():void {
			trace("Tracking install conversion for MoPub ...");
			MoPub.trackConversion();
			trace("Done.");
		}
		
		private function setKeywords():void {
			const keywords:MoPubKeywords = new MoPubKeywords();
			keywords.age = int(Math.random() * 50 + 10);
			keywords.dateOfBirth = new Date(2000, 0, 1);
			keywords.gender = Math.random() > .5 ? MoPubKeywords.GENDER_F : MoPubKeywords.GENDER_M;
			keywords.language = Math.random() > .5 ? "eng" : "fre";
			keywords.setAdditionalKeywords({property1:"Value1", property2:"Value2", property3:"Value3"});
			keywords.setInMobiInterests("Business", "Travel", "Business", "InvalidInterest");
			trace("Setting keywords : " + keywords + " ...");
			MoPub.setKeywords(keywords);
			trace("Done.");
		}
		
		private function showBanner():void {
			trace("Showing banner ...");
			banner.display(
				function():void { trace("Banner displayed."); },
				function():void { trace("Banner removed."); }
			);
		}
		
		private function removeBanner():void {
			trace("Removing banner ...");
			banner.remove();
			trace("Done.");
		}
		
		private function fetchInterstitial():void {
			trace("Fetching an interstitial ...");
			interstitial.fetch(function():void { trace("Interstitial fetched."); });
		}
		
		private function interstitialIsReady():void {
			trace("Intersitital is ready ? " + interstitial.isFetched);
		}
		
		private function showInterstitial():void {
			trace("Showing interstitial ...");
			interstitial.show(function():void { trace("Interstitial shown."); });
		}
		
		private function appleIDFA():void {
			trace("Apple IDFA : " + MoPub.getAppleIDFA());
		}
		
		private function androidAdvertisingId():void {
			trace("Android Advertising ID : " + MoPub.getAndroidAdvertisingId());
		}
		
		private function androidIMEI():void {
			trace("Android IMEI : " + MoPub.getAndroidIMEI());
		}
		
		private function androidId():void {
			trace("Android ID : " + MoPub.getAndroidId());
		}
	}
}