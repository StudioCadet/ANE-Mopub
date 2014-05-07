package com.sticksports.nativeExtensions.mopub
{
	import flash.events.EventDispatcher;

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
			_x = value;
		}

		public function get y() : Number
		{
			return _y;
		}

		public function set y( value : Number ) : void
		{
			_y = value;
		}

		public function get width() : Number
		{
			return _width;
		}

		public function set width( value : Number ) : void
		{
			_width = value;
		}

		public function get height() : Number
		{
			return _height;
		}

		public function set height( value : Number ) : void
		{
			_height = value;
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
			return 0;
		}

		public function get creativeHeight() : Number
		{
			return 0;
		}

// methods

		public function MoPubBanner( adUnitId : String, size : MoPubSize )
		{
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
		}
		
		public function setKeywords( keywords : MoPubKeywords ):void
		{
		}
		
		public function load() : void
		{
		}

		public function show() : void
		{
		}

		public function remove() : void
		{
		}
		
		public function dispose() : void
		{
		}
	}
}

