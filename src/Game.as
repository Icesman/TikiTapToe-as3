package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Point;

	import flash.utils.setInterval;
	import flash.utils.setTimeout;

	import starling.display.Button;

	import starling.display.Quad;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;

	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Color;

	
	/** The Game class represents the actual game. In this scaffold, it just displays a 
	 *  Starling that moves around fast. When the user touches the Starling, the game ends. */ 
	public class Game extends Sprite
	{
		public static const GAME_OVER:String = "gameOver";

		public var piecebaseTexture:Texture;
		public var piece1Texture:Texture;
		public var piece2Texture:Texture;
		public var legend1:TextField;
		public var legend2:TextField;
		public var playe1Score:Number = 0;
		public var playe2Score:Number = 0;
		public var menuContainer:starling.display.Shape = new starling.display.Shape();
		public var innerContainer:starling.display.Shape = new starling.display.Shape();
		
		public var playerCpu:int = 2;
		public var playerHuman:int = 1;
		
		public var currentPlayer:int = 1;
		public var mainBoard:Board;
		public var playervscpu:Boolean = true;
		//public var glow_red:BlurFilter = BlurFilter.createGlow(0xff0000,5,5,0.1);
		//public var glow_blue:BlurFilter = BlurFilter.createGlow(0x0000ff,5,5,0.1);
		public var restartButton:Button;
		
		public var player1Color:uint = Color.RED;
		public var player2Color:uint = Color.BLUE;
		public var baseColor:uint = Color.BLACK;
	
		public function Game()
		{

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			setInterval(update,800);
			
		}
		private function update():void {
			if (mainBoard.GAMESTATE != -1) {
				addChild(restartButton);
			} else {			
				if ((playervscpu && currentPlayer != playerCpu) || !playervscpu) {
					trace('playe cpu: '+currentPlayer);
					var currentMoves:Array = mainBoard.GetAvailableMoves(currentPlayer,false);
					for each(var m:Move in currentMoves){
						m.play();					
					}
				}
			}
		}
		
		private function restartGame():void {
			removeChild(restartButton);
			
			var upState:Texture = piecebaseTexture;
			
			innerContainer.graphics.clear();
			
			mainBoard = new Board(piecebaseTexture);
			innerContainer.removeChildren();
			for each (var m:Move in mainBoard.moves){
				m.play();
				innerContainer.addChild(m);
			}
			
			legend1.text = "0";
			legend2.text = "0";
			
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			init();
			
		}
		
		private function init():void
		{			
			//var color:uint = Math.random() * 0xFFFFFF;
			
			var buttonShape:flash.display.Shape = new flash.display.Shape();
			buttonShape.graphics.beginFill(baseColor);
			buttonShape.graphics.drawRect(0,0,Constants.BOARD_WIDTH * 0.5,Constants.BOARD_HEIGHT * 0.5);
			buttonShape.graphics.endFill();
			
			var buttonBmpData:BitmapData = new BitmapData(Constants.BOARD_WIDTH * 0.5, Constants.BOARD_HEIGHT * 0.5, true, 0x0);
			buttonBmpData.draw(buttonShape);
			
			restartButton = new Button(Texture.fromBitmapData(buttonBmpData), "Restart");
			restartButton.fontName = "Arcade";
			restartButton.fontSize = 16;
			restartButton.fontColor = 0xffffff;
			
			restartButton.addEventListener(Event.TRIGGERED, restartGame);
			
			legend1 = new TextField(100, 100, "0", "Arcade", 38, player1Color);
			legend2 = new TextField(100, 100, "0", "Arcade", 38, player2Color);
			
			legend1.x = 0;
			legend2.x = 0;
			legend2.y = legend1.y + legend2.height + 30;
			
			addChild(legend1);
			addChild(legend2);
			
			var boardBitmap:Bitmap = new TikiTapToe.BoardTexture(); 			
	
			var pieceWidth:Number = Constants.BOARD_WIDTH / Constants.BOARD_LIMIT;
			var pieceHalfWidth:Number = pieceWidth * 0.5;
			
			var shapee:flash.display.Shape = new flash.display.Shape();
			shapee.graphics.beginFill(baseColor);
			shapee.graphics.drawCircle(pieceHalfWidth, pieceHalfWidth, pieceWidth/2.5);
			shapee.graphics.endFill();
			
			var bmpData:BitmapData = new BitmapData(pieceWidth, pieceWidth, true, 0x0);
			bmpData.draw(shapee);
			
			piecebaseTexture = Texture.fromBitmapData(bmpData);
			
			mainBoard = new Board(piecebaseTexture);
			
			shapee = new flash.display.Shape();
			shapee.graphics.beginFill(player1Color);
			shapee.graphics.drawCircle(pieceHalfWidth, pieceHalfWidth, pieceWidth/2.5);
			shapee.graphics.endFill();
			bmpData = new BitmapData(pieceWidth, pieceWidth, true, 0x0);
			bmpData.draw(shapee);
			piece1Texture = Texture.fromBitmapData(bmpData);
			
			shapee = new flash.display.Shape();
			shapee.graphics.beginFill(player2Color);
			shapee.graphics.drawCircle(pieceHalfWidth, pieceHalfWidth, pieceWidth/2.5);
			shapee.graphics.endFill();
			bmpData = new BitmapData(pieceWidth, pieceWidth, true, 0x0);
			bmpData.draw(shapee);
			piece2Texture = Texture.fromBitmapData(bmpData);
			
			var quad:Quad = new Quad(mainBoard.width, mainBoard.height, 0xdfdfdf);

			menuContainer.addChild(quad);
			
			innerContainer.width = mainBoard.width;
			innerContainer.height = mainBoard.height;
			
			menuContainer.width = mainBoard.width;
			menuContainer.height =  mainBoard.height;
			
			menuContainer.x = Constants.STAGE_WIDTH - menuContainer.width >> 1;
			menuContainer.y = Constants.STAGE_HEIGHT - menuContainer.height >> 1;
			
			restartButton.x = Constants.STAGE_WIDTH - restartButton.width >> 1;
			restartButton.y = Constants.STAGE_HEIGHT - restartButton.height >> 1;
			
			menuContainer.graphics.lineStyle(16,baseColor);
			menuContainer.graphics.moveTo(0, mainBoard.height * 0.5);
			menuContainer.graphics.lineTo(0, mainBoard.height);
			menuContainer.graphics.lineTo(mainBoard.width * 0.5, mainBoard.height);
			menuContainer.graphics.moveTo(mainBoard.width * 0.5, 0);
			menuContainer.graphics.lineTo(mainBoard.width, 0);
			menuContainer.graphics.lineTo(mainBoard.width, mainBoard.height * 0.5);
			
			for each (var m:Move in mainBoard.moves){
				innerContainer.addChild(m);
			}
			
			menuContainer.addChild(innerContainer);
			
			addChild(menuContainer);
			innerContainer.addEventListener(Event.TRIGGERED, onTriggered);
		}
		
		public function drawLine(m:Move):void {
			var last:Move = mainBoard.GetLastMove(m.player);
			if (last) {
				
				var color:uint = player1Color;
				if (m.player == 2) 
					color = player2Color;	
				var middle:Number = last.width * 0.5;

				var p1:Point = new Point(last.x+middle,last.y+middle);
				var p2:Point = new Point (m.x+middle,m.y+middle);
				var n:Number = Point.distance(p1,p2);
				
				if (Math.round(n) == Math.round(last.width)) { 
					innerContainer.graphics.lineStyle(30,color);
					innerContainer.graphics.moveTo(last.x+middle, last.y+middle);
					innerContainer.graphics.lineTo(m.x+middle, m.y+middle);
				}
			}
			
		}
		
		
		private function onTriggered(e:Event):void
		{
			if (e.target is Move) {
				Move(e.target).stop();
				var moves:Array = mainBoard.GetAvailableMoves(currentPlayer,false);
				if (moves.length == 0) {
					if (!playervscpu) {
						currentPlayer = (currentPlayer == 1) ? 2 : 1;
						moves = mainBoard.GetAvailableMoves(currentPlayer,false);
					} else {
						return;
					}
				}
				
				for each(var m:Move in moves){
					if (m.position == Move(e.target).position) {
						PlayerMove(currentPlayer,e.target as Move);
						if (playervscpu) {
							setTimeout(computerMove,500);
						}
						break;
					}
				}
			}
		}
		
		public function PlayerMove(player:int,newMove:Move):void {			
			
			var moves:Array = mainBoard.GetAvailableMoves(player,false);
			if (moves.length == 0) {
				if (!playervscpu) {
					currentPlayer = (currentPlayer == 1) ? 2 : 1;
				}
				return;
			}
			
			for each(var m:Move in moves){
				if (m.position == newMove.position) {
					m.player = player;
					m.upState = (player == 1) ? piece1Texture : piece2Texture;		
					drawLine(m);
					mainBoard.ApplyMove(m);	
					
					if (!playervscpu) {
						currentPlayer = (currentPlayer == 1) ? 2 : 1;
					}
					break;
				}
			}
			
			var score:Array = mainBoard.getScore();
			
			legend1.text = score[1].toString();
			legend2.text = score[2].toString();
			
		}

		private var minimaxcounter:int;
		private function computerMove():void {
			var TestTable:Board = new Board(piecebaseTexture);
			TestTable.clone(mainBoard);
			
			var bestMove:Move;
			var currentMoves:Array = mainBoard.GetAvailableMoves(2);
			var currentMovesPlayer:Array = mainBoard.GetAvailableMoves(1);
			var intersec:Array = [];
			if (currentMoves.length == 1) {
				bestMove = currentMoves[0];		
			} else if (currentMoves.length + 1 == mainBoard.totalMoves) {
				r = int(Math.random() * currentMoves.length);	
				bestMove = currentMoves[r];			
			} else {
				for each(var m:Move in currentMovesPlayer){
					for each(var mm:Move in currentMoves) {
						if (mm.position == m.position){
							intersec.push(mm);
						}
					}
				}
				var r:int;
				var tt:Object;
				if (intersec.length > 0) {
					r = int(Math.random() * intersec.length);
					bestMove = intersec[r];
					tt = Minimax(TestTable, bestMove, Number.MIN_VALUE, Number.MAX_VALUE, playerCpu);
					bestMove = tt.move;
				} else {
					minimaxcounter = 0;			
					tt = Minimax(TestTable, bestMove, Number.MIN_VALUE, Number.MAX_VALUE, playerCpu);
					bestMove = tt.move;
					var s:Number = tt.minimax;
				}
			}
			
			if (bestMove) {
				PlayerMove(playerCpu,bestMove);
			}  
			
			if (mainBoard.GetAvailableMoves(1).length == 0 && mainBoard.GetAvailableMoves(2).length != 0) {
				computerMove();
			}

		}
		
		public function Minimax(TestTable:Board, best:Move, alpha:Number, beta:Number, chPlayer:int, depth:int = 5) :Object
		{
			minimaxcounter++;
			var opponent:int = (chPlayer == playerCpu) ? playerHuman : playerCpu;
			
			best = null;
			var bestResult:Number = -20.0;
			var TmpMove:Move;
			
			if (TestTable.GAMESTATE != -1)
			{
				var a:Number = TestTable.EvaluateTable(chPlayer) / depth;
				return {minimax: a, move: best};
			}
						
			for each (var move:Move in TestTable.GetAvailableMoves(chPlayer))
			{
				//var TestTable2:Board = new Board();
				//TestTable2.clone(TestTable);
				
				TestTable.ApplyMove(move);
				
				var tt:Object = Minimax(TestTable, TmpMove, -beta, -alpha, opponent, depth + 1);
				alpha = -tt.minimax;
				TmpMove = tt.move;
				//trace('pos: '+move.position,'a: '+alpha,'depth: '+depth,'player: '+chPlayer,'state: '+TestTable.GAMESTATE,'counter: '+minimaxcounter);
				
				if (beta <= alpha)
				{
					return {minimax: alpha, move: move};
				}
				if (alpha > bestResult)
				{
					best = move;
					bestResult = alpha;
				}
			}
			return {minimax: bestResult, move: best};
		}

		
	}
}