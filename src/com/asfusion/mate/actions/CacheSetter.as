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

Author: Collin Peters

@ignore
*/
package com.asfusion.mate.actions
{
	import com.asfusion.mate.actionLists.IScope;
	import com.asfusion.mate.core.Cache;
	import com.asfusion.mate.core.ISmartObject;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * CacheSetter Mate tag - adds an existing instance of a class to the specified Mate cache
	 *
	 * @example
	 * <listing version="3.0">
	 * 	&lt;mate:CacheSetter cacheKey="{AbstractClassName}" instance="{concreteInstance}" /&gt;
	 * </listing>
	 */
	public class CacheSetter extends AbstractAction implements IAction
	{
		//-----------------------------------------------------------------------------------------------------------
		//                                         Public Getters and Setters
		//-----------------------------------------------------------------------------------------------------------
		
		//.........................................cacheKey..........................................
		private var _cacheKey:Class;
		
		/**
		 * The key to use for the cache
		 */
		public function get cacheKey():Class
		{
			return _cacheKey;
		}
		
		public function set cacheKey(value:Class):void
		{
			_cacheKey = value;
		}
		
		//.........................................instance..........................................
		private var _instance:Object;
		
		/**
		 * The instance to set in the cache
		 */
		public function get instance():Object
		{
			return _instance;
		}
		
		public function set instance(value:Object):void
		{
			_instance = value;
		}
		
		//.........................................cache..........................................
		private var _cache:String = "inherit";
		
		/**
		 * The cache atribute is only useful when the destination is a class.
		 * This attribute defines which cache we will look up for a created object.
		*/
		public function get cache():String
		{
			return _cache;
		}
		
		[Inspectable(enumeration="local,global,inherit")]
		public function set cache(value:String):void
		{
			_cache = value;
		}
		
		//------------------------------------------------------------------------------------------------------------
		//                                          Override protected methods
		//------------------------------------------------------------------------------------------------------------
		
		//.........................................prepare..........................................
		/**
		 * @inheritDoc
		 */
		override protected function prepare(scope:IScope):void
		{
			//Get the actual concrete instance
			currentInstance
				= (instance is ISmartObject)
				? (instance as ISmartObject).getValue(scope)
				: instance;
			
			trace('CacheSetter prepare cacheKey=', cacheKey, 'cache=', cache, 'instance=', instance);
			
			if (currentInstance == null || currentInstance == undefined)
			{
				// Remove it from the cache
				currentInstance = Cache.clearCachedInstance(cacheKey, cache, scope);
			}
			else
			{
				// Add it to the cache
				Cache.addCachedInstance(cacheKey, currentInstance, cache, scope);
			}
		}
		
		//.........................................run..........................................
		/**
		 * @inheritDoc
		 */
		override protected function run(scope:IScope):void
		{
			scope.lastReturn = currentInstance;
		}
	}
}
