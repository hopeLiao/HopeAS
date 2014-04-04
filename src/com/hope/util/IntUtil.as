package com.hope.util
{
	public class IntUtil
	{
		public function IntUtil()
		{
		}

		/**
		 * Rotates x left n bits
		 *	支持负数的移位操作，摘自adobe
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public static function rol ( x:int, n:int ):int {
			return ( x << n ) | ( x >>> ( 32 - n ) );
		}

		/**
		 * Rotates x right n bits
		 *	支持负数的移位操作，摘自adobe
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public static function ror ( x:int, n:int ):uint {
			var nn:int = 32 - n;
			return ( x << nn ) | ( x >>> ( 32 - nn ) );
		}
	}
}

