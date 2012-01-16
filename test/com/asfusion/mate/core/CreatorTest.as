package com.asfusion.mate.core
{
	import com.asfusion.mate.actionLists.IScope;
	import com.asfusion.mate.actionLists.Scope;
	import com.asfusion.mate.adapters.SwiftSuspendersInjector;
	import com.asfusion.mate.events.InjectorEvent;
	import com.asfusion.mate.test.ExampleNoInjections;
	import com.asfusion.mate.test.ExampleWithConstructorArguments;
	import com.asfusion.mate.test.ExampleWithInjections;
	import com.asfusion.mate.utils.debug.IMateLogger;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import org.flexunit.assertThat;
	import org.flexunit.events.rule.EventRule;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.isNull;
	import org.hamcrest.object.isTrue;
	
	public class CreatorTest
	{
		public var creator:Creator;
		public var dispatcher:IEventDispatcher;
		public var eventMap:IEventMap;
		public var event:Event;
		public var logger:IMateLogger;
		public var injector:IInjector;
		public var globalInjector:IInjector;
		public var scope:IScope;
		
		[Rule]
		public var events:EventRule = new EventRule();
		
		[Before]
		public function setup():void
		{
			dispatcher = new EventDispatcher();
			eventMap = new EventMap();
			injector = eventMap.getInjector();
			event = new Event(Event.COMPLETE);
			scope = new Scope(event, true, eventMap);
			logger = scope.getLogger();
		}
		
		private function withCreatorFor(generator:Class):void
		{
			creator = new Creator(generator, dispatcher, injector, logger);
		}
		
		[Test]
		public function create_without_generator_should_return_null():void
		{
			withCreatorFor(null);
			
			var example:* = creator.create(scope);
			
			assertThat(example, isNull());
		}
		
		[Test]
		public function create_should_return_an_instance_of_generatorClass():void
		{
			withCreatorFor(ExampleNoInjections);
			
			var example:ExampleNoInjections = creator.create(scope) as ExampleNoInjections;
			
			assertThat(example, instanceOf(ExampleNoInjections));
		}
		
		[Test]
		public function create_with_constructorArguments_should_pass_them_to_generatorClass_constructor():void
		{
			withCreatorFor(ExampleWithConstructorArguments);
			
			var example:ExampleWithConstructorArguments = creator.create(scope, false, [ 1, 2, 3 ]) as ExampleWithConstructorArguments;
			
			assertThat(example, instanceOf(ExampleWithConstructorArguments));
			assertThat(example.constructorArguments, array(1, 2, 3));
		}
		
		[Test]
		public function create_with_injections_should_by_supplied():void
		{
			withCreatorFor(ExampleWithInjections);
			
			injector.mapValue(Event, event);
			
			var example:ExampleWithInjections = creator.create(scope, false, null) as ExampleWithInjections;
			
			assertThat(example, instanceOf(ExampleWithInjections));
			assertThat(example.event, equalTo(event));
		}
		
		[Test]
		public function create_should_cache_instance_in_injector():void
		{
			withCreatorFor(ExampleNoInjections);
			
			creator.create(scope, false);
			
			assertThat(injector.hasMapping(ExampleNoInjections), isTrue());
		}
		
		[Test]
		public function create_should_return_previously_cached_instance_from_injector():void
		{
			withCreatorFor(ExampleNoInjections);
			
			var example1:ExampleNoInjections = creator.create(scope, false) as ExampleNoInjections;
			var example2:ExampleNoInjections = creator.create(scope, false) as ExampleNoInjections;
			
			assertThat(example1, equalTo(example2));
		}
		
		[Test]
		public function create_with_notify_should_dispatch_injector_event_for_generatorClass():void
		{
			withCreatorFor(ExampleNoInjections);
			
			events.from(dispatcher).hasType(getQualifiedClassName(ExampleNoInjections)).once();
			
			creator.create(scope, true);
		}
		
		[Test]
		public function create_with_notify_should_dispatch_injector_event_for_injectDerivatives():void
		{
			withCreatorFor(ExampleNoInjections);
			
			events.from(dispatcher).hasType(InjectorEvent.INJECT_DERIVATIVES).once();
			
			creator.create(scope, true);
		}
		
		[Test]
		public function create_without_notify_should_not_dispatch_events():void
		{
			withCreatorFor(ExampleNoInjections);
			
			events.from(dispatcher).hasType(getQualifiedClassName(ExampleNoInjections)).never();
			events.from(dispatcher).hasType(InjectorEvent.INJECT_DERIVATIVES).never();
			
			creator.create(scope, false);
		}
	}
}
