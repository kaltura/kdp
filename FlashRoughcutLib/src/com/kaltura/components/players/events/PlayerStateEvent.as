package com.kaltura.components.players.events
{
	import flash.events.Event;

	public class PlayerStateEvent extends Event
	{
		static public const CHANGE_PLAYER_STATE:String = "changePlayerState";

		/**
		 * the new state the player changed to.
		 * @see com.kaltura.components.players.states.VideoStates
		 */
		public var newState:uint;

		public function PlayerStateEvent(type:String, new_state:uint, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			newState = new_state;
		}

		override public function clone():Event
		{
			return new PlayerStateEvent (type, newState, bubbles, cancelable);
		}
	}
}