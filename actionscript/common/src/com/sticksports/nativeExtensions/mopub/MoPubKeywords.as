package com.sticksports.nativeExtensions.mopub {
	
	/**
	 * 
	 */
	public class MoPubKeywords {
		
		// CONSTANTS :
		public static const GENDER_M:String = "m";
		public static const GENDER_F:String = "f";
		
		public static const INMOBI_VALID_INTERESTS:Vector.<String> = new <String>[
			"Business", "Tech", "Travel", "Shopping", "Entertainment", "Fashion", "Fitness", "Foodie", "Gamer", "Jobs", "Sports"
		];
		
		// PROPERTIES :
		/** The age of the user. */
		public var age:int;
		
		/** The date of birth. */
		public var dateOfBirth:Date;
		
		/** The date of birth timestamp, or null if no date of birth is registered. */
		public function get dateOfBirthTimestamp():* {
			return dateOfBirth == null ? null : dateOfBirth.time;
		}
		
		/** One of the gender constant. */
		public var gender:String;
		
		/** ISO 639-2/5 language description. */
		public var language:String;
		
		private var _additionalKeywordsKeys:Array;
		/** The list of additionalKeywords's keys, synced with additionalKeywordsValues. */
		internal function get additionalKeywordsKeys():Array { return _additionalKeywordsKeys; }

		private var _additionalKeywordsValues:Array;
		/** The list of additionalKeywords's values, synced with additionalKeywordsKeys. */
		internal function get additionalKeywordsValues():Array { return _additionalKeywordsValues; }
		
		private var _inMobiInterests:Vector.<String>;
		/** The list of registered interests to pass to InMobi. */
		internal function get inMobiInterests():Vector.<String> { return _inMobiInterests; }
		
		// CONSTRUCTOR :
		public function MoPubKeywords() {
		}
		
		
		// METHODS :
		
		/**
		 * Registers the given additionnal keywords.
		 */
		public function setAdditionalKeywords(additionalKeywords:Object):void {
			if(additionalKeywords == null) {
				_additionalKeywordsKeys = null;
				_additionalKeywordsValues = null;
			}
			else {
				_additionalKeywordsKeys = [];
				_additionalKeywordsValues = [];
				for(var key:String in additionalKeywords) {
					_additionalKeywordsKeys.push(key);
					_additionalKeywordsValues.push(additionalKeywords[key]);
				}
			}
		}
		
		/**
		 * Registers the given list of InMobi interests. Only valid InMobi interests will be kept, and each interest will be kept only once.
		 * Returns the list of InMobi interests registered.
		 */
		public function setInMobiInterests(... interests):Vector.<String> {
			_inMobiInterests = new Vector.<String>();
			var i:int, n:int = interests.length;
			for(i = 0 ; i < n ; i++) {
				if(_inMobiInterests.indexOf(interests[i]) != -1)
					continue;
				if(INMOBI_VALID_INTERESTS.indexOf(interests[i]) == -1)
					continue;
				_inMobiInterests.push(interests[i]);
			}
			return _inMobiInterests;
		}
		
		
		/**
		 * Pretty printing of the keywords.
		 */
		public function toString():String {
			var s:String = "{age:" + age + "; dateOfBirth:" + dateOfBirth + "; gender:" + gender + "; language:" + language + "; additionalKeywords:[";
			if(additionalKeywordsKeys != null) {
				var i:int, n:int = additionalKeywordsKeys.length;
				for(i = 0 ; i < n ; i++)
					s += additionalKeywordsKeys[i] + ":" + additionalKeywordsValues[i] + "; ";
				if(n > 0)
					s = s.substr(0, s.length - 2);
			}
			s += "]; inMobiInterests:[" + (_inMobiInterests != null ? _inMobiInterests.join(", ") : "") + "]}";
			
			return s;
		}
	}
}