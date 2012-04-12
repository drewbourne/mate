package com.asfusion.mate.core
{
	import flash.system.ApplicationDomain;
	
	import org.swiftsuspenders.DescribeTypeJSONReflector;
	import org.swiftsuspenders.Reflector;
	
	public class SwiftSuspendersReflector implements IReflector
	{
		private var _reflector:Reflector;
		
		public function SwiftSuspendersReflector()
		{
			_reflector = new DescribeTypeJSONReflector();
		}
		
		public function typeImplements(type:Class, superclass:Class, applicationDomain:ApplicationDomain = null):Boolean
		{
			return _reflector.typeImplements(type, superclass);
		}
		
		public function getClass(value:*, applicationDomain:ApplicationDomain = null):Class
		{
			return _reflector.getClass(value);
		}
		
		public function getFQCN(value:*, replaceColons:Boolean = false):String
		{
			return _reflector.getFQCN(value, replaceColons);
		}
	}
}
