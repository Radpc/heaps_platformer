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

		hero = new Hero(50, 100, this);
		wall = new Collideable(10, 200, 500, 10, 0, 0, Solid, true, null, this);
		wall2 = new Collideable(300, 180, 210, 20, 0, 0, Solid, true, null, this);
		this.camera.setFollow(hero);

		addEventListener(myListener);
	}

	function myListener(f:Event):Void {
		if (f.kind == EKeyDown && f.keyCode == hxd.Key.Q)
			hxd.System.exit();

		if (f.kind == EPush && f.button == 0)
			this.hero.setPosition(mouseX, mouseY);

		if (f.kind == EKeyDown && f.keyCode == hxd.Key.C) {
			for (elem in Collideable.ALL) {
				elem.toggleDebug();
			}
			Game.LOG.add('Toggled Debug');
		}
	}
}
