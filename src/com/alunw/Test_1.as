package com.alunw
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
		
	public class Test_1 extends Sprite {
			
		protected const NUM_FILES:int = 10;
		protected var deleteBin:Sprite;
			
		public function Test_1() {
			deleteBin = makeDeleteBin();
			//the delete bin should stay at the bottom
			addChildAt(deleteBin, 0);
			deleteBin.x = 15;
			deleteBin.y = 15;
				
			for (var i:int = 0; i < NUM_FILES; i++) {
				var file:Sprite = makeFile();
				addChild(file);
				//randomize position by looking at available stage size
				file.x = Math.random() * (stage.stageWidth - file.width);
				file.y = Math.random() * (stage.stageHeight - file.height);
				//Sprites are InteractiveObjects
				file.addEventListener(MouseEvent.MOUSE_DOWN, onFileMouseDown);
				file.addEventListener(MouseEvent.MOUSE_UP, onFileMouseUp);
			}
		}

		protected function onFileMouseDown(event:MouseEvent):void {
			var file:Sprite = Sprite(event.target);
			file.startDrag(); //Sprites have simple drag methods
			//moving is relative change in position
			file.x -= 2;
			file.y -= 2;
			//all DisplayObjects support filters
			file.filters = [new DropShadowFilter(2, 45, 0, 0.2)];
			setChildIndex(file, numChildren-1); //set child depth to the top
		}

		protected function onFileMouseUp(event:MouseEvent):void {
			var file:Sprite = Sprite(event.target);
			file.stopDrag(); //Sprites have simple drag methods
			file.x += 2;
			file.y += 2;
			file.filters = [];
			//see if it's over the delete bin
			if (deleteBin.hitTestObject(file)) {
				//and if so, remove from display list
				removeChild(file);
			}
		}

		protected function makeDeleteBin():Sprite {
			var s:Sprite = new Sprite();
			//Sprites support vector drawing
			s.graphics.beginFill(0xff0000);
			s.graphics.drawRoundRect(0, 0, 55, 70, 16);
			s.graphics.endFill();
			return s;
		}
			
		protected function makeFile():Sprite {
			var s:Sprite = new Sprite();
			//Sprites support vector drawing
			s.graphics.beginFill(0xc0c0c0);
			s.graphics.lineStyle(0, 0x808080);
			s.graphics.drawRect(0, 0, 8.5, 11);
			s.graphics.endFill();
			s.scaleX = s.scaleY = 3; //DisplayObjects support scaling
			s.buttonMode = true; //Sprites can act like buttons
			return s;
		}
	}
}
