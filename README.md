# KDP - Kaltura Dynamic Player

* Main required projects to run kdp3 are KDP3, kdp3Lib, as3FlexClient, and all projects under "vendors".
 All other plugins can be imported by demand.

* Default Flex SDK is: 4.5.1A

* After importing the desired projects to your Flash Builder workspace go to: Window --> Preferences --> General --> Workspace --> Linked Resource:

 1. Change ${Documents} value to your git repository root folder

 2. Add ${linkReport} - it should point to [workspace]/KDP3/bin-debug/linkReport.xml

## Build-Release Instructions
1. Install Apache Ant
2. go to: KDP3 --> build_KDP.xml --> run as Ant build

## Documentation
* [KDP release notes] (http://knowledge.kaltura.com/kdp-release-notes)
* [KDP in the Knowledge Center] (http://knowledge.kaltura.com/services/kaltura-dynamic-player-kdp)
* [KDP Guide] (http://www.kaltura.org/demos/kdp3/docs.html)
* Most updated list of KDP flashvars and other usefull documents can be found under [kdp3lib-->docs] (https://github.com/kaltura/kdp/tree/master/kdp3Lib/docs) folder

## License and Copyright Information
All KDP (Kaltura Dynamic Player) code is released under the AGPLv3 http://www.gnu.org/licenses/agpl-3.0.html unless a different license for a particular library is specified in the applicable library path.
Copyright © Kaltura Inc. All rights reserved.

 
