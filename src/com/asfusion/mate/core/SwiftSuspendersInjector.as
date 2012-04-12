package com.asfusion.mate.core
{
	
	import flash.system.ApplicationDomain;
	
	import org.swiftsuspenders.Injector;
	
	public class SwiftSuspendersInjector implements IInjector
	{
		private var _injector:Injector;
		
		public function SwiftSuspendersInjector(injector:Injector = null)
		{
			_injector = injector || new Injector();
		}
		
		public function mapValue(whenAskedFor:Class, useValue:Object, named:String = ""):*
		{
			return _injector.map(whenAskedFor, named).toValue(useValue);
		}
		
		public function mapClass(whenAskedFor:Class, instantiateClass:Class, named:String = ""):*
		{
			return _injector.map(whenAskedFor, named).toType(instantiateClass);
		}
		
		public function mapSingleton(whenAskedFor:Class, named:String = ""):*
		{
			return _injector.map(whenAskedFor, named).toType(whenAskedFor).asSingleton();
		}
		
		public function mapSingletonOf(whenAskedFor:Class, useSingletonOf:Class, named:String = ""):*
		{
			return _injector.map(whenAskedFor, named).toType(useSingletonOf).asSingleton();
		}
		
		public function injectInto(target:Object):void
		{
			return _injector.injectInto(target);
		}
		
		public function instantiate(clazz:Class):*
		{
			return _injector.getInstance(clazz);
		}
		
		public function getInstance(clazz:Class, named:String = ""):*
		{
			return _injector.getInstance(clazz, named);
		}
		
		public function createChildInjector(applicationDomain:ApplicationDomain = null):IInjector
		{
			return new SwiftSuspendersInjector(_injector.createChildInjector(applicationDomain));
		}
		
		public function unmap(clazz:Class, named:String = ""):void
		{
			_injector.unmap(clazz, named);
		}
		
		public function hasMapping(clazz:Class, named:String = ""):Boolean
		{
			return _injector.satisfies(clazz, named);
		}
		
		public function hasMappingDirectly(clazz:Class, named:String = ""):Boolean
		{
			return _injector.satisfiesDirectly(clazz, named);
		}
		
		public function get applicationDomain():ApplicationDomain
		{
			return _injector.applicationDomain;
		}
		
		public function set applicationDomain(value:ApplicationDomain):void
		{
			_injector.applicationDomain = value;
		}
	}
}
