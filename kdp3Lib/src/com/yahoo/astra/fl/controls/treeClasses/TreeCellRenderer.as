/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.controls.treeClasses {

	import com.yahoo.astra.fl.controls.Tree;
	import fl.controls.ButtonLabelPlacement;
	import fl.controls.listClasses.ListData;
	import fl.controls.listClasses.ICellRenderer;
	import fl.controls.LabelButton;
	import fl.core.UIComponent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import fl.core.InvalidationType;
	import flash.display.Sprite;
	
	
    //--------------------------------------
    //  Styles
    //--------------------------------------
 
 	/**
     *  Name of the class to use as the skin for the icon associated
	 *  with a closed branch of the tree.
     *
     *  @default TreeCellRenderer_closedBranchIcon
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */
    [Style(name="closedBranchIcon", type="Class")]
	
	/**
     *  Name of the class to use as the skin for the icon associated
	 *  with an open branch of the tree.
     *
     *  @default TreeCellRenderer_openBranchIcon
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */
	[Style(name="openBranchIcon", type="Class")]
	
	/**
     *  Name of the class to use as the skin for the icon associated
	 *  with a leaf node of the tree.
     *
     *  @default TreeCellRenderer_leafIcon
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */
	[Style(name="leafIcon", type="Class")]
	
     /**
     * @copy fl.controls.LabelButton#style:upSkin
     *
     * @default CellRenderer_upSkin
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */ 
    [Style(name="upSkin", type="Class")]

    /**
     * @copy fl.controls.LabelButton#style:downSkin
     *
     * @default CellRenderer_downSkin
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */
    [Style(name="downSkin", type="Class")]

    /**
     *  @copy fl.controls.LabelButton#style:overSkin
     *
     *  @default CellRenderer_overSkin
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */
    [Style(name="overSkin", type="Class")]

    /**
     *  @copy fl.controls.LabelButton#style:disabledSkin
     *
     *  @default CellRenderer_disabledSkin
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */
    [Style(name="disabledSkin", type="Class")]

    /**
     *  @copy fl.controls.LabelButton#style:selectedDisabledSkin
     *
     *  @default CellRenderer_selectedDisabledSkin
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */
    [Style(name="selectedDisabledSkin", type="Class")]

    /**
     *  @copy fl.controls.LabelButton#style:selectedUpSkin
     *
     *  @default CellRenderer_selectedUpSkin
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */
    [Style(name="selectedUpSkin", type="Class")]

    /**
     *  @copy fl.controls.LabelButton#style:selectedDownSkin
     *
     *  @default CellRenderer_selectedDownSkin
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */
    [Style(name="selectedDownSkin", type="Class")]

    /**
     *  @copy fl.controls.LabelButton#style:selectedOverSkin
     *
     *  @default CellRenderer_selectedOverSkin
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */
    [Style(name="selectedOverSkin", type="Class")]


	/**
     *  @copy fl.core.UIComponent#style:textFormat
	 *
     *  @default null
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */
    [Style(name="textFormat", type="flash.text.TextFormat")]


    /**
     *  @copy fl.core.UIComponent#style:disabledTextFormat
     *
     *  @default null
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */
    [Style(name="disabledTextFormat", type="flash.text.TextFormat")]


    /**
     *  @copy fl.controls.LabelButton#style:textPadding
     *
     *  @default 5
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */
    [Style(name="textPadding", type="Number", format="Length")]
	
	
	 /**
     *  Number of pixels to use as offset when rendering nested tree nodes.
     *
     *  @default 5
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */
    [Style(name="nodeIndent", type="Number", format="Length")]
	
	 /**
     *  Left margin width in pixels
     *
     *  @default 5
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */
    [Style(name="leftMargin", type="Number", format="Length")]

    //--------------------------------------
    //  Class description
    //--------------------------------------
	/**
	 * The TreeCellRenderer class defines methods and properties for  
	 * Tree component to manipulate and display custom 
	 * cell content in each of its rows. TreeCellRenderer relies on
	 * properties contained in the TreeDataProvider objects to set 
	 * appropriate icons and offsets for individual cells. 
     * The TreeCellRenderer implements ICellRenderer and extends
	 * the LabelButton.
	 *
	 * @see com.yahoo.astra.fl.controls.treeClasses.TreeDataProvider
     * @see ICellRenderer
     * @see fl.controls.LabelButton
	 *
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 */
	public class TreeCellRenderer extends LabelButton implements ICellRenderer {
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected var _listData:ListData;


		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected var _data:Object;
		

        /**
         * Creates a new TreeCellRenderer instance.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function TreeCellRenderer():void {
			super();
			toggle = true;
			focusEnabled = false;
			
			this.addEventListener(MouseEvent.CLICK, handleClickEvent, false, 0, true);
		}
		
		
		private function handleClickEvent(evt:MouseEvent) : void {
			var currentNode:TNode = data as TNode;
			if (this.icon != null && currentNode is BranchNode &&
				this.icon.x <= this.mouseX &&
				this.mouseX <= (this.icon.x + this.icon.width) &&
				this.icon.y <= this.mouseY &&
				this.mouseY <= (this.icon.y + this.icon.height)) {
					evt.stopImmediatePropagation();
							if (currentNode.isOpen()) {
								currentNode.closeNode();
							}
							else {
								currentNode.openNode();
							}
			}																			
		}
		
        /**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		private static var defaultStyles:Object = {upSkin:"TreeCellRenderer_upSkin",downSkin:"TreeCellRenderer_downSkin",overSkin:"TreeCellRenderer_overSkin",
												  disabledSkin:"TreeCellRenderer_disabledSkin",
												  selectedDisabledSkin:"TreeCellRenderer_selectedDisabledSkin",
												  selectedUpSkin:"TreeCellRenderer_selectedUpSkin",selectedDownSkin:"TreeCellRenderer_selectedDownSkin",selectedOverSkin:"TreeCellRenderer_selectedOverSkin",
												  closedBranchIcon:"TreeCellRenderer_closedBranchIcon", 
												  openBranchIcon:"TreeCellRenderer_openBranchIcon",
												  leafIcon:"TreeCellRenderer_leafIcon",
												  textFormat:null,
												  disabledTextFormat:null,
												  embedFonts:null,
												  textPadding:5,
												  nodeIndent:5,
												  leftMargin:5};
        /**
         * @copy fl.core.UIComponent#getStyleDefinition()
         *
		 * @includeExample ../../core/examples/UIComponent.getStyleDefinition.1.as -noswf
		 *
         * @see fl.core.UIComponent#getStyle()
         * @see fl.core.UIComponent#setStyle()
         * @see fl.managers.StyleManager
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public static function getStyleDefinition():Object { 
			return mergeStyles(defaultStyles, LabelButton.getStyleDefinition());
		}
		
		/**
		 * Specifies the dimensions at which the data should be rendered. 
		 * These dimensions affect both the data and the cell that contains it; 
		 * the cell renderer uses them to ensure that the data fits the cell and 
		 * does not bleed into adjacent cells. 
		 *
         * @param width The width of the object, in pixels.
		 *
         * @param height The height of the object, in pixels.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override public function setSize(width:Number,height:Number):void {
			super.setSize(width, height);
		}
		
		/**
         * @copy fl.controls.listClasses.ICellRenderer#listData
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function get listData():ListData {
			return _listData;
		}	
		
		/**
         * @private (setter)
         * When listData is set, we determine the appropriate icon to use
		 * with the particular type of Tree node (open branch, closed branch,
		 * or leaf).
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function set listData(value:ListData):void {
			_listData = value;
			label = _listData.label;
			var parentTree:Tree = _listData.owner as Tree;
			if (data.nodeType == TreeDataProvider.BRANCH_NODE) {
				if (data.nodeState == TreeDataProvider.OPEN_NODE) {
					if (parentTree.iconFunction != null) {
						setStyle("icon", parentTree.iconFunction(data));
					} else if (parentTree.openBranchIconField != null && data[parentTree.openBranchIconField] != null) {
						setStyle("icon", data[parentTree.openBranchIconField]);
					} else {
						setStyle("icon", getStyleValue("openBranchIcon"));
					}
				} else {
					if (parentTree.iconFunction != null) {
						setStyle("icon", parentTree.iconFunction(data));
					} else if (parentTree.closedBranchIconField != null && data[parentTree.closedBranchIconField] != null) {
						setStyle("icon", data[parentTree.closedBranchIconField]);
					} else {
						setStyle("icon", getStyleValue("closedBranchIcon"));
					}
				}
			}
			else {
				if (parentTree.iconFunction != null) {
					setStyle("icon", parentTree.iconFunction(data));
				} else if (parentTree.openBranchIconField != null && data[parentTree.leafIconField] != null) {
					setStyle("icon", data[parentTree.leafIconField]);
				} else {
					setStyle("icon", getStyleValue("leafIcon"));
				}
			}
		}
		
		/**
		 * @copy fl.controls.listClasses.ICellRenderer#data
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function get data():Object {
			return _data;
		}		
		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function set data(value:Object):void {
			_data = value;
		}
		
		/**
         * @copy fl.controls.listClasses.ICellRenderer#selected
         *
         * @default false
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override public function get selected():Boolean {
			return super.selected;
		}
		 
		/**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override public function set selected(value:Boolean):void {
			super.selected = value;
		}
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override protected function toggleSelected(event:MouseEvent):void {
			// don't set selected or dispatch change event.
		}
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override protected function drawLayout():void {
			var textPadding:Number = Number(getStyleValue("textPadding"));
			var nodeIndent:Number = Number(getStyleValue("nodeIndent"));
			var leftMargin:Number = Number(getStyleValue("leftMargin"));
			var textFieldX:Number = 0;
			
			// Align icon and add the indent derived from node's level
			if (icon != null) {
				icon.x = leftMargin + data.nodeLevel * nodeIndent;
				icon.y = Math.round((height-icon.height)>>1);
				textFieldX = icon.x + icon.width + textPadding;
			}
			
			
			// Align text and add the indent derived from node's level
			if (label.length > 0) {
				textField.visible = true;
				var textWidth:Number =  Math.max(0, width - textFieldX - textPadding*2);
				textField.width = textWidth;
				textField.height = textField.textHeight + 4;
				textField.x = textFieldX;
				textField.y = Math.round((height-textField.height)>>1);
			} else {
				textField.visible = false;
			}
			
			// Size background
			background.width = width;
			background.height = height;
		}
		
	}
}