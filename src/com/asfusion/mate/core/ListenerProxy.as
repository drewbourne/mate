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
	import com.asfusion.mate.events.InjectorEvent;
	import com.asfusion.mate.events.InjectorSettingsEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * The ListenerProxy is used by the injector (via MateManager)
	 * to register to the dispatcher to listen to events and dispatch
	 * a new InjectorEvent each time the rules match.
	 * By default, ListenerProxy registers to listen the
	 * FlexEvent.COMPLETE using capture in the main display list.
	 * Once a new displayObject is created, a new InjectorEvent is created
	 * and dispached. The Injector will listen to that newly created event
	 * and will run the injection.
	 */
	public class ListenerProxy
	{
		//-----------------------------------------------------------------------------------------------------------
		//                                         Protected Properties
		//------------------------------------------------------------------------------------------------------------
		
		private var dispatcherHolder:Dictionary = new Dictionary(true);
		
		/**
		 * Storage for the EventDispatcher that will be used to listen and dispatch events.
		 * This property is required in the constructor of this class.
		 */
		protected function get dispatcher():IEventDispatcher
		{
			var weakDispatcher:IEventDispatcher;
			for (var i:* in dispatcherHolder)
			{
				if (i is IEventDispatcher)
				{
					weakDispatcher = i;
				}
			}
			return weakDispatcher;
		}
		
		protected function set dispatcher(value:IEventDispatcher):void
		{
			dispatcherHolder[value] = "dispatcher";
		}
		
		/**
		 * Type used to register to events in the dispatcher object.
		 */
		protected var type:String;
		
		/**
		 * Flag indicating if ListenerProxy is already listening for events
		 */
		protected var registered:Boolean;
		
		//-----------------------------------------------------------------------------------------------------------
		//                                         Contructor
		//-----------------------------------------------------------------------------------------------------------
		public function ListenerProxy(dispatcher:IEventDispatcher)
		{
			this.dispatcher = dispatcher;
		}
		
		//.........................................addListener........................................
		/**
		 * addListener will register to listen to an event with the type that is passed as argument,
		 * using capture and priority one.
		 * If the dispatcher is a GlobalDispatcher, we also register to
		 * listen events in the popup DiplayObject tree.
		 */
		public function addListener(type:String, typeWatcher:IEventDispatcher = null):void
		{
			if (registered && (this.type == type))
				return;
			
			var weakDispatcher:IEventDispatcher = dispatcher;
			
			if (this.type != type && registered)
			{
				removeListener(this.type);
			}
			
			weakDispatcher.addEventListener(type, listenerProxyHandler, true, 1, true);
			weakDispatcher.addEventListener(type, listenerProxyHandler, false, 1, true);
			
			if (weakDispatcher is GlobalDispatcher)
			{
				GlobalDispatcher(weakDispatcher).popupDispatcher.addEventListener(type, globalListenerProxyHandler, true, 1, true);
			}
			
			this.type = type;
			registered = true;
			
			if (typeWatcher)
			{
				typeWatcher.addEventListener(InjectorSettingsEvent.TYPE_CHANGE, typeChangeHandler, false, 0, true);
			}
		}
		
		//.........................................removeListener........................................
		/**
		* Removes the listener from the dispatcher.
		*/
		public function removeListener(type:String):void
		{
			var weakDispatcher:IEventDispatcher = dispatcher;
			weakDispatcher.removeEventListener(type, listenerProxyHandler, true);
			weakDispatcher.removeEventListener(type, listenerProxyHandler, false);
			
			if (weakDispatcher is GlobalDispatcher)
			{
				GlobalDispatcher(weakDispatcher).popupDispatcher.removeEventListener(type, globalListenerProxyHandler, true);
			}
			
			registered = false;
		}
		
		
		//----------------------------------------------------------------------------------------------------------
		//                                         Event Handlers
		//------------------------------------------------------------------------------------------------------------
		//........................................listenerProxyHandler........................................
		/**
		 * Handler that will run every time an event is captured in our dispatcher.
		 * This handler will create a new InjectorEvent and will dispatch it from the dispatcher.
		 * That will make all the Injectors that are registered to listen for that class type run.
		 */
		protected function listenerProxyHandler(event:Event):void
		{
			var weakDispatcher:IEventDispatcher = dispatcher;
			if (weakDispatcher.hasEventListener(getQualifiedClassName(event.target)))
			{
				weakDispatcher.dispatchEvent(new InjectorEvent(null, event.target));
			}
			
			weakDispatcher.dispatchEvent(new InjectorEvent(InjectorEvent.INJECT_DERIVATIVES, event.target));
		}
		
		//.........................................globalListenerProxyHandler......................................
		/**
		 * Similar to the listenerProxyHandler with the difference that this handler will only run if
		 * the dispatcher is a GlobalDispatcher and the event happens in the popup display tree.
		 */
		protected function globalListenerProxyHandler(event:Event):void
		{
			var weakDispatcher:IEventDispatcher = dispatcher;
			var appDispatcher:Sprite = GlobalDispatcher(weakDispatcher).applicationDispatcher as Sprite;
			
			if (event.target is DisplayObject && appDispatcher.contains(event.target as DisplayObject))
				return;
			
			if (weakDispatcher.hasEventListener(getQualifiedClassName(event.target)))
			{
				weakDispatcher.dispatchEvent(new InjectorEvent(null, event.target));
			}
			
			weakDispatcher.dispatchEvent(new InjectorEvent(InjectorEvent.INJECT_DERIVATIVES, event.target));
		
		}
		
		//.........................................typeChangeHandler........................................
		/**
		 * Handler that will run every time the event type changes by calling the injectorSettings.
		 */
		protected function typeChangeHandler(event:InjectorSettingsEvent):void
		{
			removeListener(type);
			addListener(event.globalType);
		}
	}
}
