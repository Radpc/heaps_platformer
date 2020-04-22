package level;

import hxd.Event;
import entity.Hero;
import Collideable;

class FirstLoad extends Level {
	var myButton:ui.Button;
	var hero:Hero;
	var wall:Collideable;
	var wall2:Collideable;

	public function new() {
		super();

		hero = new Hero(50, 300, this);
		wall = new Collideable(10, 400, 500, 100, 0, 0, Solid, true, null, this);
		wall2 = new Collideable(300, 300, 50, 100, 0, 0, Solid, true, null, this);

		addEventListener(myListener);
	}

	function myListener(f:Event):Void {
		if (f.kind == EKeyDown && f.keyCode == hxd.Key.ESCAPE) {
			hxd.System.exit();
		}

		if (f.kind == EPush && f.button == 0) {
			this.hero.setPosition(hxd.Window.getInstance().mouseX, hxd.Window.getInstance().mouseY);
		}
	}
}
