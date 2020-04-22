package scenes;

import hxd.Key;
import h3d.Engine;
import h2d.Scene;

class SecondScreen extends Scene {
	var myButton:ui.Button;

	public function new() {
		super();
		myButton = new ui.Button('Hello HERE!', this, function(e:hxd.Event) {});

		hxd.Window.getInstance().addEventTarget(event -> {
			switch (event.kind) {
				case EKeyDown:
					myButton.text = 'You pressed ${event.keyCode}';
					if (event.keyCode == Key.UP) {
						myButton.y -= 5;
					}
				case _:
			}
		});
	}

	override function render(engine:Engine) {
		super.render(engine);
	}
}
