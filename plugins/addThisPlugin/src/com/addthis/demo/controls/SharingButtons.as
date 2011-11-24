package com.addthis.demo.controls {
	
    import flash.display.Bitmap;
    import flash.display.Sprite;
    
    
    public class SharingButtons extends Sprite {
        
        public var facebookButton:RichShape;
        public var twitterButton:RichShape;
        public var emailButton:RichShape;
        public var igoogleButton:RichShape;
        public var moreButton:RichShape;
        
        [Embed(source='/../assets/images/facebook_16.png')]
        public static var facebookAsset:Class;
        public static var facebookIcon:Bitmap = new facebookAsset();
        
        [Embed(source='/../assets/images/twitter_16.png')]
        public static var twitterAsset:Class;
        public static var twitterIcon:Bitmap = new twitterAsset();
        
        [Embed(source='/../assets/images/email_16.png')]
        public static var emailAsset:Class;
        public static var emailIcon:Bitmap = new emailAsset();
        
        [Embed(source='/../assets/images/google_16.png')]
        public static var igoogleAsset:Class;
        public static var igoogleIcon:Bitmap = new igoogleAsset();
        
        [Embed(source='/../assets/images/16x16.png')]
        public static var moreAsset:Class;
        public static var moreIcon:Bitmap = new moreAsset();
        
        private static var done_flag:Boolean = false;
        
        public function SharingButtons() {
            super();
            facebookButton = new RichShape(true);
            twitterButton  = new RichShape(true);
            igoogleButton   = new RichShape(true);
            emailButton    = new RichShape(true);
            moreButton     = new RichShape(true);
        }
        
        public function render( evt:*=null ):void {
            
            // do only once
            if (!done_flag) {       
            	
	            facebookButton.drawRoundedRectangle(85, button_height, 4, button_border_color, button_start_color, button_end_color);
	            facebookButton.setLabel({color:button_label_color, profile:'Facebook', alpha:1, size:12});
	            facebookButton.addChild(facebookIcon);
	            facebookIcon.x += 5;
	            facebookButton.label.x = facebookIcon.x + facebookIcon.width + 2;
	            
	            var center:Number = facebookIcon.y = facebookButton.height/2 - facebookIcon.height/2
	            
	            twitterButton.drawRoundedRectangle(70, button_height, 4, button_border_color, button_start_color, button_end_color);
	            twitterButton.setLabel({color:button_label_color, profile:'Twitter', alpha:1, size:12});
	            twitterButton.addChild(twitterIcon);
	            twitterIcon.x += 5;
	            twitterIcon.y = center;
	            twitterButton.label.x = twitterIcon.x + twitterIcon.width + 2;
	            
	            igoogleButton.drawRoundedRectangle(70, button_height, 4, button_border_color, button_start_color, button_end_color);
	            igoogleButton.setLabel({color:button_label_color, profile:'iGoogle', alpha:1, size:12});
	            igoogleButton.addChild(igoogleIcon)
	            igoogleIcon.x += 5;
	            igoogleIcon.y = center;
	            igoogleButton.label.x = igoogleIcon.x + igoogleIcon.width + 2;
	            
	            emailButton.drawRoundedRectangle(60, button_height, 4, button_border_color, button_start_color, button_end_color);
	            emailButton.setLabel({color:button_label_color, profile:'Email', alpha:1, size:12});
	            emailButton.addChild(emailIcon);            
	            emailIcon.x += 5;
	            emailIcon.y = center;
	            emailButton.label.x = emailIcon.x + emailIcon.width + 2;
	                        
	            moreButton.drawRoundedRectangle(60, button_height, 4, button_border_color, button_start_color, button_end_color);
	            moreButton.setLabel({color:button_label_color, profile:'More', alpha:1, size:12});
            	moreButton.addChild(moreIcon);
            	moreIcon.x += 5;
            	moreIcon.y = center;
            	moreButton.label.x = moreIcon.x + moreIcon.width + 2;
	            
            	for each (var btn:RichShape in [ facebookButton, twitterButton, igoogleButton, emailButton, moreButton ]) {
                	addChild(btn);
            	}
            	// done only once
            	done_flag = true;

            }
            trace('twitters width:', twitterButton.width);
            // center buttons
            var padding_total:uint = 4;
            var share_button_padding:uint = 5;
           
            // X
            twitterButton.x = facebookButton.x + facebookButton.width + share_button_padding;
            igoogleButton.x = twitterButton.x + twitterButton.width + share_button_padding; 
            emailButton.x = igoogleButton.x + igoogleButton.width + share_button_padding; 
            moreButton.x = emailButton.x + emailButton.width + share_button_padding;
           
        }
        
        protected var share_bar_height:uint    = 35;
        protected var shareBarBgColor:uint     = 0xD6D6D6;
        protected var button_border_color:uint = 0x5d5d5d;
        protected var button_start_color:uint  = 0x999999;
        protected var button_end_color:uint    = 0x303030;
        protected var button_label_color:uint  = 0xFFFFFF;
    	protected var button_height:Number = 26;
    }
}