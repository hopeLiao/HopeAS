package com.hope.game.layer
{
	import com.hope.game.display.Layer;
	import com.hope.game.display.Panel;

	/**
	 * UI层容器
	 * 理论上该容器只用来管理panel，不负责管理panel的加载
	 * @author 123
	 */
	public class PanelRootLayer extends Layer
	{
		public function PanelRootLayer()
		{
		}

		/**
		 * 把panel作为dock展示(底层)
		 * dock因为切换比较频繁，所以设置visible最方便高效
		 * @param dock
		 */
		public function addDock(dock:Panel):void{

		}

		/**
		 * 把panel作为window层展示
		 * window因为可能长期不使用，所以使用remove，add比较合适
		 * @param window
		 */
		public function addWindow(window:Panel):void{

		}

		/**
		 * 把panel作为dialog层展示(顶层)
		 * @param dialog
		 */
		public function addDialog(dialog:Panel):void{

		}
	}
}

