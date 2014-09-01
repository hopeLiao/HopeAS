package com.yueyi.core.load.hope
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * 资源加载
	 * 目前的设计理念是对的，loader只管加载，不管ui等任何问题
	 * @author 123
	 */
	/**
	 *
	 * @author 123
	 */
	public class HopeLoader
	{
		/**
		 * var的content关键字
		 * @default
		 */
		public static const CONTEXT:String = "context";

		/**
		 * var的优先级关键字
		 * @default
		 */
		public static const PRIORITY:String = "priority";

		/**
		 * var的加载预估大小关键字
		 * @default
		 */
		public static const AUDITEDSIZE:String = "auditedSize";

		/**
		 * var的加载参数关键字
		 * @default
		 */
		public static const VERSION:String = "version";

		/**
		 * var的progress关键字
		 * @default
		 */
		public static const ONPROGRESS:String = "onProgress";

		/**
		 * var的event关键字
		 * @default
		 */
		public static const LISTENERTYPES:Object = {onComplete: "complete", onProgress: "progress", onChildOpen: "childOpen", onChildComplete: "childComplete", onChildFail: "childFail"};

		/**
		 * 最大加载并发数
		 * 如果控制更细的话，应该根据域名控制并发数,这样子效率更高
		 * @default
		 */
		public static const MAXCONNECTION:int = 3;
		public static const MAXPRIORITY:int = 3;
		public static const MINPRIORITY:int = 1;
		public static const NMLPRIORITY:int = 2;

		/**
		 * 错误尝试次数
		 * @default
		 */
		public static const MAXTRYTIMES:int = 3;

		protected static var IMAGE_EXTENSIONS:Array = ["jpg", "jpeg", "gif", "png", 'swf'];
		protected static var TEXT_EXTENSIONS:Array = ["txt", "js", "json"];

		public function HopeLoader() {
		}

		/**
		 * 开始加载资源
		 * @param urls 单个url字符串也可以是多个url组成的数组
		 * @param vars 加载参数
		 * @return
		 */
		public function newTask(urls:Object, vars:Object):LoaderTask {
			if (!urls)
				return null;
			if (!vars)
				vars = {};
			if (vars.isGSVars)
				vars = vars.vars;
			var task:LoaderTask = new LoaderTask(vars, this);
			if (urls is Array) {
				for each (var url:String in urls)
					if (url)
						task.append(newTaskItem(url, vars));
			} else if (urls is String) {
				task.append(newTaskItem(urls as String, vars));
			}
			//task.load();
			return task;
		}

		private var itemDic:Dictionary = new Dictionary;

		private function newTaskItem(url:String, vars:Object):LoaderItem {
			var item:LoaderItem = itemDic[url];
			if (!item) {
				var searchString:String = url.indexOf("?") > -1 ? url.substring(0, url.indexOf("?")) : url;
				var finalPart:String = searchString.substring(searchString.lastIndexOf("/"));
				var extension:String = finalPart.substring(finalPart.lastIndexOf(".") + 1).toLowerCase();
				if (IMAGE_EXTENSIONS.indexOf(extension) > -1)
					item = new ImageItem(url, vars);
				else if (TEXT_EXTENSIONS.indexOf(extension) > -1)
					item = new TextItem(url, vars);
				else
					item = new BinaryItem(url, vars);
				itemDic[url] = item;
			}
			return item;
		}

		public function getLoadItem(url:String):LoaderItem {
			return itemDic[url];
		}

		public function getMovieClip(url:String):MovieClip {
			var item:LoaderItem = itemDic[url];
			if (item)
				return item.content;
			return null;
		}

		public function getBitmapData(url:String):BitmapData {
			var item:LoaderItem = itemDic[url];
			if (item) {
				var bmp:Bitmap = item.content;
				if (bmp)
					return bmp.bitmapData;
			}
			return null;
		}

		public function getText(url:String):String {
			var item:LoaderItem = itemDic[url];
			if (item)
				return item.content;
			return null;
		}

		public function getBinary(url:String):ByteArray {
			var item:LoaderItem = itemDic[url];
			if (item)
				return item.content;
			return null;
		}

		public function getClass(url:String, name:String):Class {
			var item:ImageItem = ImageItem(itemDic[url]);
			if (!item)
				return null;
			if (!item.hasDefinitionName(name))
				return null;
			return item.getDefinitionByName(name) as Class;
		}

		public function dispose(url:String):void {
			delete itemDic[url];
		}

		/**************处理真正的加载*******************************/
		/**************这里只要保证同时加载的进程在3个，至于item内部的逻辑交由task处理***************************/

		private var beLoadItems:Array = [[], [], [], []];
		private var doLoadItems:Array = [];

		/**
		 * 开始加载资源
		 * @param item loader的资源是没有加载过的，如果对于已经加载的资源则自动忽略
		 * @param priority loader的优先级 1 2 3 3最高,1最低,2是默认
		 */
		public function addItem(item:LoaderItem, priority:int = NMLPRIORITY):void {
			if (item.isLoaded)
				return;
			if (doLoadItems.indexOf(item) >= 0)
				return;
			if (priority > MAXPRIORITY || priority < MINPRIORITY)
				priority = NMLPRIORITY;
			item.loadTimes++;
			if (item.loadTimes > 1) //优先级的调整
				return;
			var items:Array = beLoadItems[priority];
//			var pos:int = items.indexOf(item);
//			if (pos < 0) {
//				for (var i:int = MAXPRIORITY; i >= MINPRIORITY; i--) {
//					if (i != priority) {
//						items = beLoadItems[i];
//						pos = items.indexOf(item);
//						if (pos >= 0) {
//							break;
//						}
//					}
//				}
//			}
//			if (pos >= 0)
//				return;
//			beLoadItems[priority].push(item);
			items.push(item);
			addEvent(item);
			tryDoLoad();
		}

		/**
		 * 取消资源加载
		 * @param item
		 * @param priority 先在对应的队列里找，但不一定能找到，只是为更快速的查找
		 */
		public function delItem(item:LoaderItem, priority:int = NMLPRIORITY):void {
			if (item.isLoaded)
				return;
			if (doLoadItems.indexOf(item) >= 0)
				return;
			if (priority > MAXPRIORITY || priority < MINPRIORITY)
				priority = NMLPRIORITY;
			item.loadTimes--;
			if (item.loadTimes > 0)
				return;
			var items:Array = beLoadItems[priority];
			var pos:int = items.indexOf(item);
			if (pos < 0) {
				for (var i:int = MAXPRIORITY; i >= MINPRIORITY; i--) {
					if (i != priority) {
						items = beLoadItems[i];
						pos = items.indexOf(item);
						if (pos >= 0) {
							break;
						}
					}
				}
			}
			if (pos >= 0)
				items.splice(pos, 1);
		}

		private function nextItem(item:LoaderItem):void {
			doLoadItems.splice(doLoadItems.indexOf(item), 1);
			delEvent(item);
			tryDoLoad();
		}

		private function tryDoLoad():void {
			if (doLoadItems.length < MAXCONNECTION) {
				var items:Array;
				var item:LoaderItem;
				for (var i:int = MAXPRIORITY; i >= MINPRIORITY; i--) {
					items = beLoadItems[i];
					if (items.length > 0) {
						item = items.shift();
						break;
					}
				}
				if (item) {
					doLoadItems.push(item);
					item.load();
				}
			}
		}

		protected function onItemSecurityError(event:Event):void {
			nextItem(event.target as LoaderItem);
		}

		protected function onItemError(event:IOErrorEvent):void {
			nextItem(event.target as LoaderItem);
		}

		protected function onItemComplete(event:Event):void {
			nextItem(event.target as LoaderItem);
		}

		private function addEvent(item:LoaderItem):void {
			item.addEventListener(Event.COMPLETE, onItemComplete);
			item.addEventListener(IOErrorEvent.IO_ERROR, onItemError);
			item.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onItemSecurityError);
		}

		private function delEvent(item:LoaderItem):void {
			item.removeEventListener(Event.COMPLETE, onItemComplete);
			item.removeEventListener(IOErrorEvent.IO_ERROR, onItemError);
			item.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onItemSecurityError);
		}
	}
}

