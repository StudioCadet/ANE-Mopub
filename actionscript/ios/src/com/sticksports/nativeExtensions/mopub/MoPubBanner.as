package com.sticksports.nativeExtensions.mopub
{
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;

	public class MoPubBanner extends EventDispatcher
	{
// native method names

		private static const initialiseBanner : String = "initialiseBanner";
		
		private static const setAdUnitId : String = "setAdUnitId";
		private static const setAutorefresh : String = "setAutorefresh";
		private static const setTestMode : String = "setTestMode";
		private static const setLockNativeAdsToOrientation : String = "lockNativeAdsToOrientation";
		
		private static const getPositionX : String = "getPositionX";
		private static const setPositionX : String = "setPositionX";
		private static const getPositionY : String = "getPositionY";
		private static const setPositionY : String = "setPositionY";
		private static const getWidth : String = "getWidth";
		private static const setWidth : String = "setWidth";
		private static const getHeight : String = "getHeight";
		private static const setHeight : String = "setHeight";
		
		private static const setSize : String = "setSize";
		private static const getCreativeWidth : String = "getCreativeWidth";
		private static const getCreativeHeight : String = "getCreativeHeight";
		
		private static const setBannerKeywords : String = "setBannerKeywords";
		
		private static const loadBanner : String = "loadBanner";
		private static const showBanner : String = "showBanner";
		private static const removeBanner : String = "removeBanner";

// class variables

		private var extensionContext : ExtensionContext = null;

		private var _adUnitId : String;
		private var _testing : Boolean = false;
		private var _autoRefresh : Boolean = true;
		private var _nativeAdsOrientation : MoPubNativeAdOrientation = MoPubNativeAdOrientation.any;
		private var _size : MoPubSize;

// properties

		public function get adUnitId() : String
		{
			return _adUnitId;
		}

		public function set adUnitId( value : String ) : void
		{
			_adUnitId = value;
			extensionContext.call( setAdUnitId, value );
		}

		public function get autorefresh() : Boolean
		{
			return _autoRefresh;
		}

		public function set autorefresh( value : Boolean ) : void
		{
			_autoRefresh = value;
			extensionContext.call( setAutorefresh, value );
		}

		public function get testing() : Boolean
		{
			return _testing;
		}

		public function set testing( value : Boolean ) : void
		{
			_testing = value;
			extensionContext.call( setTestMode, value );
		}

		public function get nativeAdsOrientation() : MoPubNativeAdOrientation
		{
			return _nativeAdsOrientation;
		}

		public function set nativeAdsOrientation( value : MoPubNativeAdOrientation ) : void
		{
			_nativeAdsOrientation = value;
			extensionContext.call( setLockNativeAdsToOrientation, value.id );
		}

		public function get x() : int
		{
			return extensionContext.call( getPositionX ) as int;
		}

		public function set x( value : int ) : void
		{
			extensionContext.call( setPositionX, value );
		}

		public function get y() : int
		{
			return extensionContext.call( getPositionY ) as int;
		}

		public function set y( value : int ) : void
		{
			extensionContext.call( setPositionY, value );
		}

		public function get width() : int
		{
			return extensionContext.call( getWidth ) as int;
		}

		public function set width( value : int ) : void
		{
			_size = null;
			extensionContext.call( setWidth, value );
		}

		public function get height() : int
		{
			return extensionContext.call( getHeight ) as int;
		}

		public function set height( value : int ) : void
		{
			_size = null;
			extensionContext.call( setHeight, value );
		}

		public function get size() : MoPubSize
		{
			return _size;
		}

		public function set size( value : MoPubSize ) : void
		{
			_size = value;
			extensionContext.call( setSize, value.id );
		}

		public function get creativeWidth() : int
		{
			return extensionContext.call( getCreativeWidth ) as int;
		}

		public function get creativeHeight() : int
		{
			return extensionContext.call( getCreativeHeight ) as int;
		}

// methods

		public function MoPubBanner( adUnitId : String, size : MoPubSize )
		{
			extensionContext = ExtensionContext.createExtensionContext( "com.sticksports.nativeExtensions.MoPub", "banner" );
			extensionContext.addEventListener( StatusEvent.STATUS, handleStatusEvent );
			_adUnitId = adUnitId;
			_size = size;
			extensionContext.call( initialiseBanner, adUnitId, size.id );
		}
		
		private function handleStatusEvent( event : StatusEvent ) : void
		{
			switch( event.level )
			{
				case InternalMessages.bannerLoaded :
					dispatchEvent( new MoPubEvent( MoPubEvent.AD_LOADED ) );
					break;
				case InternalMessages.bannerFailedToLoad :
					dispatchEvent( new MoPubEvent( MoPubEvent.AD_FAILED_TO_LOAD ) );
					break;
				case InternalMessages.bannerAdClicked :
					dispatchEvent( new MoPubEvent( MoPubEvent.BANNER_CLICKED ) );
					break;
				case InternalMessages.bannerAdClosed :
					dispatchEvent( new MoPubEvent( MoPubEvent.AD_CLOSED ) );
					break;
			}
		}
		
		private function setKeywords( keywords : MoPubKeywords ):void
		{
			extensionContext.call( setBannerKeywords, keywords.getAsString() );
		}

		public function load() : void
		{
			extensionContext.call( loadBanner );
		}

		public function show() : void
		{
			extensionContext.call( showBanner );
		}

		public function remove() : void
		{
			extensionContext.call( removeBanner );
		}
	}
}

