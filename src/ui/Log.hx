package ui;

import h2d.Font;
import h2d.Text;

class Log extends Text implements UI {
	public var ACTIVE:Bool = false;

	var customFont:Font;
	var messageArray:Array<String>;
	var messageHeight:Int;
	var level:Level;

	final paddingBottom:Int = 5;
	final paddingLeft:Int = 10;
	final maxSize:Int = 4;

	override public function new(level:Level) {
		this.customFont = hxd.res.DefaultFont.get();
		super(customFont, level);
		this.level = level;

		text = 'Log is ready';

		this.messageArray = new Array<String>();
		this.textAlign = Left;
		this.color = new h3d.Vector(0.9, 0.9, 0.9);

		this.onResize();
	}

	public function add(message:String) {
		if (this.messageArray.length >= this.maxSize) {
			this.messageArray.shift();
		}

		var timestamp:String = DateTools.format(Date.now(), '[%H:%M:%S] - ');

		this.messageArray.push(timestamp + message);

		this.renderText();
	}

	function renderText() {
		this.text = '';

		for (msg in this.messageArray) {
			this.text += msg + '\n';
		}
		this.text = this.text.substr(0, -1);
		this.onResize();
	}

	public function onResize() {
		this.messageHeight = Math.round(get_textHeight());

		this.x = paddingLeft;
		this.y = hxd.Window.getInstance().height - paddingBottom - this.messageHeight;
	}

	public function onDelete() {
		this.level.removeUI(this);
	}

	public function update(dt:Float) {}
}
