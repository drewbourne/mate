package com.asfusion.mate.core
{
	import flash.system.ApplicationDomain;
	
	/**
	 * The Mate Reflector contract.
	 *
	 * Stolen from RobotLegs v1.
	 */
	public interface IReflector
	{
		/**
		 * Does this class or class name implement this superclass or interface?
		 *
		 * @param classOrClassName
		 * @param superclass
		 * @param applicationDomain
		 * @return Boolean
		 */
		function typeImplements(type:Class, superclass:Class, applicationDomain:ApplicationDomain = null):Boolean;
		
		/**
		 * Get the class of this instance
		 *
		 * @param value The instance
		 * @param applicationDomain
		 * @return Class
		 */
		function getClass(value:*, applicationDomain:ApplicationDomain = null):Class
		
		/**
		 * Get the Fully Qualified Class Name of this instance, class name, or class
		 *
		 * @param value The instance, class name, or class
		 * @param replaceColons
		 * @return The Fully Qualified Class Name
		 */
		function getFQCN(value:*, replaceColons:Boolean = false):String;
	}
}
