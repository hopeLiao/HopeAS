package com.hope.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	//import flash.utils.getTimer;

	/**
	 * Usage is as follows:

		var myMoz:Mosaic = new Mosaic(yourDisplayObj:DisplayObject, pixelSize:uint, useCache:Boolean);
		addChild(myMoz);

		or

		var myMoz:Mosaic = new Mosaic(yourDisplayObj);
		myMoz.pixelSize = 10;
		myMoz.render();
	 *
		 * 摘自mosaic
	 */
	public class Mosaic extends Sprite{

		public var pixelSize:uint;
		public var useCache:Boolean;
		private var bmd:BitmapData;
		private var cache:Object = {};

		//testing vars
		//var totalTime:uint = 0;

		/********************

		 Mosaic class - Julian Kussman

		 constructor:
		 var myMosaic:Mosaic = new Mosaic(DisplayObject, [pixelSize = 0], [useCache = true]);

		 public vars:
		 pixelSize:uint //sets size of mosaic pixels
		 useCache:Boolean //to use a cache or not

		 public methods:
		 render():void //renders the mosaic, called automatically after instantiation if pixelSize is > 0.

		 The render algorithm draws one extra row and column of pixels to keep the final product the same size as the copied original image.

		 The cache will store all rendered Sprites for each size and if you try to render a cached size it will not redraw it and instead display it from the cache.

		 ********************/

		public function Mosaic(srcDispObj:DisplayObject, _pixelSize:uint = 0, _useCache:Boolean = true){

			bmd = new BitmapData(srcDispObj.width, srcDispObj.height);
			bmd.draw(srcDispObj);

			this.pixelSize = _pixelSize
			this.useCache = _useCache;

			var masker:Shape = makeRect(bmd.width, bmd.height, 0xCCCCCC);
			addChild(masker);
			this.mask = masker;

			if (pixelSize != 0){
				render();
			}else{
				cache[pixelSize] = new Bitmap(bmd);
				addChild(cache[pixelSize]);
			}

		}

		public function render():void{

			//var startTime:uint = getTimer();

			if (useCache && cache[pixelSize]){
				//trace("cached exists");
				for (var cachedSprite:Object in cache){
					if (this.contains(cache[cachedSprite])){
						removeChild(cache[cachedSprite]);
					}
				}
				addChild(cache[pixelSize]);

			} else {
				//trace("no cache");

				var renderContainer:Sprite = new Sprite();

				var ySteps:uint = Math.round(bmd.height / pixelSize);
				var xSteps:uint = Math.round(bmd.width / pixelSize);

				for (var i:uint = 0; i <= ySteps; i++){
					var colorY:uint;
					if (i == ySteps){
						colorY = pixelSize * (i - 1);
					}else{
						colorY = pixelSize * (i);
					}

					for (var j:uint = 0; j <= xSteps; j++){

						var colorX:uint;

						if (j == xSteps){
							colorX = pixelSize * (j - 1);
						}else{
							colorX = pixelSize * (j);
						}

						var color:uint = bmd.getPixel(colorX , colorY);
						var pixel:Shape = makePixel(pixelSize, color);
						pixel.x = (j * pixelSize);
						pixel.y = (i * pixelSize);
						renderContainer.addChild(pixel);

					}
				}

				cache[pixelSize] = renderContainer;

				for (var cachedSprite2:Object in cache){
					if (this.contains(cache[cachedSprite2])){
						removeChild(cache[cachedSprite2]);
					}
				}
				addChild(renderContainer);

			}


			//var rendTime:uint = getTimer() - startTime;
			//totalTime += rendTime;
			//trace("pixel size:", pixelSize, "render time:", rendTime, "total time:", totalTime);
		}

		private function makePixel(size:uint, color:uint):Shape{

			var pixel:Shape = makeRect(size, size, color);

			return pixel;

		}

		private function makeRect(w:uint, h:uint, color:uint):Shape{

			var rect:Shape = new Shape();
			rect.graphics.beginFill(color);
			rect.graphics.drawRect(0, 0, w, h);
			rect.graphics.endFill();

			return rect;

		}
	}
}
