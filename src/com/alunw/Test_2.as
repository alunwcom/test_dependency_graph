package com.alunw {
	
	import flash.display.CapsStyle;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class Test_2 extends Sprite {
		
		protected const NUM_SEGMENTS:int = 10;
		protected var segmentRotation:Number = 0;
		protected var allSegments:Array;
		
		public function Test_2() {
			
			allSegments = new Array();
			var segmentLength:Number = stage.stageWidth / NUM_SEGMENTS;
			var segment:Sprite = this;
			segment.y = stage.stageHeight/2;
			for (var i:int = 0; i < NUM_SEGMENTS; i++) {
				var childSegment:Sprite = makeSegment(segmentLength);
				segment.addChild(childSegment);
				childSegment.x = segmentLength;
				allSegments.push(childSegment);
				//every segment gets added as a child of the last one
				segment = childSegment;
			}
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		protected function onMouseMove(event:MouseEvent):void {
			var segmentRotation:Number =
				360/NUM_SEGMENTS * 2*((stage.mouseY / stage.stageHeight) - 0.5);
			for each (var segment:Sprite in allSegments) {
				//all rotation values are set to the same number,
				//yet the line curls inward progressively!
				//this is because every rotation affects all its children.
				segment.rotation = segmentRotation;
			}
		}
		protected function makeSegment(length:Number):Sprite {
			var s:Sprite = new Sprite();
			s.graphics.lineStyle(16, 0x4F7302, 1, false, null, CapsStyle.NONE);
			s.graphics.lineTo(length, 0);
			return s;
		}
	}
}
