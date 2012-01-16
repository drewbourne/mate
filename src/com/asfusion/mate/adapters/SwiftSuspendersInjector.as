package com.asfusion.mate.adapters
{
	import com.asfusion.mate.core.IInjector;
	
	import flash.system.ApplicationDomain;
	
	import org.swiftsuspenders.Injector;
	
	/**
	 * SwiftSuspender <code>IInjector</code> adpater - See: <a href="http://github.com/tschneidereit/SwiftSuspenders">SwiftSuspenders</a>
	 *
	 * Stolen from RobotLegs v1.
	 */
	public class SwiftSuspendersInjector extends Injector implements IInjector
	{
		public function SwiftSuspendersInjector()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		public function createChild(applicationDomain:ApplicationDomain = null):IInjector
		{
			var injector:SwiftSuspendersInjector = new SwiftSuspendersInjector();
			injector.setApplicationDomain(applicationDomain);
			injector.setParentInjector(this);
			return injector;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get applicationDomain():ApplicationDomain
		{
			return getApplicationDomain();
		}
		
		/**
		 * @inheritDoc
		 */
		public function set applicationDomain(value:ApplicationDomain):void
		{
			setApplicationDomain(value);
		}
	}
}
