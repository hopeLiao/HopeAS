package com.hope.game.display
{
	import flash.display.Sprite;

	/**
	 * 对舞台大小敏感的容器类
	 * @author 123
	 */
	public class Widget extends Sprite
	{
		public function Widget()
		{
			super();
		}

		/**
		 * 当舞台大小发生变化时，会通知进来
		 */
		public function onResizeX():void {
		}

		/**
		 * 当舞台大小发生变化时，会通知进来
		 */
		public function onResizeY():void {
		}
	}
}

