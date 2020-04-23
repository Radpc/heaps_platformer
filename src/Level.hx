import h2d.Object;
import h2d.Scene;

class Level extends Scene {
	// My entities
	var entitiesArray:Array<Entity> = new Array<Entity>();

	// My UI
	var uiArray:Array<UI> = new Array<UI>();

	// My Camera
	var camera:Camera;

	public function addInCamera(obj:Object) {
		this.camera.addChild(obj);
	}

	public function removeInCamera(obj:Object) {
		this.camera.removeChild(obj);
	}

	public function new() {
		super();
		this.camera = new Camera(this);
	}

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

		this.camera.update(dt);
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

class Camera extends Object {
	public var viewX(get, set):Float;
	public var viewY(get, set):Float;

	var following:Entity;
	var whatToDo:Float->Void;

	var level:Level;

	public function new(level:Level) {
		super(level);
		this.level = level;
		this.whatToDo = updNothing;
	}

	private function set_viewX(value:Float):Float {
		this.x = 0.5 * level.width - value;
		return value;
	}

	private function get_viewX():Float {
		return 0.5 * level.width - this.x;
	}

	private function set_viewY(value:Float):Float {
		this.y = 0.5 * level.height - value;
		return value;
	}

	private function get_viewY():Float {
		return 0.5 * level.height - this.y;
	}

	public function update(dt:Float) {
		whatToDo(dt);
	}

	public function setFollow(e:Entity) {
		this.following = e;
		this.whatToDo = updFollowEntity;
	}

	public function updNothing(dt:Float) {}

	function updFollowEntity(dt:Float) {
		if (following != null) {
			viewX = following.x;
			viewY = following.y;
		} else {
			this.whatToDo = updNothing;
		}
	}
}
