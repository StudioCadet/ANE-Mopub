package com.sticksports.nativeExtensions.mopub {
	
	/**
	 * 
	 */
	public class MoPubKeywords {
		
		// CONSTANTS :
		public static const GENDER_M:String = "m";
		public static const GENDER_F:String = "f";
		
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
		 * Pretty printing of the keywords.
		 */
		public function toString():String {
			var s:String = "[age:" + age + "; dateOfBirth:" + dateOfBirth + "; gender:" + gender + "; language:" + language + "; additionalKeywords:{";
			if(additionalKeywordsKeys != null) {
				var i:int, n:int = additionalKeywordsKeys.length;
				for(i = 0 ; i < n ; i++)
					s += additionalKeywordsKeys[i] + ":" + additionalKeywordsValues[i] + "; ";
				if(n > 0)
					s = s.substr(0, s.length - 2);
			}
			s += "}]";
			return s;
		}
	}
}