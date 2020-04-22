import h2d.Scene;

class Level extends Scene {
	// My entities
	var entitiesArray:Array<Entity> = new Array<Entity>();

	// My UI
	var uiArray:Array<UI> = new Array<UI>();

	public function addUI(r:UI)
		this.uiArray.push(r);

	public function removeUI(r:UI)
		this.uiArray.remove(r);

	public function addEntity(e:Entity)
		this.entitiesArray.push(e);

	public function removeEntity(e:Entity)
		this.entitiesArray.remove(e);

	public function delete() {
		for (ev in eventListeners)
			eventListeners.remove(ev);

		this.deleteAll();
		this.remove();
	}

	public function resizeAll()
		for (ui in this.uiArray)
			ui.onResize();

	public function updateAll(dt:Float) {
		for (e in this.entitiesArray)
			e.update(dt);
		for (ui in this.uiArray) {
			if (ui.ACTIVE) {
				ui.update(dt);
			}
		}
	}

	function deleteAll() {
		for (e in this.entitiesArray) {
			e.delete();
		}
		for (ui in this.uiArray) {
			ui.onDelete();
		}
	}
}
