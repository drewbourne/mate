/*
Copyright 2008 Nahuel Foronda/AsFusion

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. Y
ou may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, s
oftware distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and limitations under the License

Author: Nahuel Foronda, Principal Architect
		nahuel at asfusion dot com

@ignore
*/
package com.asfusion.mate.core
{
	import com.asfusion.mate.events.DispatcherEvent;
	
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	public class LocalEventMap extends EventMap implements ILocalEventMap
	{
		//.........................................Contructor..........................................
		public function LocalEventMap()
		{
			super();
			
			_cache = Cache.LOCAL;
			
			injector = globalInjector.createChild();
			injector.mapValue(IInjector, injector);
		}
		
		//.........................................dispatcher..........................................
		private var _dispatcher:IEventDispatcher;
		
		/**
		 * The event dispatcher that will be used in the EventMap.
		 */
		public function get dispatcher():IEventDispatcher
		{
			return _dispatcher;
		}
		
		public function set dispatcher(value:IEventDispatcher):void
		{
			var oldValue:IEventDispatcher = _dispatcher;
			if (oldValue !== value)
			{
				if (injector.hasMapping(IEventDispatcher))
				{
					injector.unmap(IEventDispatcher);
				}
				
				_dispatcher = value;
				
				injector.mapValue(IEventDispatcher, _dispatcher);
				
				var event:DispatcherEvent = new DispatcherEvent(DispatcherEvent.CHANGE);
				event.newDispatcher = value;
				event.oldDispatcher = oldValue;
				dispatchEvent(event);
			}
		}
		
		//.........................................getDispatcher..........................................
		/**
		 * @inheritDoc
		 */
		override public function getDispatcher():IEventDispatcher
		{
			return dispatcher;
		}
	}
}
