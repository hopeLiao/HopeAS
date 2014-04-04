package com.hope.util
{
	public final class StringUtil
	{
		public function StringUtil()
		{
		}

		public static function join(... args):String{
//			var s:String="";
//			for each(var o:Object in args)
//				s+=o+" ";
//			return s;
			return args.join(" ");
		}

		public static function trim(s:String):String{
			//摘自minimalComps
			// http://jeffchannell.com/ActionScript-3/as3-trim.html
			return s.replace(/^\s+|\s+$/gs, '');
		}

		/**
		 *	Replaces all instances of the replace string in the input string
		 *	with the replaceWith string.
		 *
		 *	@param input The string that instances of replace string will be
		 *	replaces with removeWith string.
		 *
		 *	@param replace The string that will be replaced by instances of
		 *	the replaceWith string.
		 *
		 *	@param replaceWith The string that will replace instances of replace
		 *	string.
		 *
		 *	@returns A new String with the replace string replaced with the
		 *	replaceWith string.
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */
		public static function replace(input:String, replace:String, replaceWith:String):String
		{
			//摘自 adobe
			return input.split(replace).join(replaceWith);
		}

		/**
		 *	Removes whitespace from the front and the end of the specified
		 *	string.
		 *
		 *	@param input The String whose beginning and ending whitespace will
		 *	will be removed.
		 *
		 *	@returns A String with whitespace removed from the begining and end
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */			
		public static function trim2(input:String):String
		{
			//摘自 adobe
			return StringUtil.ltrim(StringUtil.rtrim(input));
		}

		/**
		 *	Removes whitespace from the front of the specified string.
		 *
		 *	@param input The String whose beginning whitespace will will be removed.
		 *
		 *	@returns A String with whitespace removed from the begining
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */	
		public static function ltrim(input:String):String
		{
			//摘自 adobe
			var size:Number = input.length;
			for(var i:Number = 0; i < size; i++)
			{
				if(input.charCodeAt(i) > 32)
				{
					return input.substring(i);
				}
			}
			return "";
		}

		/**
		 *	Removes whitespace from the end of the specified string.
		 *
		 *	@param input The String whose ending whitespace will will be removed.
		 *
		 *	@returns A String with whitespace removed from the end
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */	
		public static function rtrim(input:String):String
		{
			//摘自 adobe
			var size:Number = input.length;
			for(var i:Number = size; i > 0; i--)
			{
				if(input.charCodeAt(i - 1) > 32)
				{
					return input.substring(0, i);
				}
			}

			return "";
		}

		/**
		 *	Determines whether the specified string begins with the spcified prefix.
		 *
		 *	@param input The string that the prefix will be checked against.
		 *
		 *	@param prefix The prefix that will be tested against the string.
		 *
		 *	@returns True if the string starts with the prefix, false if it does not.
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */	
		public static function beginsWith(input:String, prefix:String):Boolean
		{			
			//摘自 adobe
			return (prefix == input.substring(0, prefix.length));
		}	

		/**
		 *	Determines whether the specified string ends with the spcified suffix.
		 *
		 *	@param input The string that the suffic will be checked against.
		 *
		 *	@param prefix The suffic that will be tested against the string.
		 *
		 *	@returns True if the string ends with the suffix, false if it does not.
		 *
		 * 	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0
		 *	@tiptext
		 */	
		public static function endsWith(input:String, suffix:String):Boolean
		{
			//摘自 adobe
			return (suffix == input.substring(input.length - suffix.length));
		}

	}
}

