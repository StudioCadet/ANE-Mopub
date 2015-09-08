package com.sticksports.nativeExtensions.mopub
{
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.utils.setTimeout;

	public class MoPubBanner extends EventDispatcher
	{
// class variables

		private var _adUnitId : String;
		private var _autorefresh : Boolean = false;
		private var _testing : Boolean = false;
		private var _nativeAdsOrientation : MoPubNativeAdOrientation = MoPubNativeAdOrientation.any;
		private var _size : MoPubSize;

		private var _x : Number = 0;
		private var _y : Number = 0;
		private var _width : Number = 0;
		private var _height : Number = 0;
		
		private var fakeBanner:Sprite;
		private var disposed:Boolean;
		
		
		// DEBUG SETTINGS :
		/** The average fail rate when loading a banner. The value must be between 0.0 and 1.0 . */
		private var failRate:Number;
		/** The response time when loading a banner. The value is given in seconds. */
		private var responseTime:Number;

// properties

		public function get adUnitId() : String
		{
			return _adUnitId;
		}

		public function set adUnitId( value : String ) : void
		{
			_adUnitId = value;
		}

		public function get autorefresh() : Boolean
		{
			return _autorefresh;
		}

		public function set autorefresh( value : Boolean ) : void
		{
			_autorefresh = value;
		}

		public function get testing() : Boolean
		{
			return _testing;
		}

		public function set testing( value : Boolean ) : void
		{
			_testing = value;
		}

		public function get nativeAdsOrientation() : MoPubNativeAdOrientation
		{
			return _nativeAdsOrientation;
		}

		public function set nativeAdsOrientation( value : MoPubNativeAdOrientation ) : void
		{
			_nativeAdsOrientation = value;
		}

		public function get x() : Number
		{
			return _x;
		}

		public function set x( value : Number ) : void
		{
			if(disposed) return;
			_x = value;
			fakeBanner.x = value;
		}

		public function get y() : Number
		{
			return _y;
		}

		public function set y( value : Number ) : void
		{
			if(disposed) return;
			_y = value;
			fakeBanner.y = value;
		}

		public function get width() : Number
		{
			return _width;
		}

		public function set width( value : Number ) : void
		{
			if(disposed) return;
			_width = value;
			fakeBanner.width = value;
		}

		public function get height() : Number
		{
			return _height;
		}

		public function set height( value : Number ) : void
		{
			if(disposed) return;
			_height = value;
			fakeBanner.height = value;
		}

		public function get size() : MoPubSize
		{
			return _size;
		}

		public function set size( value : MoPubSize ) : void
		{
			_size = value;
		}

		public function get creativeWidth() : Number
		{
			return _width;
		}

		public function get creativeHeight() : Number
		{
			return _height;
		}

// methods

		public function MoPubBanner( adUnitId : String, size : MoPubSize )
		{
			disposed = false;
			_adUnitId = adUnitId;
			_size = size;

			switch( size )
			{
				case MoPubSize.banner:
					_width = 320;
					_height = 50;
					break;
				case MoPubSize.mediumRectangle:
					_width = 300;
					_height = 250;
					break;
				case MoPubSize.leaderboard:
					_width = 728;
					_height = 90;
					break;
				case MoPubSize.wideSkyscraper:
					_width = 160;
					_height = 600;
					break;
			}
			
			if(MoPub.stage == null) {
				// If no stage has been passed to MoPub at initialization, the fake banners will not be displayed.
				disposed = true;
				return;
			}
				
				
				
			fakeBanner = new Sprite();
			fakeBanner.graphics.beginFill(Math.random() * 0xFFFFFF, 1);
			fakeBanner.graphics.drawRect(0,0,_width,_height);
			fakeBanner.graphics.endFill();
			fakeBanner.visible = false;
			MoPub.stage.addChild(fakeBanner);
		}
		
		public function load() : void {
			if(isNaN(responseTime))
				loadingResponse();
			else
				setTimeout(loadingResponse, responseTime * 1000);
		}
		
		private function loadingResponse():void {
			// Simulates banners failing to load.
			if(isNaN(failRate) || Math.random() > failRate)
				dispatchEvent( new MoPubEvent( MoPubEvent.AD_LOADED ) );
			else
				dispatchEvent(new MoPubEvent( MoPubEvent.AD_FAILED_TO_LOAD) );
		}
		

		public function show() : void {
			if(disposed) return;
			fakeBanner.visible = true;
		}

		public function remove() : void {
			if(disposed) return;
			fakeBanner.visible = false;
		}
		
		public function dispose() : void {
			if(MoPub.stage != null) {
				MoPub.stage.removeChild(fakeBanner);
				fakeBanner = null;
			}
			disposed = true;
		}
		
		
		
		
		///////////
		// DEBUG //
		///////////
		
		/**
		 * Sets the desired settings for debugging banners. <br/>The given failRate will define the percentage of chances to fail
		 * a banner loading. The failures will be picked randomly when calling <code>load()</code>. </br>
		 * The given responseTime tells the delay to wait before sending a loading complete or failed, to simulate the asynchronous loading.
		 */
		public function setDebugSettings(failRate:Number, responseTime:Number):void {
			this.failRate = failRate;
			this.responseTime = responseTime;
		}
		
	}
}

