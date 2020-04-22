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

	static public function add(name:String, time:Float, ?f:Void->Void) {
		new Cd(name, time, f);
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
	var goal:Void->Void;

	public function update(dt:Float) {
		this.time -= dt;
		if (this.time <= 0) {
			if (goal != null)
				goal();
			Cooldown.remove(this);
		}
	}

	public function new(n:String, t:Float, ?goal:Void->Void) {
		this.name = n;
		this.time = t;
		Cooldown.push(this);
		if (goal != null) {
			this.goal = goal;
		}
	}
}
