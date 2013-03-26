package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Color;
	import starling.utils.deg2rad;
	
	/** The Game class represents the actual game. In this scaffold, it just displays a 
	 *  Starling that moves around fast. When the user touches the Starling, the game ends. */ 
	public class Game extends Sprite
	{
		public static const GAME_OVER:String = "gameOver";
		private var board:Array;
		//private var turn:int = 1;
		//public var shape:Shape = new Shape();
		//public var basew:int = 100;
		//public var basen:int = 4;
		//private var mBird:Image;
		public var piecebaseTexture:Texture;
		public var piece1Texture:Texture;
		public var piece2Texture:Texture;
		public var player1:Boolean = true;
		public var legend1:TextField;
		public var legend2:TextField;
		public var playe1Score:Number =0;
		public var playe2Score:Number =0;
		public var player1Moves:Array = [];
		public var player2Moves:Array = [];
		public var limit:int = 4;
		public var total:int = 0;
		public var menuContainer:starling.display.Shape = new starling.display.Shape();
		public var innerContainer:starling.display.Shape = new starling.display.Shape();
		
		public var moves:Array = [];
		public var pieces:Array = [];
		
		public var GAMESTATE:int = -1;
		
		public var playerCpu:int = 2;
		public var playerHuman:int = 1;
		
		public var currentPlayer:int = 1;
		public var mainBoard:Board;
		public var playervscpu:Boolean = true;
		public var glow_red:BlurFilter = BlurFilter.createGlow(0xff0000,5,5,0.1);
		public var glow_blue:BlurFilter = BlurFilter.createGlow(0x0000ff,5,5,0.1);
		public var restartButton:Button;
	
		public function Game()
		{
			//init();
			//init();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//addEventListener(TouchEvent.TOUCH, onTouch);
			//addEventListener(Event.TRIGGERED, onTriggered);
			setInterval(update,1000);
			
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
			trace('restart');		
			//var piecebaseBitmap:Bitmap = new TikiTapToe.Piece0Texture();
			var upState:Texture = piecebaseTexture;//Texture.fromBitmap(piecebaseBitmap);
			//for each(var m:Move in mainBoard.moves) {
			//	m.upState = upState;
			//	m.player = 0;
			//}
			innerContainer.graphics.clear();
			//innerContainer.addChild(boardImage);
			mainBoard = new Board(piecebaseTexture);
			innerContainer.removeChildren();
			for each (var m:Move in mainBoard.moves){
				m.play();
				innerContainer.addChild(m);
			}
			//mainBoard.GAMESTATE = -1;
			//mainBoard.current = [];
			//mainBoard.lastMove = {1:null,2:null};
			legend1.text = "0";
			legend2.text = "0";
			
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//makeThresholdFilter();
			init();
			//addFilter();			
			//addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function init():void
		{
			
			var color:uint = Math.random() * 0xFFFFFF;
			// set color fill
				
			
			
			total = limit * limit;
			
			restartButton = new Button(Root.assets.getTexture("button_normal"), "Restart");
			restartButton.fontName = "Ubuntu";
			restartButton.fontSize = 16;
			restartButton.x = int((Constants.STAGE_WIDTH - restartButton.width) / 2);
			restartButton.y = Constants.STAGE_HEIGHT * 0.60;
			restartButton.addEventListener(Event.TRIGGERED, restartGame);

			
			legend1 = new TextField(100, 100, "0", "Arcade", 38, 0xff0000);
			legend2 = new TextField(100, 100, "0", "Arcade", 38, 0x0000ff);
			
			legend1.x = 0;
			legend2.x = 370;
			
			addChild(legend1);
			addChild(legend2);
			var boardBitmap:Bitmap = new TikiTapToe.BoardTexture(); 			
			/*var boardImage:Image = new Image(Texture.fromBitmap(boardBitmap));			
			
			boardImage.width = 300;
			boardImage.height = 300;
			
			boardImage.x = mainBoard.width - boardImage.width >> 1;
			boardImage.y = mainBoard.width - boardImage.height >> 1;
			*/
			var shapee:flash.display.Shape = new flash.display.Shape();
			shapee.graphics.beginFill(Color.MAROON);
			shapee.graphics.drawCircle(50, 50, 30);
			shapee.graphics.endFill();
			
			var bmpData:BitmapData = new BitmapData(100, 100, true, 0x0);
			bmpData.draw(shapee);
			
			piecebaseTexture = Texture.fromBitmapData(bmpData);
			//var image:Image = new Image(texture);
			//addChild(image);
			mainBoard = new Board(piecebaseTexture);
			 
			//shape.filters = [ new DropShadowFilter() ];
			//var piecebaseBitmap:Bitmap = 
			//var piecebaseBitmap:Bitmap = new TikiTapToe.Piece0Texture();
			
			var piece1Bitmap:Bitmap = new TikiTapToe.Piece1Texture();
			piece1Texture = Texture.fromBitmap(piece1Bitmap);
			
			var piece2Bitmap:Bitmap = new TikiTapToe.Piece2Texture();
			piece2Texture = Texture.fromBitmap(piece2Bitmap);

			var quad:Quad = new Quad(mainBoard.width, mainBoard.height, 0xffffff);

			menuContainer.addChild(quad);
			
			
			
			innerContainer.width = mainBoard.width;
			innerContainer.height = mainBoard.height;
			

			menuContainer.width = mainBoard.width;
			menuContainer.height =  mainBoard.height;
			
			menuContainer.x = Constants.STAGE_WIDTH - menuContainer.width >> 1;
			menuContainer.y = Constants.STAGE_HEIGHT - menuContainer.height >> 1;

			
			menuContainer.graphics.lineStyle(12,color);
			menuContainer.graphics.moveTo(0, mainBoard.height * 0.5);
			menuContainer.graphics.lineTo(0, mainBoard.height);
			menuContainer.graphics.lineTo(mainBoard.width * 0.5, mainBoard.height);
			menuContainer.graphics.moveTo(mainBoard.width * 0.5, 0);
			menuContainer.graphics.lineTo(mainBoard.width, 0);
			menuContainer.graphics.lineTo(mainBoard.width, mainBoard.height * 0.5);
			
			for each (var m:Move in mainBoard.moves){
				//m.play();
				innerContainer.addChild(m);
			}
			
			//innerContainer.addChild(quad);
			
			
			menuContainer.addChild(innerContainer);
			
			addChild(menuContainer);
			innerContainer.addEventListener(Event.TRIGGERED, onTriggered);
			//basew = Constants.STAGE_WIDTH / basen;
		}
		
		public function drawLine(m:Move):void {
			var last:Move = mainBoard.GetLastMove(m.player);
			if (last) {
				trace('move from: x'+last.x+' y'+last.y);
				trace('move to: x'+m.x+' y'+m.y);
				var color:uint = 0xff0000;
				if (m.player == 2) 
					color = 0x0000ff;	
				var middle:Number = last.width * 0.5;
				
				trace(last.width);
				
				var p1:Point = new Point(last.x+middle,last.y+middle);
				var p2:Point = new Point (m.x+middle,m.y+middle);
				//var p3:Point; //= p1.subtract(p2);
				var n:Number = Point.distance(p1,p2);
				trace('pont:'+n);
				if (n == last.width) { 
					innerContainer.graphics.lineStyle(12,color);
					innerContainer.graphics.moveTo(last.x+middle, last.y+middle);
					innerContainer.graphics.lineTo(m.x+middle, m.y+middle);
				}
				//shape.filter = new BlurFilter(5,5,1);
			}
			
		}
		
		
		private function onTriggered(e:Event):void
		{
			if (e.target is Move) {
				Move(e.target).stop();
				//check(e.target as Move);
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
						//computerMove();
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
				trace("player: "+player + " m:"+m.position);
				if (m.position == newMove.position) {
					trace("valid move: " + m.position);
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
				if (intersec.length > 0) {
					r = int(Math.random() * intersec.length);
					bestMove = intersec[r];
					var tt:Object = Minimax(TestTable, bestMove, Number.MIN_VALUE, Number.MAX_VALUE, playerCpu);
					bestMove = tt.move;
				} else {
					//r = int(Math.random() * currentMoves.length);	
					//bestMove = currentMoves[r];
					minimaxcounter = 0;			
					var tt:Object = Minimax(TestTable, bestMove, Number.MIN_VALUE, Number.MAX_VALUE, playerCpu);
					bestMove = tt.move;
					var s:Number = tt.minimax;
				}
			}
						
			
			
			/*
			if (chComputer == m_chComputer)
			{
			texture = m_Tex_O;
			sound = m_soundO;
			}
			else
			{
			texture = m_Tex_X;
			sound = m_soundX;
			}
			*/
			//spriteMark.Load(texture, m_frameSize, new Point(2, 1),sound:sound);
			//bestMove.m_sprite = spriteMark;
			//Debug.WriteLine("bestMove {0}x{1} score: {2}", bestMove.m_nX, bestMove.m_nY, s);
			/*
			for each(var m:Move in TestTable.moves){
				if (m.position == bestMove.position){
					bestMove = m;
					break;
				}
			}
			
			bestMove.upState = (bestMove.player == 1) ? piece1Texture : piece2Texture;
			mainBoard.ApplyMove(bestMove);
			*/
			if (bestMove) {
				PlayerMove(playerCpu,bestMove);
			}  
			
			if (mainBoard.GetAvailableMoves(1).length == 0 && mainBoard.GetAvailableMoves(2).length != 0) {
				computerMove();
			}
			
			//else {
			//	computerMove();
			//}
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
			
			//var lMoves:Array = [];
			//lMoves = TestTable.GetAvailableMoves(chPlayer);
			
			for each (var move:Move in TestTable.GetAvailableMoves(chPlayer))
			{
				//var TestTable2:Board = new Board();
				//TestTable2.clone(TestTable);
				
				TestTable.ApplyMove(move);
				
				var tt:Object = Minimax(TestTable, TmpMove, -beta, -alpha, opponent, depth + 1);
				alpha = -tt.minimax;
				TmpMove = tt.move;
				trace('pos: '+move.position,'a: '+alpha,'depth: '+depth,'player: '+chPlayer,'state: '+TestTable.GAMESTATE,'counter: '+minimaxcounter);
				//if (minimaxcounter > 1000){
				//	return {minimax: bestResult, move: best};
				//}
				//Debug.WriteLine("move: {0}x{1} alpha: {2} depth: {3} player: {4} state: {5}",move.m_nX,move.m_nY,alpha,depth,chPlayer,TestTable2.m_eState);
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
		
		
		
		
		/*
		private function checkValidMove(move:Move):Array {
			var validMoves:Array = [];
			for (var i:int = 0; i < pieces.length; i++){				
				var button:Move = pieces[i] as Move;
				trace (button.valid);
				var m:int = move.valid.indexOf(button.label);
				if (m  > -1) {
					if (button.player == 0) {
						trace(button);				
						validMoves.push(button);
					} else {
						move.valid.splice(m,1);
						trace('remove');
					}
				}
				//trace(button.upState == piece1Texture);
			}
			return validMoves;
			//for each(button in validMoves){				
			//	button.play();
			//}
		}*/
		
	}
}