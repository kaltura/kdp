package com.kaltura.roughcut.mediaclips.settings
{
	import com.kaltura.plugin.types.transitions.TransitionTypes;

	/**
	 *this class is used as VO to set the default behaviour of the mediaclips assets.
	 */
	//[Bindable]
	public class MediaTypesSettings
	{
		// ========================= 		SOLID :
		/**
		 * determins the default color for a solid color slide.
		 */
		public var defaultSolidColor:uint = 0;
		/**
		 *determines the default duration for a solid color slide.
		 */
		public var defaultSolidDuration:Number = 2;
		/**
		 * indicates if a solid color slide will be shown in the mediaclips.
		 */
		public var showSolidInMediaClips:Boolean = true;

		// ========================= 		SILENCE :
		/**
		 *determines the default duration for a silence clip.
		 */
		public var defaultSilenceDuration:Number = 2;
		/**
		 * indicates if a silence clip will be shown in the mediaclips.
		 */
		public var showSilenceInMediaClips:Boolean = true;

		// ========================= 		IMAGE :
		/**
		 *determines the default duration for a image clip.
		 */
		public var defaultImageDuration:Number = 2;
		// ========================= 		GENERAL DEFAULTS :
		/**
		 * a default maximum duration for static media types (solid/silence/image), in seconds.
		 */
		public var defaultMaxStaticTypesDuration:Number = 30;
		/**
		 * a default minimum duration for static media types (solid/silence/image), in milliseconds.
		 */
		public var defaultMinStaticTypesDuration:Number = 250;
		/**
		 * a default minimum duration for streaming media types (video/audio), in milliseconds.
		 */
		public var defaultMinStreamingTypesDuration:Number = 250;
		// ========================= 		TRANSITIONS :
		/**
		 *indicates the default transition when adding new clips.
		 */
		public var defaultTransitionId:String = TransitionTypes.NONE;
		/**
		 *determines the default duration for a transition (this is the max duration, if the clip is shorter the duration will be shorter),
		 *for use in a cvf based application.
		 */
		public var defaultTransitionDuration:Number = 2;
		/**
		 * determins the default transition behaiour,
		 * when true, cross is enabled - an overlapping transition when the next video plays during the transition,
		 * when false - the next video will only play after finishing the transition.
		 */
		public var defaultTransitionCross:Boolean = false;
		/**
		 * indicates if after loading a roughcut we should strip it's transitions or not.
		 */
		public var transitionsClearRoughcut:Boolean = false;
	}
}