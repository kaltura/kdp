As we designed it, the omniture plugin has a basic video integration and some dynamic abilities. 
Its dynamic events, events that are not part of the ‘out of the box event’, can be one of the
 following events:

OPEN_FULL_SCREEN_EVENT
CLOSE_FULL_SCREEN_EVENT
PLAYER_PLAY_END_EVENT
VIDEO_VIEW_EVENT (first play of video)
SAVE_EVENT (doDownload)
SHARE_EVENT (doGigya)
MEDIA_READY_EVENT
SEEK_EVENT
REPLAY_EVENT (only if it gets this notification – this is not part of the KDP normal behavior) 

Each of these events can get dynamic omniture custom event, with custom eVars and custom props.
 I created a mechanism that parses dynamic attributes that are written in the UiConf and pushes
 them to the event. Hers a demo of the UiConf syntax and the output call: 
//this part of omniture UiConf node will deal with the save event 
saveEvent="event22" 
saveEventEvar1="eVar18" saveEventEvar1Value="{mediaProxy.entry.name}"
saveEventEvar2="eVar19" saveEventEvar2Value="{configProxy.flashvars.referer}"
saveEventProp1="prop33" saveEventProp1Value="{mediaProxy.entry.name}"
saveEventProp2="prop32" saveEventProp2Value="{configProxy.flashvars.referer}"

the output is :
event22, eVar18:actual name, eVar19:actualUrl , prop33: actual name , prop32:actualUrl


advantages: 
very dynamicly. 
Can get access to every exposed data from the KDP, including custom flashvars (this is very
 important, cause if the page holds some information it is very easy to pass it to the Omniture
 through the binding). 
Up to 9 Evars and event props per single event

disadvantages: 
this is a close list of events
the parsing of it is in a try & catch since this are UiConf attributes (TBD – move this to
 a single XML node like the Gigya UI )
has a very strict and hard coded structure (the events names and the corresponding keys
 values pairing).
