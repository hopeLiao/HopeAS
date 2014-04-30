package com.hope.loader {
	import com.hope.core.hope_internal;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	use namespace hope_internal;

	public class HopeLoader {

		public function HopeLoader() {
		}

		/**************Facade模式*******************************/
		/**************这段代码放loaderTask类里也ok*******************************/

		/**
		 * 开始加载资源
		 * @param urls 单个url字符串也可以是多个url组成的数组
		 * @param vars 加载参数
		 * @return
		 */
		public static function load(urls:Object, vars:Object):LoaderTask {
			if (!urls)
				return null;
			var task:LoaderTask=new LoaderTask(vars);
			if (urls is Array) {
				for each (var url:String in urls)
					task.append(newLoadItem(url));
			} else if (urls is String) {
				task.append(newLoadItem(urls as String));
			}
			task.load();
			return task;
		}

		protected static var IMAGE_EXTENSIONS:Array=["jpg", "jpeg", "gif", "png", 'swf'];
		protected static var TEXT_EXTENSIONS:Array=["txt", "js", "php", "asp", "py"];
		private static var itemDic:Dictionary=new Dictionary;

		private static function newLoadItem(url:String):LoaderItem {
			var item:LoaderItem=itemDic[url];
			if (!item) {
				var searchString:String=url.indexOf("?") > -1 ? url.substring(0, url.indexOf("?")) : url;
				var finalPart:String=searchString.substring(searchString.lastIndexOf("/"));
				var extension:String=finalPart.substring(finalPart.lastIndexOf(".") + 1).toLowerCase();
				if (IMAGE_EXTENSIONS.indexOf(extension) > -1)
					item=new ImageItem(url);
				else if (TEXT_EXTENSIONS.indexOf(extension) > -1)
					item=new TextItem(url);
				else
					item=new BinaryItem(url);
				itemDic[url]=item;
			}
			return item;
		}

		public static function getBitmapData(url:String):BitmapData {
			var item:LoaderItem=itemDic[url];
			if (item) {
				var bmp:Bitmap=item.content;
				return bmp.bitmapData;
			}
			return null;
		}

		public static function getText(url:String):String {
			var item:LoaderItem=itemDic[url];
			if (item)
				return item.content;
			return null;
		}

		public function getBinary(url:String):ByteArray {
			var item:LoaderItem=itemDic[url];
			if (item)
				return item.content;
			return null;
		}

		/**************处理真正的加载*******************************/
		/**************这里只要保证同时在家的进程在3个，至于item内部的逻辑交由task处理***************************/

		hope_internal static var instance:HopeLoader=new HopeLoader;

		/**
		 * 最大加载并发数
		 * 如果控制更细的话，应该根据域名控制并发数,这样子效率更高
		 * @default
		 */
		protected static const MAXCONNECTION:int=3;
		protected static const MAXPRIORITY:int=3;
		protected static const MINPRIORITY:int=1;
		private var beLoadItems:Array=[];
		private var loadingItems:Array=[];

		hope_internal function debug():void {
			trace(loadingItems.length);
			for each (var item:LoaderItem in loadingItems)
				trace(item.url, item.loaded, item.byteTotal, item.byteLoaded);
		}

		/**
		 * 开始加载资源
		 * @param item loader的资源是没有加载过的，如果对于已经加载的资源则自动忽略
		 * @param priority loader的优先级 1 2 3 3最高,1最低,2是默认
		 */
		hope_internal function loadItem(item:LoaderItem, priority:int=2):void {
			if (priority > MAXPRIORITY || priority < MINPRIORITY)
				priority=2;
			var items:Array=beLoadItems[priority];
			if (!items) {
				items=[];
				beLoadItems[priority]=items;
			}
			if (item.loaded || items.indexOf(item) >= 0 || loadingItems.indexOf(item) >= 0)
				return;
			items.push(item);
			addEvent(item);
			tryLoadNext();
		}

		protected function onItemSecurityError(event:Event):void {
			removePrev(event.target as LoaderItem);
		}

		protected function onItemError(event:IOErrorEvent):void {
			removePrev(event.target as LoaderItem);
		}

		protected function onItemComplete(event:Event):void {
			removePrev(event.target as LoaderItem);
		}

		private function addEvent(item:LoaderItem):void {
			item.addEventListener(Event.COMPLETE, onItemComplete, false, 0, true);
			item.addEventListener(IOErrorEvent.IO_ERROR, onItemError, false, 0, true);
			item.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onItemSecurityError, false, 0, true);
		}

		private function delEvent(item:LoaderItem):void {
			item.removeEventListener(Event.COMPLETE, onItemComplete);
			item.removeEventListener(IOErrorEvent.IO_ERROR, onItemError);
			item.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onItemSecurityError);
		}

		private function removePrev(item:LoaderItem):void {
			loadingItems.splice(loadingItems.indexOf(item), 1);
			delEvent(item);
			tryLoadNext();
		}

		private function tryLoadNext():void {
			if (loadingItems.length < MAXCONNECTION) {
				var items:Array;
				var item:LoaderItem;
				for (var i:int=3; i > 0; i--) {
					items=beLoadItems[i];
					if (items && items.length > 0) {
						item=items.shift();
						break;
					}
				}
				if (item) {
					loadingItems.push(item);
					item.load();
				}
			}
		}
	}
}

