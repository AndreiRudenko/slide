# Slide

A lightweight and flexible tweening library for Haxe.

## Key Features

- **Framework-Agnostic**
- **Parallel and Sequential Tweens**
- **Customizable Easing Functions**
- **Powered by macros, no Haxe Reflect**

## Installation

Install the library via `haxelib`:

```sh
haxelib install slide
```

Alternatively, clone the repository for the latest version:

```sh
git clone https://github.com/AndreiRudenko/slide
```

## Usage Examples

### Basic Tweening

Animate an object property to a target value:

```haxe
tweenManager.animateTo(myVec2, { x: 100 }, 1).start();
```

### Tween Multiple Properties

Animate multiple properties simultaneously:

```haxe
tweenManager.animateTo(myVec2, { x: 100, y: 100 }, 1).start();
```

### Custom Easing Functions

Apply easing with built-in or custom functions:

```haxe
tweenManager.animateTo(myVec2, { x: 100 }, 1, Quad.easeOut).start();
tweenManager.animateTo(myVec2, { x: 100 }, 1, (t: Float) -> t * t).start();
```

### Callbacks

Set up callbacks for various tweening events:

```haxe
tweenManager.animateTo(myVec2, { x: 100 }, 1)
    .onStart(() -> trace("start"))
    .onStop(() -> trace("stop"))
    .onReset(() -> trace("reset"))
    .onPause(() -> trace("pause"))
    .onResume(() -> trace("resume"))
    .onRepeat(() -> trace("repeat"))
    .onComplete(() -> trace("complete"))
    .onUpdate(() -> trace("update"))
    .start();
```

### Tween Sequences

Chain animations sequentially:

```haxe
tweenManager.sequence([
    tweenManager.animateTo(myVec2, { x: 100 }, 1),
    tweenManager.animateTo(myVec2, { y: 100 }, 1)
]).start();
```

### Parallel Tweens

Run multiple tweens concurrently:

```haxe
tweenManager.parallel([
    tweenManager.animateTo(myVec2, { x: 100 }, 1),
    tweenManager.animateTo(myVec2, { y: 100 }, 1)
]).start();
```

### Advanced Tweens

- **Tween from Target Value:**

```haxe
tweenManager.animateFrom(myVec2, { x: 0 }, 1).start();
```

- **Tween Between Two Values:**

```haxe
tweenManager.animateFromTo(myVec2, { x: 0 }, { x: 100 }, 1).start();
```

- **Tween by Adding Value to Property:** Example: target value for x is current x + 100

```haxe
tweenManager.animateBy(myVec2, { x: 100 }, 1).start();
```

- **Tween Along a Set of Values:**

```haxe
tweenManager.animateAlong(myVec2, { x: [100, 200], y: [200, 300, 100, 500] }, 1).start();
```

### Delay

**You can add a delay as a simple timer:**

```haxe
tweenManager.delay(1, () -> trace("delay complete")).start();
```

**Or add a delay to a sequence:**

```haxe
tweenManager.sequence([
    tweenManager.animateTo(myVec2, { x: 100 }, 1),
    tweenManager.delay(1),
    tweenManager.animateTo(myVec2, { y: 100 }, 1)
]).start();
```

### Control Tweens

Pause, resume, stop, or reset tweens as needed:

```haxe
var tween = tweenManager.animateTo(myVec2, { x: 100 }, 1);
tween.start();
tween.pause();
tween.resume();
tween.stop();
tween.reset();
```

### Looping and Yoyo

- **Infinite or Finite Loops:** Less than 0 or no argument for infinite loop

```haxe
tweenManager.animateTo(myVec2, { x: 100 }, 1).repeat(3).start();
```

- **Yoyo Animation:**

```haxe
tweenManager.animateTo(myVec2, { x: 100 }, 1).yoyo().start();
```
