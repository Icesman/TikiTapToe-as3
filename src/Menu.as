package
{
    import flash.display.BitmapData;
    import flash.display.Shape;
    
    import starling.display.Button;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.text.BitmapFont;
    import starling.text.TextField;
    import starling.textures.Texture;
    
    /** The Menu shows the logo of the game and a start button that will, once triggered, 
     *  start the actual game. In a real game, it will probably contain several buttons and
     *  link to several screens (e.g. a settings screen or the credits). If your menu contains
     *  a lot of logic, you could use the "Feathers" library to make your life easier. */
    public class Menu extends Sprite
    {
        public static const START_GAME:String = "startGame";
        
        public function Menu()
        {
            init();
        }
        
        private function init():void
        {
			var buttonShape:flash.display.Shape = new flash.display.Shape();
			buttonShape.graphics.beginFill(0x000000);
			buttonShape.graphics.drawRect(0,0,150,50);
			buttonShape.graphics.endFill();
			
			var buttonBmpData:BitmapData = new BitmapData(150, 50, true, 0x0);
			buttonBmpData.draw(buttonShape);
			
			//restartButton = new Button(Texture.fromBitmapData(buttonBmpData), "Restart");
			
            var textField:TextField = new TextField(350, 150, "Tiki Tap Toe", 
                "Arcade",24, 0x000000);
            textField.x = (Constants.STAGE_WIDTH - textField.width) / 2;
            textField.y = 60;
            addChild(textField);
            
            var button:Button = new Button(Texture.fromBitmapData(buttonBmpData), "1 Player");
            button.fontName = "Arcade";
            button.fontSize = 16;
			button.fontColor = 0xffffff;
            button.x = int((Constants.STAGE_WIDTH - button.width) / 2);
            button.y = Constants.STAGE_HEIGHT * 0.55;
            button.addEventListener(Event.TRIGGERED, function():void {
				dispatchEventWith(START_GAME, true, "single");
			});
            addChild(button);
			
			var button2:Button = new Button(Texture.fromBitmapData(buttonBmpData), "2 Players");
			button2.fontName = "Arcade";
			button2.fontSize = 14;
			button2.fontColor = 0xffffff;
			button2.x = int((Constants.STAGE_WIDTH - button2.width) / 2);
			button2.y = Constants.STAGE_HEIGHT * 0.75;
			button2.addEventListener(Event.TRIGGERED, function():void {
				dispatchEventWith(START_GAME, true, "multiplayer");
			});
			addChild(button2);
        }
        
        private function onButtonTriggered():void
        {
            dispatchEventWith(START_GAME, true, "single");
        }
    }
}