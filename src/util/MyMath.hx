package util;

class MyMath {
	static public function clamp(value:Float, max:Float) {
		if (value < -max) {
			return -max;
		} else {
			if (value > max) {
				return max;
			} else {
				return value;
			}
		}
	}

	static public function decreaseAbs(value:Float) {
		if (value > 0) {
			return Math.floor(value);
		} else {
			return Math.ceil(value);
		}
	}

	static public function minAbs(value:Float, value2:Float) {
		if (Math.abs(value) < Math.abs(value2)) {
			return value;
		} else {
			return value2;
		}
	}
}
