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
package com.asfusion.mate.responses
{
	import com.asfusion.mate.core.*;
	import com.asfusion.mate.events.InternalResponseEvent;
	import com.asfusion.mate.events.Dispatcher;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * The event that gets dispatched when a response of the type
	 * "response" is dispatched.
	 */
	[Event(name="response", type="com.asfusion.mate.events.ResponseEvent")]
	/**
	 * The event that gets dispatched when a response of the type
	 * "result" is dispatched.
	 */
	[Event(name="result", type="com.asfusion.mate.events.ResponseEvent")]
	/**
	 * The event that gets dispatched when a response of the type
	 * "fault" is dispatched.
	 */
	[Event(name="fault", type="com.asfusion.mate.events.ResponseEvent")]
	
	/**
	 * The <code>ServiceResponseHandler</code> tag can be used to receive a
	 * response from an event that was dispatched from a <code>Dispatcher</code> instance.
	 * <p>After dispatching an event using the <code>Dispatcher</code> tag,
	 * the view that dispatched this event can receive a response.</p>
	 * <p>Those responses are sent from the <code>EventMap</code> within the
	 * <code>EventHandlers</code> that was listening for the event dispatched by the <code>Dispatcher</code>.</p>
	 * <p>It's important to note that this response will be received only by the view instance that dispatched the event,
	 * even if there are other instances of the same view or other views dispatch the same event.</p>
	 * <p>It is simple way to receive a response generated by a service call. It contains result and fault handlers
	 * you can use as you would when receiving a normal service (ie: RemoteObject) result or fault.
	 * It also contains a response handler that can be used for any situation.</p>
	 *
	 * @example
	 *
	 * <listing version="3.0">
	 * &lt;mate:Dispatcher&gt;
	 *      &lt;mate:ServiceResponseHandler
	 *               result="trace(event.result)"
	 *               fault="trace(event.fault.faultString)"
	 *               response="trace(event.data)" /&gt;
	 * &lt;/mate:Dispatcher&gt;
	 * </listing>
	 *
	 */
	
	public class ServiceResponseHandler implements IResponseHandler, IEventDispatcher
	{
		/**
		 * A reference to the functions generated by the container when
		 * inline functions are used in the <code>result</code>, <code>fault</code>,
		 * or <code>response</code> events attibute of the tag.
		 */
		protected var functions:Dictionary;
		/**
		 * <code>Dispatcher</code> that contains this tag
		 */
		protected var owner:Dispatcher
		
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Constructor
		-------------------------------------------------------------------------------------------------------------*/
		/**
		 * Constructor
		 */
		public function ServiceResponseHandler()
		{
			functions = new Dictionary();
		}
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Implementation of IResponseListener interface
		-------------------------------------------------------------------------------------------------------------*/
		
		/*-.........................................addReponder..........................................*/
		/**
		 * @inheritDoc
		 */
		public function addReponderListener(type:String, dispatcher:IEventDispatcher, owner:Dispatcher):void
		{
			this.owner = owner;
			dispatcher.addEventListener(type, response, false, 0, true);
		}
		
		/*-.........................................removeResponder..........................................*/
		/**
		 * @inheritDoc
		 */
		public function removeResponderListener(type:String, dispatcher:IEventDispatcher):void
		{
			dispatcher.removeEventListener(type, response);
		}
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                         Implementation of IEventDispatcher interface
		-------------------------------------------------------------------------------------------------------------*/
		/*-.........................................hasEventListener..........................................*/
		/**
		 * Checks whether the EventDispatcher object has any listeners registered for a specific type of event.
		 * This allows you to determine where an EventDispatcher object has altered handling of an event type
		 * in the event flow hierarchy. To determine whether a specific event type will actually trigger an
		 * event listener, use <code>IEventDispatcher.willTrigger()</code>.
		 *
		 * <p>The difference between <code>hasEventListener()</code> and <code>willTrigger()</code> is that <code>hasEventListener()</code>
		 * examines only the object to which it belongs, whereas <code>willTrigger()</code> examines the entire event
		 * flow for the event specified by the type parameter.</p>
		 */
		public function hasEventListener(type:String):Boolean
		{
			return (functions[type] != null);
		}
		
		/*-.........................................willTrigger..........................................*/
		/**
		 * Checks whether an event listener is registered with this EventDispatcher object
		 * or any of its ancestors for the specified event type. This method returns true
		 * if an event listener is triggered during any phase of the event flow when an
		 * event of the specified type is dispatched to this EventDispatcher object or any of its descendants.
		 *
		 * <p>The difference between <code>hasEventListener()</code> and <code>willTrigger()</code> is that <code>hasEventListener()</code>
		 * examines only the object to which it belongs, whereas <code>willTrigger()</code> examines the entire event
		 * flow for the event specified by the type parameter.</p>
		 */
		public function willTrigger(type:String):Boolean
		{
			return (functions[type] != null);
		}
		
		/*-.........................................addEventListener..........................................*/
		/*
		*	Usually this method is call by Flex Builder when a user put some inline code in the "response" tag argument
		*/
		/**
		 * Registers an event listener object with an EventDispatcher object so that the listener receives notification of an event.
		 * You can register event listeners on all nodes in the display list for a specific type of event, phase, and priority.
		 */
		public function addEventListener(eventType:String, listener:Function, useCapture:Boolean = false, priority:int = 0.0, useWeakReference:Boolean =
			false):void
		{
			functions[eventType] = listener;
		}
		
		/*-.........................................removeEventListener..........................................*/
		/**
		 * Removes a listener from the EventDispatcher object. If there is no matching listener registered with
		 * the EventDispatcher object, a call to this method has no effect.
		 */
		public function removeEventListener(eventType:String, listener:Function, useCapture:Boolean = false):void
		{
			functions[eventType] = null;
		}
		
		/*-.........................................dispatchEvent..........................................*/
		/**
		 * Dispatches an event into the event flow. The event target is the EventDispatcher object upon which dispatchEvent() is called.
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			var dispached:Boolean;
			if (functions[event.type] != null)
			{
				functions[event.type](event);
				dispached = true;
			}
			
			if (dispached)
			{
				owner.removeReponders(event);
			}
			return dispached;
		}
		
		/*-----------------------------------------------------------------------------------------------------------
		*                                          Protected Methods
		-------------------------------------------------------------------------------------------------------------*/
		/*-.........................................response..........................................*/
		/**
		 * This function is executed when a response is received.
		 * It gets an internalEvent that contains the real event that was dispatched
		 */
		protected function response(internalEvent:InternalResponseEvent):void
		{
			dispatchEvent(internalEvent.event);
			if (functions[internalEvent.event.type] != null)
				internalEvent.stopImmediatePropagation();
		}
	}
}
