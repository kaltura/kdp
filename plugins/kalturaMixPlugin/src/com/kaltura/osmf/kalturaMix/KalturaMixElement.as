package com.kaltura.osmf.kalturaMix
{
	import com.kaltura.components.players.eplayer.Eplayer;
	
	import org.osmf.media.LoadableElementBase;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.traits.DisplayObjectTrait;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.LoaderBase;
	import org.osmf.traits.MediaTraitBase;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.TimeTrait;
	/**
	 * Class KalturaMixElement extends the OSMF with a unique element which is constructed from snippets of different videos. 
	 * It has all the traits as a regular MediaElement
	 * @author Hila
	 * 
	 */	
	public class KalturaMixElement extends LoadableElementBase
	{
		public var disableUrlHashing:Boolean = false;
		/**
		 * Constructor 
		 * @param loader
		 * @param resource
		 * 
		 */		
		public function KalturaMixElement(loader:LoaderBase, resource:MediaResourceBase=null)
		{
			super(resource, loader);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createLoadTrait(resource:MediaResourceBase, loader:LoaderBase):LoadTrait
		{
			return new KalturaMixLoadTrait(loader, resource);
		}
       	
		/**
		 * @inheritDoc
		 */
		override protected function processReadyState():void
		{
			
			//Remove all exsiting traits before loading; required for restoring media after sequence plugins have played.
			//Has no backward-compatibility issues
			while (traitTypes.length != 1)
			{
				if ( traitTypes[1] != MediaTraitType.LOAD )
				{
					removeTrait( traitTypes[1]);
				}
			}
			//var loadTrait:LoadTrait = getTrait(MediaTraitType.LOAD) as LoadTrait;
			var kalturaMixsprite:KalturaMixSprite = new KalturaMixSprite(this, 640, 480,disableUrlHashing);
			var eplayer:Eplayer = kalturaMixsprite.eplayer;
	    	addTrait(MediaTraitType.AUDIO, new KalturaMixAudioTrait(eplayer));
	    	addTrait(MediaTraitType.BUFFER, new KalturaMixBufferTrait(eplayer));
			var timeTrait:TimeTrait = new KalturaMixTimeTrait(eplayer);
			addTrait(MediaTraitType.TIME, timeTrait);
			var displayObjectTrait:DisplayObjectTrait = new KalturaMixViewTrait(kalturaMixsprite, 640, 480);
    		addTrait(MediaTraitType.SEEK, new KalturaMixSeekTrait(timeTrait, eplayer));
			addTrait(MediaTraitType.DISPLAY_OBJECT, displayObjectTrait);
			addTrait(MediaTraitType.PLAY, new KalturaMixPlayTrait(eplayer));
			
		}
		
		public function cleanMedia () : void
		{
			
		}
		
	}
}