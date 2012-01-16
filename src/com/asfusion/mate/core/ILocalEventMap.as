package com.asfusion.mate.core
{
	import flash.events.IEventDispatcher;
	
	public interface ILocalEventMap
	{
		function get dispatcher():IEventDispatcher;
		function set dispatcher(value:IEventDispatcher):void;
	}
}
