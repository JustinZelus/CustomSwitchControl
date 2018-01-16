# CustomSwitchControl

## OvierView
`JZMaterialSwitch`  is google'a material design like switch UI with animation features.
This library has cool and sophisticated animations, ripple effect and bounce effect.

## Usage

The simplest setup:

```Swift
let androidSwitchSmall = JZMaterialSwitch(withSize: .normal, state: JZMaterialSwitchState.on)
self.androidSwitchSmall.delegate = self
self.view.addSubview(androidSwitchSmall)
```

This is ths simplest and easiest initailization.
The style, size and initial state of  `JZMaterialSwitch`  instance is set to all default value as shown below.
