package com.hope.util
{
	/**
	 * 颜色操作
	 * 摘自lost in actionscript
	 * @author 123
	 */
	public class ColorUtil
	{

		public static function rgbaToHex(red : int, green : int, blue : int, alpha : int) : uint {
			return alpha << 24 ^ red << 16 ^ green << 8 ^ blue;
		}

		public static function rgbToHex(red : int, green : int, blue : int) : uint {
			return red << 16 ^ green << 8 ^ blue;
		}

		public static function hexToRgba(color : uint) : Object {
			var result : Object = {};

			result.alpha = (color >> 24) & 0xFF;
			result.red = (color >> 16) & 0xFF;
			result.green = (color >> 8) & 0xFF;
			result.blue = color & 0xFF;

			return result;
		}

		public static function hexToRgb(color : uint) : Object {
			var result : Object = {};

			result.red = (color >> 16) & 0xFF;
			result.green = (color >> 8) & 0xFF;
			result.blue = color & 0xFF;

			return result;
		}

		public static function hexToFloat3(color : uint) : Array {
			var result : Array = [];

			result[0] = (color >> 16) & 0xFF;
			result[1] = (color >> 8) & 0xFF;
			result[2] = color & 0xFF;

			return result;
		}

		public static function interpolateColorsRgb(color1 : uint, color2 : uint, amount : Number) : uint {
			var color1Rgba : Object = hexToRgb(color1);
			var color2Rgba : Object = hexToRgb(color2);

			var resultRgb : Object = new Object();

			resultRgb.red = color1Rgba.red * (1 - amount) + color2Rgba.red * amount;
			resultRgb.green = color1Rgba.green * (1 - amount) + color2Rgba.green * amount;
			resultRgb.blue = color1Rgba.blue * (1 - amount) + color2Rgba.blue * amount;

			return rgbToHex(resultRgb.red, resultRgb.green, resultRgb.blue);
		}

		public static function interpolateColorsRgba(color1 : uint, color2 : uint, amount : Number) : uint {
			var color1Rgba : Object = hexToRgba(color1);
			var color2Rgba : Object = hexToRgba(color2);

			var resultRgb : Object = new Object();

			resultRgb.red = color1Rgba.red * (1 - amount) + color2Rgba.red * amount;
			resultRgb.green = color1Rgba.green * (1 - amount) + color2Rgba.green * amount;
			resultRgb.blue = color1Rgba.blue * (1 - amount) + color2Rgba.blue * amount;
			resultRgb.alpha = 255;

			return rgbaToHex(resultRgb.red, resultRgb.green, resultRgb.blue, resultRgb.alpha);
		}
	}
}

