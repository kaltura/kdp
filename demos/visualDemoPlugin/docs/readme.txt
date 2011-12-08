This project is a demo showing how to build a visual KDP plugin.
This project holds a KDP swf in a debug mode under html-template folder, meaning you should be able to
 test your plugin without having to compile the KDP project.
The config.xml file found under html-template folder is a local layout configuration which places 
 the demoPlugin over the video area. 
The project compiles its swf into the html-template folder. Make sure the compiled .swf is copied 
 to the bin-debug folder, from where your debug file runs. 
 
The plugin demonstrates recieving the following dynamic parameters:
someVar: will change the text appears in the top left side of the plugin (there is a hard coded default value)
viewColor: this parameter is being passed to the view class and affects the color of the mask (IE 0xFF00DD)
viewAlpha: this parameter is being passed to the view class and affects the alpha (transparancy) of the mask (IE 0.5 for 50%)