package com.hope.util
{
	public class MathUtil
	{
		public function MathUtil()
		{
		}

		/**
		 * 判断一个数是不是奇数。
		 * @param num 待判断的数。
		 * @return 如果是奇数，则返回 true ；是偶数，则返回 false 。
		 *
		 */             
		public static function isOdd(num:Number):Boolean
		{
			//摘自riaoo.com
			return Boolean(num & 1);
		}
	}
}

