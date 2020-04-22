package util;

class Cooldown {
	static var CD:Array<Cd> = new Array<Cd>();

	static public function updateAll(dt:Float) {
		for (c in CD) {
			c.update(dt);
		}
	}

	static public function remove(c:Cd) {
		CD.remove(c);
	}

	static public function push(c:Cd) {
		CD.push(c);
	}

	static public function add(name:String, time:Float) {
		new Cd(name, time);
	}

	static public function isAlive(name:String) {
		for (elem in CD) {
			if (elem.name == name)
				return true;
		}
		return false;
	}
}

class Cd {
	public var name:String;

	var time:Float;

	public function update(dt:Float) {
		this.time -= dt;
		if (this.time <= 0) {
			Cooldown.remove(this);
		}
	}

	public function new(n:String, t:Float) {
		this.name = n;
		this.time = t;
		Cooldown.push(this);
	}
}
