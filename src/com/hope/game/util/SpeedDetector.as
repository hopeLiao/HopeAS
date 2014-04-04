package com.hope.game.util
{
	import flash.utils.getTimer;

	/**
	 * 是否使用加速器
	 * @author 123
	 */
	public class SpeedDetector
	{
		private static const ERRDIFF:int = 100;
		private static var dateTime:Number
		private static var flashTime:Number;
		private static var cheatNum:int;

		public static var isError:Boolean = false;

		public function SpeedDetector()
		{
		}

		public static function start():void {
			dateTime = (new Date).time;
			flashTime = getTimer();
		}

		private static function doDetector():void {
			var dateDur:int = (new Date).time - dateTime;
			var flashDur:int = getTimer() - flashTime;
			if (flashDur - dateDur > ERRDIFF) {
				cheatNum++;
				if (cheatNum > 5) {
					if (!isError) {
						isError = true;
					}
				}
			} else {
				cheatNum = 0;
			}
		}
	}
}

