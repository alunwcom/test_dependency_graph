package com.alunw
{
	import flare.display.TextSprite;
	import flare.query.methods.eq;
	import flare.util.Shapes;
	import flare.vis.Visualization;
	import flare.vis.controls.ExpandControl;
	import flare.vis.controls.HoverControl;
	import flare.vis.controls.IControl;
	import flare.vis.data.Data;
	import flare.vis.data.DataSprite;
	import flare.vis.data.NodeSprite;
	import flare.vis.data.Tree;
	import flare.vis.events.SelectionEvent;
	import flare.vis.operator.encoder.PropertyEncoder;
	import flare.vis.operator.label.RadialLabeler;
	import flare.vis.operator.layout.RadialTreeLayout;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;

	[SWF(backgroundColor="#ffffdd", frameRate="30")]
	public class GraphTest_2 extends Sprite
	{
		
		private var _stageLabel:Sprite;
		
		[Embed(source="verdana.TTF", fontName="Verdana")]
		private static var _font:Class;
		
		private var _fmt:TextFormat = new TextFormat("Verdana", 7);

		public function GraphTest_2()
		{
			init();
		}
		
		protected function init():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
					
			stage.addEventListener(Event.RESIZE, setStageLabel);
			setStageLabel(null);
			
			// Build data
			var data:Data = buildData();
			
			// Visualize
			var vis:Visualization = new Visualization(data);
			vis.bounds = new Rectangle(0, 0, 600, 500);
			vis.x = 100;
			vis.y = 50;
			addChild(vis);
			
			var layout:RadialTreeLayout = new RadialTreeLayout(50, false, false);
//			layout.useNodeSize = true;
			
			vis.operators.add(layout);
			
			vis.operators.add(new PropertyEncoder(
				{alpha: 0, visible:false}, Data.EDGES));
			vis.operators.add(new PropertyEncoder(
				{shape: Shapes.WEDGE, lineColor: 0xffffffff}, Data.NODES));
//			vis.operators.add(new PropertyEncoder(
//				{angleWidth: -2*Math.PI}, "param"));
			
			vis.operators.add(new RadialLabeler(
				function(d:DataSprite):String {
					var txt:String = d.data.name;
					return txt;
				}, true, _fmt, eq("childDegree",0))); // leaf nodes only
			vis.operators.last.textMode = TextSprite.EMBED; // embed fonts!
			
			vis.controls.add(new HoverControl(NodeSprite,
				// by default, move highlighted items to front
				HoverControl.MOVE_AND_RETURN,
				// highlight node border on mouse over
				function(e:SelectionEvent):void {
					e.node.lineWidth = 2;
					e.node.lineColor = 0x88ff0000;
				},
				// remove highlight on mouse out
				function(e:SelectionEvent):void {
					e.node.lineWidth = 0;
					e.node.lineColor = 0x88ffffff;
				}));
			var ctrl:IControl = new ExpandControl(NodeSprite,
				//				function():void { vis.update(1, "nodes","main").play(); });
				function():void {
					vis.update(0.5).play(); 
				});
			vis.controls.add(ctrl);	
			//			vis.continuousUpdates = true;
			
			vis.update();
		}

		private function setStageLabel(event:Event):void {
			
			if (_stageLabel) {
				removeChild(_stageLabel);
			}
			_stageLabel = new Sprite();
			_stageLabel.x = 10;
			_stageLabel.y = 10;
			_stageLabel.graphics.beginFill(0xe0e0e0);
			_stageLabel.graphics.lineStyle(0, 0x999999);
			_stageLabel.graphics.drawRect(0, 0, 150, 20);
			_stageLabel.graphics.endFill();
			addChild(_stageLabel);

			var txt:TextField = new TextField();
			txt.width = 150;
			_stageLabel.addChild(txt); 
			txt.appendText("Stage size: (" + stage.stageWidth + ", " + stage.stageHeight + ")");
			
		}
		
		public static function buildData():Data
		{
			
			/* Devise imaginary data for now - based on a file systen.
			 * 
			 * C:
			 * - Program Files
   			 *   - 7-zip (3,511 KB)
			 *   - Adobe (557,392 KB)
			 *   - Microsoft Office (922,978 KB)
			 *   - VMWare (13,810 KB)
			 * - Users
			 *   - alun (2,042,101 KB)
			 *   - Public (59,204 KB)
			 * - autoexec.bat (1 KB)
			 * - pagefile.sys (2,096,696 KB)
			 */
			
			var tree:Tree = new Tree();
			var root:NodeSprite = tree.addRoot();
			
			var a:NodeSprite = tree.addChild(root);
			a.fillColor = 0x88CCCC00;
			a.size = 3511 + 557392 + 922978 + 13810;
			a.name = "Program Files";
			
			var aa:NodeSprite = tree.addChild(a);
			aa.fillColor = 0x88CCCC00;
			aa.size = 3511;
			aa.name = "7-zip";
			
			var ab:NodeSprite = tree.addChild(a);
			ab.fillColor = 0x88CCCC00;
			ab.size = 557392;
			ab.name = "Adobe";
			
			var ac:NodeSprite = tree.addChild(a);
			ac.fillColor = 0x88CCCC00;
			ac.size = 922978;
			ac.name = "Microsoft Office";
			
			var ad:NodeSprite = tree.addChild(a);
			ad.fillColor = 0x88CCCC00;
			ad.size = 13810;
			ad.name = "VMWare";
			
			var b:NodeSprite = tree.addChild(root);
			b.fillColor = 0x88CCCC00;
			b.size = 2042101 + 59204;
			b.name = "Users";
			
			var ba:NodeSprite = tree.addChild(b);
			ba.fillColor = 0x88CCCC00;
			ba.size = 2042101;
			ba.name = "alun";
			
			var bb:NodeSprite = tree.addChild(b);
			bb.fillColor = 0x88CCCC00;
			bb.size = 59204;
			bb.name = "Public";
			
			var c:NodeSprite = tree.addChild(root);
			//c.fillColor = 0x88CCCC00;
			c.size = 1;
			c.name = "autoexec.bat";
			
			var d:NodeSprite = tree.addChild(root);
			//d.fillColor = 0x88CCCC00;
			d.size = 2096696;
			d.name = "pagefile.sys";
			
			
//			var aa:NodeSprite = tree.addChild(a);
//			aa.size = 6;
//			aa.name = "testing";
//			var ab:NodeSprite = tree.addChild(a);
//			ab.size = 2;
//			ab.name = "testing";
//			var ac:NodeSprite = tree.addChild(a);
//			ac.size = 1;
//			ac.fillColor = 0x88CCCC00;
//			ac.name = "testing";
//			var aca:NodeSprite = tree.addChild(ac);
//			aca.size = 3;
//			aca.name = "testing";
//			aca.fillColor = 0x88CCCC00;
			
//			var c:NodeSprite = tree.addChild(root);
//			var ca:NodeSprite = tree.addChild(c);
//			ca.size = 3;
//			ca.name = "testing";
			
			
			
			
//			var data:Data = diamondTree(3,5,4);
//			
//			for (var j:int=0; j<data.nodes.length; ++j) {
//				data.nodes[j].data.label = String(j);
//				data.nodes[j].buttonMode = true;
//			}
//			data.nodes.sortBy("depth");
			
//			tree.root = data.addNode({name:"flare", size:0});
//			map.flare = tree.root;

			
			
			
//			var data:Data = new Data();
//			data.addNode({name:"test1", size:1});
//			data.addNode({name:"test2", size:2});
//			data.addNode({name:"test3", size:3});
			
//			var data:Array = [
//				{id:"Q1", sales:10000, profit:2400},
//				{id:"Q2", sales:12000, profit:2900},
//				{id:"Q3", sales:15000, profit:3800},
//				{id:"Q4", sales:15500, profit:3900}
//			];
			
			
//			data.tree = tree;
			return tree;

		}
		
		public static function diamondTree(b:int, d1:int, d2:int) : Tree
		{
			var tree:Tree = new Tree();
			var n:NodeSprite = tree.addRoot();
			var l:NodeSprite = tree.addChild(n);
			var r:NodeSprite = tree.addChild(n);
			
			deepHelper(tree, l, b, d1-2, true);
			deepHelper(tree, r, b, d1-2, false);
			
			while (l.firstChildNode != null)
				l = l.firstChildNode;
			while (r.lastChildNode != null)
				r = r.lastChildNode;
			
			deepHelper(tree, l, b, d2-1, false);
			deepHelper(tree, r, b, d2-1, true);
			
			return tree;
		}
		
		private static function deepHelper(t:Tree, n:NodeSprite,
										   breadth:int, depth:int, left:Boolean) : void
		{
			var c:NodeSprite = t.addChild(n);
			if (left && depth > 0)
				deepHelper(t, c, breadth, depth-1, left);
			
			for (var i:uint = 1; i<breadth; ++i) {
				c = t.addChild(n);
			}
			
			if (!left && depth > 0)
				deepHelper(t, c, breadth, depth-1, left);
		}
		
		
	}
}