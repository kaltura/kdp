This html-template contains 3 important files that you should know of:

1 - index.template.html - where you configure your flashvars. this is the place to point to your partners details, and your partner content. 
2 - config.xml - this file is a local configuration file for the ui and functionality of the KDP. normally this config file will be loaded from a kaltura service, this file bypasses the loaded file so you could edit the uiConf easily. If you change this file, make sure that there is a copy of your changes in the bin-debug folder.
3 - playlistConfig.xml - this is a configuration of a typical playlist. if you want to test a playlist - copy the content of this text file to the config.xml file, and change the dimanssions of the player in the html-template file.
 
for more uiConf documentation see uiConf.docx in 'docs' folder in the kdp3Lib project  

  
 