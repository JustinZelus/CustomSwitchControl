# CustomSwitchControl

## OvierView
`JZMaterialSwitch`  is google'a material design like switch UI with animation features.
This library has cool and sophisticated animations, ripple effect and bounce effect.

<br/>
<br/>

## Usage

The simplest setup:

```Swift
let androidSwitchSmall = JZMaterialSwitch(withSize: .normal, state: JZMaterialSwitchState.on)
self.androidSwitchSmall.delegate = self
self.view.addSubview(androidSwitchSmall)
```

This is ths simplest and easiest initailization.
The style, size and initial state of  `JZMaterialSwitch`  instance is set to all default value as shown below.

### Customize Behaviors
JZMaterialSwitch has many prameters to customize behaviors as you like.

#### Style and size
```
//MARK: - Initial JZMaterialSwitch size (big, normal, small)
public enum MJMaterialSwitchSize {
case big, normal, small
}
```
## Author
Justin Zelus <justin.qian.v@gmail.com>







