package fl.managers 
{
    import fl.controls.*;
    import fl.core.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.ui.*;
    import flash.utils.*;
    
    public class FocusManager extends Object implements fl.managers.IFocusManager
    {
        private function hasFocusableObjects():Boolean
        {
            var loc1:*=null;
            var loc2:*=0;
            var loc3:*=focusableObjects;
            for (loc1 in loc3) 
            {
                return true;
            }
            return false;
        }

        private function tabIndexChangeHandler(arg1:flash.events.Event):void
        {
            calculateCandidates = true;
            return;
        }

        public function set defaultButton(arg1:fl.controls.Button):void
        {
            var loc1:*=arg1 ? fl.controls.Button(arg1) : null;
            if (loc1 != _defaultButton) 
            {
                if (_defaultButton) 
                {
                    _defaultButton.emphasized = false;
                }
                if (defButton) 
                {
                    defButton.emphasized = false;
                }
                _defaultButton = loc1;
                defButton = loc1;
                if (loc1) 
                {
                    loc1.emphasized = true;
                }
            }
            return;
        }

        private function sortFocusableObjects():void
        {
            var loc1:*=null;
            var loc2:*=null;
            focusableCandidates = [];
            var loc3:*=0;
            var loc4:*=focusableObjects;
            for (loc1 in loc4) 
            {
                loc2 = flash.display.InteractiveObject(loc1);
                if (loc2.tabIndex && !isNaN(Number(loc2.tabIndex)) && loc2.tabIndex > 0) 
                {
                    sortFocusableObjectsTabIndex();
                    return;
                }
                focusableCandidates.push(loc2);
            }
            focusableCandidates.sort(sortByDepth);
            return;
        }

        private function keyFocusChangeHandler(arg1:flash.events.FocusEvent):void
        {
            showFocusIndicator = true;
            if ((arg1.keyCode == flash.ui.Keyboard.TAB || arg1.keyCode == 0) && !arg1.isDefaultPrevented()) 
            {
                setFocusToNextObject(arg1);
                arg1.preventDefault();
            }
            return;
        }

        private function getIndexOfFocusedObject(arg1:flash.display.DisplayObject):int
        {
            var loc1:*=focusableCandidates.length;
            var loc2:*=0;
            loc2 = 0;
            while (loc2 < loc1) 
            {
                if (focusableCandidates[loc2] == arg1) 
                {
                    return loc2;
                }
                ++loc2;
            }
            return -1;
        }

        public function hideFocus():void
        {
            return;
        }

        private function removedHandler(arg1:flash.events.Event):void
        {
            var loc1:*=0;
            var loc3:*=null;
            var loc2:*=flash.display.DisplayObject(arg1.target);
            if (loc2 is fl.managers.IFocusManagerComponent && focusableObjects[loc2] == true) 
            {
                if (loc2 == lastFocus) 
                {
                    fl.managers.IFocusManagerComponent(lastFocus).drawFocus(false);
                    lastFocus = null;
                }
                loc2.removeEventListener(flash.events.Event.TAB_ENABLED_CHANGE, tabEnabledChangeHandler);
                delete focusableObjects[loc2];
                calculateCandidates = true;
            }
            else if (loc2 is flash.display.InteractiveObject && focusableObjects[loc2] == true) 
            {
                loc3 = loc2 as flash.display.InteractiveObject;
                if (loc3) 
                {
                    if (loc3 == lastFocus) 
                    {
                        lastFocus = null;
                    }
                    delete focusableObjects[loc3];
                    calculateCandidates = true;
                }
                loc2.addEventListener(flash.events.Event.TAB_ENABLED_CHANGE, tabEnabledChangeHandler);
            }
            removeFocusables(loc2);
            return;
        }

        private function sortByDepth(arg1:flash.display.InteractiveObject, arg2:flash.display.InteractiveObject):Number
        {
            var loc3:*=0;
            var loc4:*=null;
            var loc5:*=null;
            var loc1:*="";
            var loc2:*="";
            var loc6:*="0000";
            var loc7:*=flash.display.DisplayObject(arg1);
            var loc8:*=flash.display.DisplayObject(arg2);
            while (!(loc7 == flash.display.DisplayObject(form)) && loc7.parent) 
            {
                loc3 = getChildIndex(loc7.parent, loc7);
                loc4 = loc3.toString(16);
                if (loc4.length < 4) 
                {
                    loc5 = loc6.substring(0, 4 - loc4.length) + loc4;
                }
                loc1 = loc5 + loc1;
                loc7 = loc7.parent;
            }
            while (!(loc8 == flash.display.DisplayObject(form)) && loc8.parent) 
            {
                loc3 = getChildIndex(loc8.parent, loc8);
                loc4 = loc3.toString(16);
                if (loc4.length < 4) 
                {
                    loc5 = loc6.substring(0, 4 - loc4.length) + loc4;
                }
                loc2 = loc5 + loc2;
                loc8 = loc8.parent;
            }
            return loc1 > loc2 ? 1 : loc1 < loc2 ? -1 : 0;
        }

        public function get defaultButton():fl.controls.Button
        {
            return _defaultButton;
        }

        private function activateHandler(arg1:flash.events.Event):void
        {
            var loc1:*=flash.display.InteractiveObject(arg1.target);
            if (lastFocus) 
            {
                if (lastFocus is fl.managers.IFocusManagerComponent) 
                {
                    fl.managers.IFocusManagerComponent(lastFocus).setFocus();
                }
                else 
                {
                    form.stage.focus = lastFocus;
                }
            }
            lastAction = "ACTIVATE";
            return;
        }

        public function showFocus():void
        {
            return;
        }

        public function set defaultButtonEnabled(arg1:Boolean):void
        {
            _defaultButtonEnabled = arg1;
            return;
        }

        public function getNextFocusManagerComponent(arg1:Boolean=false):flash.display.InteractiveObject
        {
            var loc7:*=null;
            if (!hasFocusableObjects()) 
            {
                return null;
            }
            if (calculateCandidates) 
            {
                sortFocusableObjects();
                calculateCandidates = false;
            }
            var loc1:*=form.stage.focus;
            loc1 = flash.display.DisplayObject(findFocusManagerComponent(flash.display.InteractiveObject(loc1)));
            var loc2:*="";
            if (loc1 is fl.managers.IFocusManagerGroup) 
            {
                loc7 = fl.managers.IFocusManagerGroup(loc1);
                loc2 = loc7.groupName;
            }
            var loc3:*=getIndexOfFocusedObject(loc1);
            var loc4:*=false;
            var loc5:*=loc3;
            if (loc3 == -1) 
            {
                if (arg1) 
                {
                    loc3 = focusableCandidates.length;
                }
                loc4 = true;
            }
            var loc6:*=getIndexOfNextObject(loc3, arg1, loc4, loc2);
            return findFocusManagerComponent(focusableCandidates[loc6]);
        }

        private function mouseDownHandler(arg1:flash.events.MouseEvent):void
        {
            if (arg1.isDefaultPrevented()) 
            {
                return;
            }
            var loc1:*=getTopLevelFocusTarget(flash.display.InteractiveObject(arg1.target));
            if (!loc1) 
            {
                return;
            }
            showFocusIndicator = false;
            if ((!(loc1 == lastFocus) || lastAction == "ACTIVATE") && !(loc1 is flash.text.TextField)) 
            {
                setFocus(loc1);
            }
            lastAction = "MOUSEDOWN";
            return;
        }

        private function isTabVisible(arg1:flash.display.DisplayObject):Boolean
        {
            return true;
            var loc1:*=arg1.parent;
            while (loc1 && !(loc1 is flash.display.Stage) && !(loc1.parent && loc1.parent is flash.display.Stage)) 
            {
                if (!loc1.tabChildren) 
                {
                    return false;
                }
                loc1 = loc1.parent;
            }
            return true;
        }

        public function get nextTabIndex():int
        {
            return 0;
        }

        private function keyDownHandler(arg1:flash.events.KeyboardEvent):void
        {
            if (arg1.keyCode == flash.ui.Keyboard.TAB) 
            {
                lastAction = "KEY";
                if (calculateCandidates) 
                {
                    sortFocusableObjects();
                    calculateCandidates = false;
                }
            }
            if (defaultButtonEnabled && arg1.keyCode == flash.ui.Keyboard.ENTER && defaultButton && defButton.enabled) 
            {
                sendDefaultButtonEvent();
            }
            return;
        }

        private function focusInHandler(arg1:flash.events.FocusEvent):void
        {
            var loc2:*=null;
            var loc1:*=flash.display.InteractiveObject(arg1.target);
            if (form.contains(loc1)) 
            {
                lastFocus = findFocusManagerComponent(flash.display.InteractiveObject(loc1));
                if (lastFocus is fl.controls.Button) 
                {
                    loc2 = fl.controls.Button(lastFocus);
                    if (defButton) 
                    {
                        defButton.emphasized = false;
                        defButton = loc2;
                        loc2.emphasized = true;
                    }
                }
                else if (defButton && !(defButton == _defaultButton)) 
                {
                    defButton.emphasized = false;
                    defButton = _defaultButton;
                    _defaultButton.emphasized = true;
                }
            }
            return;
        }

        private function tabEnabledChangeHandler(arg1:flash.events.Event):void
        {
            calculateCandidates = true;
            var loc1:*=flash.display.InteractiveObject(arg1.target);
            var loc2:*=focusableObjects[loc1] == true;
            if (loc1.tabEnabled) 
            {
                if (!loc2 && isTabVisible(loc1)) 
                {
                    if (!(loc1 is fl.managers.IFocusManagerComponent)) 
                    {
                        loc1.focusRect = false;
                    }
                    focusableObjects[loc1] = true;
                }
            }
            else if (loc2) 
            {
                delete focusableObjects[loc1];
            }
            return;
        }

        public function set showFocusIndicator(arg1:Boolean):void
        {
            _showFocusIndicator = arg1;
            return;
        }

        public function get form():flash.display.DisplayObjectContainer
        {
            return _form;
        }

        private function sortByTabIndex(arg1:flash.display.InteractiveObject, arg2:flash.display.InteractiveObject):int
        {
            return arg1.tabIndex > arg2.tabIndex ? 1 : arg1.tabIndex < arg2.tabIndex ? -1 : sortByDepth(arg1, arg2);
        }

        public function get defaultButtonEnabled():Boolean
        {
            return _defaultButtonEnabled;
        }

        public function activate():void
        {
            if (activated) 
            {
                return;
            }
            form.stage.addEventListener(flash.events.FocusEvent.MOUSE_FOCUS_CHANGE, mouseFocusChangeHandler, false, 0, true);
            form.stage.addEventListener(flash.events.FocusEvent.KEY_FOCUS_CHANGE, keyFocusChangeHandler, false, 0, true);
            form.addEventListener(flash.events.FocusEvent.FOCUS_IN, focusInHandler, true);
            form.addEventListener(flash.events.FocusEvent.FOCUS_OUT, focusOutHandler, true);
            form.stage.addEventListener(flash.events.Event.ACTIVATE, activateHandler, false, 0, true);
            form.stage.addEventListener(flash.events.Event.DEACTIVATE, deactivateHandler, false, 0, true);
            form.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, mouseDownHandler);
            form.addEventListener(flash.events.KeyboardEvent.KEY_DOWN, keyDownHandler, true);
            activated = true;
            if (lastFocus) 
            {
                setFocus(lastFocus);
            }
            return;
        }

        public function deactivate():void
        {
            form.stage.removeEventListener(flash.events.FocusEvent.MOUSE_FOCUS_CHANGE, mouseFocusChangeHandler);
            form.stage.removeEventListener(flash.events.FocusEvent.KEY_FOCUS_CHANGE, keyFocusChangeHandler);
            form.removeEventListener(flash.events.FocusEvent.FOCUS_IN, focusInHandler, true);
            form.removeEventListener(flash.events.FocusEvent.FOCUS_OUT, focusOutHandler, true);
            form.stage.removeEventListener(flash.events.Event.ACTIVATE, activateHandler);
            form.stage.removeEventListener(flash.events.Event.DEACTIVATE, deactivateHandler);
            form.removeEventListener(flash.events.MouseEvent.MOUSE_DOWN, mouseDownHandler);
            form.removeEventListener(flash.events.KeyboardEvent.KEY_DOWN, keyDownHandler, true);
            activated = false;
            return;
        }

        public function FocusManager(arg1:flash.display.DisplayObjectContainer)
        {
            super();
            focusableObjects = new flash.utils.Dictionary(true);
            if (arg1 != null) 
            {
                _form = arg1;
                addFocusables(flash.display.DisplayObject(arg1));
                arg1.addEventListener(flash.events.Event.ADDED, addedHandler);
                arg1.addEventListener(flash.events.Event.REMOVED, removedHandler);
                activate();
            }
            return;
        }

        public function get showFocusIndicator():Boolean
        {
            return _showFocusIndicator;
        }

        private function getIndexOfNextObject(arg1:int, arg2:Boolean, arg3:Boolean, arg4:String):int
        {
            var loc3:*=null;
            var loc4:*=null;
            var loc5:*=0;
            var loc6:*=null;
            var loc7:*=null;
            var loc1:*=focusableCandidates.length;
            var loc2:*=arg1;
            while (true) 
            {
                if (arg2) 
                {
                    --arg1;
                }
                else 
                {
                    ++arg1;
                }
                if (arg3) 
                {
                    if (arg2 && arg1 < 0) 
                    {
                        break;
                    }
                    if (!arg2 && arg1 == loc1) 
                    {
                        break;
                    }
                }
                else 
                {
                    arg1 = (arg1 + loc1) % loc1;
                    if (loc2 == arg1) 
                    {
                        break;
                    }
                }
                if (!isValidFocusCandidate(focusableCandidates[arg1], arg4)) 
                {
                    continue;
                }
                loc3 = flash.display.DisplayObject(findFocusManagerComponent(focusableCandidates[arg1]));
                if (loc3 is fl.managers.IFocusManagerGroup) 
                {
                    loc4 = fl.managers.IFocusManagerGroup(loc3);
                    loc5 = 0;
                    while (loc5 < focusableCandidates.length) 
                    {
                        loc6 = focusableCandidates[loc5];
                        if (loc6 is fl.managers.IFocusManagerGroup) 
                        {
                            loc7 = fl.managers.IFocusManagerGroup(loc6);
                            if (loc7.groupName == loc4.groupName && loc7.selected) 
                            {
                                arg1 = loc5;
                            }
                        }
                        ++loc5;
                    }
                }
                return arg1;
            }
            return arg1;
        }

        private function mouseFocusChangeHandler(arg1:flash.events.FocusEvent):void
        {
            if (arg1.relatedObject is flash.text.TextField) 
            {
                return;
            }
            arg1.preventDefault();
            return;
        }

        public function set form(arg1:flash.display.DisplayObjectContainer):void
        {
            _form = arg1;
            return;
        }

        private function addFocusables(arg1:flash.display.DisplayObject, arg2:Boolean=false):void
        {
            var child:flash.display.DisplayObject;
            var io:flash.display.InteractiveObject;
            var i:int;
            var skipTopLevel:Boolean=false;
            var o:flash.display.DisplayObject;
            var doc:flash.display.DisplayObjectContainer;
            var focusable:fl.managers.IFocusManagerComponent;

            var loc1:*;
            focusable = null;
            io = null;
            doc = null;
            i = 0;
            child = null;
            o = arg1;
            skipTopLevel = arg2;
            if (!skipTopLevel) 
            {
                if (o is fl.managers.IFocusManagerComponent) 
                {
                    focusable = fl.managers.IFocusManagerComponent(o);
                    if (focusable.focusEnabled) 
                    {
                        if (focusable.tabEnabled && isTabVisible(o)) 
                        {
                            focusableObjects[o] = true;
                            calculateCandidates = true;
                        }
                        o.addEventListener(flash.events.Event.TAB_ENABLED_CHANGE, tabEnabledChangeHandler);
                        o.addEventListener(flash.events.Event.TAB_INDEX_CHANGE, tabIndexChangeHandler);
                    }
                }
                else if (o is flash.display.InteractiveObject) 
                {
                    io = o as flash.display.InteractiveObject;
                    if (io && io.tabEnabled && findFocusManagerComponent(io) == io) 
                    {
                        focusableObjects[io] = true;
                        calculateCandidates = true;
                    }
                    io.addEventListener(flash.events.Event.TAB_ENABLED_CHANGE, tabEnabledChangeHandler);
                    io.addEventListener(flash.events.Event.TAB_INDEX_CHANGE, tabIndexChangeHandler);
                }
            }
            if (o is flash.display.DisplayObjectContainer) 
            {
                doc = flash.display.DisplayObjectContainer(o);
                o.addEventListener(flash.events.Event.TAB_CHILDREN_CHANGE, tabChildrenChangeHandler);
                if (doc is flash.display.Stage || doc.parent is flash.display.Stage || doc.tabChildren) 
                {
                    i = 0;
                    while (i < doc.numChildren) 
                    {
                        try 
                        {
                            child = doc.getChildAt(i);
                            if (child != null) 
                            {
                                addFocusables(doc.getChildAt(i));
                            }
                        }
                        catch (error:SecurityError)
                        {
                        };
                        ++i;
                    }
                }
            }
            return;
        }

        private function getChildIndex(arg1:flash.display.DisplayObjectContainer, arg2:flash.display.DisplayObject):int
        {
            return arg1.getChildIndex(arg2);
        }

        public function findFocusManagerComponent(arg1:flash.display.InteractiveObject):flash.display.InteractiveObject
        {
            var loc1:*=arg1;
            while (arg1) 
            {
                if (arg1 is fl.managers.IFocusManagerComponent && fl.managers.IFocusManagerComponent(arg1).focusEnabled) 
                {
                    return arg1;
                }
                arg1 = arg1.parent;
            }
            return loc1;
        }

        private function focusOutHandler(arg1:flash.events.FocusEvent):void
        {
            var loc1:*=arg1.target as flash.display.InteractiveObject;
            return;
        }

        private function isValidFocusCandidate(arg1:flash.display.DisplayObject, arg2:String):Boolean
        {
            var loc1:*=null;
            if (!isEnabledAndVisible(arg1)) 
            {
                return false;
            }
            if (arg1 is fl.managers.IFocusManagerGroup) 
            {
                loc1 = fl.managers.IFocusManagerGroup(arg1);
                if (arg2 == loc1.groupName) 
                {
                    return false;
                }
            }
            return true;
        }

        private function setFocusToNextObject(arg1:flash.events.FocusEvent):void
        {
            if (!hasFocusableObjects()) 
            {
                return;
            }
            var loc1:*=getNextFocusManagerComponent(arg1.shiftKey);
            if (loc1) 
            {
                setFocus(loc1);
            }
            return;
        }

        private function sortFocusableObjectsTabIndex():void
        {
            var loc1:*=null;
            var loc2:*=null;
            focusableCandidates = [];
            var loc3:*=0;
            var loc4:*=focusableObjects;
            for (loc1 in loc4) 
            {
                loc2 = flash.display.InteractiveObject(loc1);
                if (!(loc2.tabIndex && !isNaN(Number(loc2.tabIndex)))) 
                {
                    continue;
                }
                focusableCandidates.push(loc2);
            }
            focusableCandidates.sort(sortByTabIndex);
            return;
        }

        public function getFocus():flash.display.InteractiveObject
        {
            var loc1:*=form.stage.focus;
            return findFocusManagerComponent(loc1);
        }

        public function setFocus(arg1:flash.display.InteractiveObject):void
        {
            if (arg1 is fl.managers.IFocusManagerComponent) 
            {
                fl.managers.IFocusManagerComponent(arg1).setFocus();
            }
            else 
            {
                form.stage.focus = arg1;
            }
            return;
        }

        private function deactivateHandler(arg1:flash.events.Event):void
        {
            var loc1:*=flash.display.InteractiveObject(arg1.target);
            return;
        }

        private function tabChildrenChangeHandler(arg1:flash.events.Event):void
        {
            if (arg1.target != arg1.currentTarget) 
            {
                return;
            }
            calculateCandidates = true;
            var loc1:*=flash.display.DisplayObjectContainer(arg1.target);
            if (loc1.tabChildren) 
            {
                addFocusables(loc1, true);
            }
            else 
            {
                removeFocusables(loc1);
            }
            return;
        }

        private function isEnabledAndVisible(arg1:flash.display.DisplayObject):Boolean
        {
            var loc2:*=null;
            var loc3:*=null;
            var loc1:*=flash.display.DisplayObject(form).parent;
            while (arg1 != loc1) 
            {
                if (arg1 is fl.core.UIComponent) 
                {
                    if (!fl.core.UIComponent(arg1).enabled) 
                    {
                        return false;
                    }
                }
                else if (arg1 is flash.text.TextField) 
                {
                    loc2 = flash.text.TextField(arg1);
                    if (loc2.type == flash.text.TextFieldType.DYNAMIC || !loc2.selectable) 
                    {
                        return false;
                    }
                }
                else if (arg1 is flash.display.SimpleButton) 
                {
                    loc3 = flash.display.SimpleButton(arg1);
                    if (!loc3.enabled) 
                    {
                        return false;
                    }
                }
                if (!arg1.visible) 
                {
                    return false;
                }
                arg1 = arg1.parent;
            }
            return true;
        }

        private function addedHandler(arg1:flash.events.Event):void
        {
            var loc1:*=flash.display.DisplayObject(arg1.target);
            if (loc1.stage) 
            {
                addFocusables(flash.display.DisplayObject(arg1.target));
            }
            return;
        }

        public function sendDefaultButtonEvent():void
        {
            defButton.dispatchEvent(new flash.events.MouseEvent(flash.events.MouseEvent.CLICK));
            return;
        }

        private function getTopLevelFocusTarget(arg1:flash.display.InteractiveObject):flash.display.InteractiveObject
        {
            while (arg1 != flash.display.InteractiveObject(form)) 
            {
                if (arg1 is fl.managers.IFocusManagerComponent && fl.managers.IFocusManagerComponent(arg1).focusEnabled && fl.managers.IFocusManagerComponent(arg1).mouseFocusEnabled && fl.core.UIComponent(arg1).enabled) 
                {
                    return arg1;
                }
                arg1 = arg1.parent;
                if (arg1 != null) 
                {
                    continue;
                }
                break;
            }
            return null;
        }

        private function removeFocusables(arg1:flash.display.DisplayObject):void
        {
            var loc1:*=null;
            var loc2:*=null;
            if (arg1 is flash.display.DisplayObjectContainer) 
            {
                arg1.removeEventListener(flash.events.Event.TAB_CHILDREN_CHANGE, tabChildrenChangeHandler);
                arg1.removeEventListener(flash.events.Event.TAB_INDEX_CHANGE, tabIndexChangeHandler);
                var loc3:*=0;
                var loc4:*=focusableObjects;
                for (loc1 in loc4) 
                {
                    loc2 = flash.display.DisplayObject(loc1);
                    if (!flash.display.DisplayObjectContainer(arg1).contains(loc2)) 
                    {
                        continue;
                    }
                    if (loc2 == lastFocus) 
                    {
                        lastFocus = null;
                    }
                    loc2.removeEventListener(flash.events.Event.TAB_ENABLED_CHANGE, tabEnabledChangeHandler);
                    delete focusableObjects[loc1];
                    calculateCandidates = true;
                }
            }
            return;
        }

        private var _defaultButtonEnabled:Boolean=true;

        private var _showFocusIndicator:Boolean=true;

        private var defButton:fl.controls.Button;

        private var lastAction:String;

        private var lastFocus:flash.display.InteractiveObject;

        private var _form:flash.display.DisplayObjectContainer;

        private var focusableCandidates:Array;

        private var activated:Boolean=false;

        private var calculateCandidates:Boolean=true;

        private var focusableObjects:flash.utils.Dictionary;

        private var _defaultButton:fl.controls.Button;
    }
}


