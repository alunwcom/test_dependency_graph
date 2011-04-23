package com.alunw {
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	public class Test_3 extends Sprite {
		
		protected const KEEP_LAST_N:int = 15;
		protected var fullScreenButton:TextField;
		
		public function Test_3() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			fullScreenButton = new TextField();
			fullScreenButton.text = "full screen";
			fullScreenButton.selectable = false;
			fullScreenButton.background = true;
			fullScreenButton.backgroundColor = 0xc0c0c0;
			fullScreenButton.border = true;
			fullScreenButton.borderColor = 0;
			fullScreenButton.width = 55;
			fullScreenButton.height = 18;
			fullScreenButton.x = fullScreenButton.y = 25;
			addChild(fullScreenButton);
			fullScreenButton.addEventListener(MouseEvent.CLICK, onFullScreenClick);
			
			stage.addEventListener(Event.RESIZE, onStageResize);
			onStageResize(null);
		}
		
		protected function onStageResize(event:Event):void {
			var stageSize:Rectangle =
				new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			//create a margin so you can see the indicator
			stageSize.inflate(-10, -10);
			
			//add an indicator for the screen size
			var stageSizeIndicator:Sprite = new Sprite();
			stageSizeIndicator.graphics.lineStyle(0, Math.random() * 0xffffff);
			stageSizeIndicator.graphics.drawRect(
				stageSize.x, stageSize.y, stageSize.width, stageSize.height);
			var label:TextField = new TextField();
			label.x = stageSize.right - 65;
			label.y = stageSize.bottom - 15;
			label.text = stageSize.width + " x " + stageSize.height;
			stageSizeIndicator.addChild(label);
			addChildAt(stageSizeIndicator, 0);
			
			if (numChildren > KEEP_LAST_N) {
				removeChildAt(numChildren - 2); //numChildren - 1 is the button.
			}
		}
		
		protected function onFullScreenClick(event:MouseEvent):void {
			if (stage.displayState == StageDisplayState.NORMAL) {
				stage.displayState = StageDisplayState.FULL_SCREEN;
			} else {
				stage.displayState = StageDisplayState.NORMAL;
			}
		}
	}
}

