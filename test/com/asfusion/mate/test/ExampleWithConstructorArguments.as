package com.asfusion.mate.test
{
	
	public class ExampleWithConstructorArguments
	{
		public function ExampleWithConstructorArguments(a:*, b:*, c:*)
		{
			_constructorArguments = [ a, b, c ];
		}
		
		private var _constructorArguments:Array;
		
		public function get constructorArguments():Array
		{
			return _constructorArguments;
		}
	}
}
