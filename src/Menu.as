package
{
    import starling.display.Button;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.text.BitmapFont;
    import starling.text.TextField;
    
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
            var textField:TextField = new TextField(350, 150, "Tiki Tap Toe", 
                "Arcade",24, 0x000000);
            textField.x = (Constants.STAGE_WIDTH - textField.width) / 2;
            textField.y = 50;
            addChild(textField);
            
            var button:Button = new Button(Root.assets.getTexture("button_normal"), "1 Player");
            button.fontName = "Arcade";
            button.fontSize = 16;
            button.x = int((Constants.STAGE_WIDTH - button.width) / 2);
            button.y = Constants.STAGE_HEIGHT * 0.60;
            button.addEventListener(Event.TRIGGERED, function():void {
				dispatchEventWith(START_GAME, true, "single");
			});
            addChild(button);
			
			var button2:Button = new Button(Root.assets.getTexture("button_normal"), "2 Players");
			button2.fontName = "Arcade";
			button2.fontSize = 12;
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