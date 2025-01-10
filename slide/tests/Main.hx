package ;

import haxe.unit.TestRunner;

class Main {

	public static function main() {
		var runner = new TestRunner();

		runner.add(new TestTweenSingle());
		runner.add(new TestTweenAnimateTo());
		runner.add(new TestTweenAnimateFrom());
		runner.add(new TestTweenAnimateFromTo());
		runner.add(new TestTweenAnimateBy());
		runner.add(new TestTweenAnimateAlong());

		runner.add(new TestTweenSequence());
		runner.add(new TestTweenAnimateSequence());

		runner.add(new TestTweenParallel());
		runner.add(new TestTweenAnimateParallel());
		
		runner.add(new TestTweenManager());
		runner.run();
	}

}