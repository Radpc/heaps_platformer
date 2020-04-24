package levels;

import h2d.Text;
import hxd.Event;
import entity.Hero;
import Collideable;

class Stage1 extends Level {
	var hero:Hero;
	var hero2:Hero;
	var wall:Collideable;
	var wall2:Collideable;
	var wall3:Collideable;

	var d:Text;

	public function new() {
		super();

		hero = new Hero(50, 100, this);
		wall = new Collideable(0, 200, 500, 20, 0, 0, Solid, true, null, this);
		wall2 = new Collideable(300, 180, 200, 20, 0, 0, Solid, true, null, this);
		wall3 = new Collideable(0, 150, 20, 50, 0, 0, Solid, false, null, null, this);
		d = new Text(hxd.res.DefaultFont.get(), this);
		d.x = 5;
		d.y = 5;

		this.camera.setFollow(hero);

		addEventListener(myListener);
	}

	function myListener(f:Event):Void {
		if (f.kind == EKeyDown && f.keyCode == hxd.Key.Q)
			hxd.System.exit();

		if (f.kind == EKeyDown && f.keyCode == hxd.Key.C) {
			for (elem in Collideable.ALL) {
				elem.toggleDebug();
			}
			Game.LOG.add('Toggled Debug');
		}
	}

	override function updateAll(dt:Float) {
		super.updateAll(dt);
		this.d.text = 'DX = ' + this.hero.dx;
	}
}
