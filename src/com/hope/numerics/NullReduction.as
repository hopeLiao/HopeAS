////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//	Portions Copyright 2009 Tom Wu. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.hope.numerics
{
	import flash.errors.IllegalOperationError;

	import mx.resources.ResourceManager;

	internal final class NullReduction implements IReductionAlgorithm
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function NullReduction()
		{
			super();
		}

		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------

		public function convert(value:BigInteger):BigInteger
		{
			return value;
		}

		public function multiply(value1:BigInteger, value2:BigInteger, result:BigInteger):void
		{
			value1.mulTo(value2, result);
		}

		public function reduce(value:BigInteger):void
		{
			throw new IllegalOperationError(ResourceManager.getInstance().getString("flameCore", "argNotSupported"));
		}

		public function revert(value:BigInteger):BigInteger
		{
			return value;
		}

		public function square(value:BigInteger, result:BigInteger):void
		{
			value.squareTo(result);
		}
	}
}

