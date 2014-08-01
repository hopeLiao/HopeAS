﻿/*** PerformanceUnitTest by Grant Skinner. Feb 2, 2010* Visit www.gskinner.com/blog for documentation, updates and more free code.*** Copyright (c) 2010 Grant Skinner** Permission is hereby granted, free of charge, to any person* obtaining a copy of this software and associated documentation* files (the "Software"), to deal in the Software without* restriction, including without limitation the rights to use,* copy, modify, merge, publish, distribute, sublicense, and/or sell* copies of the Software, and to permit persons to whom the* Software is furnished to do so, subject to the following* conditions:** The above copyright notice and this permission notice shall be* included in all copies or substantial portions of the Software.** THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR* OTHER DEALINGS IN THE SOFTWARE.**/package com.hope.debug.performance {	/**	* PerformanceUnitTest provides a simple interface for running unit tests	* against PerformanceTest. Useful for integrating performance tests into a TDD	* workflow.	**/	public class PerformanceUnitTest {		// static interface:		/**		* Returns true if the specified test runs without errors within the target time specified in ms.		**/		public static function checkTestTime(test:AbstractTest, targetTime:uint):Boolean {			PerformanceTest.getInstance().runTest(test);			return test.error == null && test.time <= targetTime;		}		/**		* Returns true if the specified test suite runs without errors within the target time specified in ms.		**/		public static function checkTestSuiteTime(testSuite:TestSuite, targetTime:uint):Boolean {			PerformanceTest.getInstance().runTestSuite(testSuite);			return testSuite.time != -1 && testSuite.time <= targetTime;		}		/**		* Returns true if the specified method test runs without errors and has a memory value less than or equal to		* the target memory specified. See MethodTest.memory for additional information.		**/		public static function checkMethodTestMemory(methodTest:MethodTest, targetMemory:uint):Boolean {			PerformanceTest.getInstance().runTest(methodTest);			return methodTest.error == null && methodTest.memory <= targetMemory;		}		/**		* Returns true if the specified method test runs without errors and has a retainedMemory value less than or equal to		* the target memory specified. See MethodTestretainedMemory for additional information.		**/		public static function checkMethodTestRetainedMemory(methodTest:MethodTest, targetMemory:uint):Boolean {			PerformanceTest.getInstance().runTest(methodTest);			return methodTest.error == null && methodTest.retainedMemory <= targetMemory;		}		// constructor:		/** PerformanceCheck should not be instantiated. **/		public function PerformanceUnitTest() { throw(new Error("PerformanceUnitTest should not be instantiated")); }	}}