import h2d.Scene;

class Level extends Scene {
	// My entities
	var entitiesArray:Array<Entity> = new Array<Entity>();

	// My resizers
	var resizeArray:Array<Resizeable> = new Array<Resizeable>();

	// Resizers
	public function addResizeable(r:Resizeable) {
		this.resizeArray.push(r);
	}

	public function removeResizeable(r:Resizeable) {
		this.resizeArray.remove(r);
	}

	public function resizeAll() {
		for (r in this.resizeArray) {
			r.onResize();
		}
	}

	public function updateAll(dt:Float) {
		for (u in this.entitiesArray) {
			u.update(dt);
		}
	}

	function deleteAll() {
		for (u in this.entitiesArray) {
			u.delete();
		}

		for (r in this.resizeArray) {
			resizeArray.remove(r);
		}
	}

	public function addEntity(e:Entity) {
		this.entitiesArray.push(e);
	}

	public function removeEntity(e:Entity) {
		this.entitiesArray.remove(e);
	}

	public function delete() {
		this.deleteAll();
		this.remove();
	}
}
