This plugin makes sounds in response to KDP notifications it receives.
It is a demoplugin focusing on showing how to build a non visual KDP plugin.
The project holds a KDP swf in a debug mode under html-template folder, meaning you should be 
able to test your plugin without having to compile the KDP project.
The config.xml file found under html-template folder is a local layout configuration. The demo 
plugin appears in the non-visual plugins area and is declared with width and height of 0, and 
not included in the layout. the path attribute lists the path to the plugin swf file, because
it is not located in the default plugins folder (the swf is compiled into the bin-debug folder).  
