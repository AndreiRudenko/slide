## Slide  
Tween library for Haxe

## Features
* Framework agnostic.
* Callbacks on start/stop/complete/update/repeat/pause/unpause.
* Macro-powered, no haxe Reflect.
* Chaining tween actions.

## example  
```haxe

Slide.tween(point)
    .to({x:100}, 0.5)
    .to({y:200}, 1)
    .wait(0.5)
    .to({x:0}, 0.5)
    .ease(slide.easing.Quad.easeIn)
    .onComplete(foo)
    .start();

Slide.fun(foo)
    .update(1, [0, 0], [128, 64])
    .ease(slide.easing.Expo.easeIn)
    .repeat()
    .start();

Slide.tween(point)
    .to({x:100, y:100}, 1)
    .start()
    .then(
        // starts automaticaly after current is finished
        Slide.tween(point2).to({x:200, y:200}, 1) 
    );

var t = Slide.tween([point, point2])
    .to({x:100, y:100}, 1)
    .wait(1)
    .mt('set', [0, 64]);
t.start();

//...
Slide.step(dt);

```

