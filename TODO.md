
# ToDo

- [x] Rename `InheritedSettings` to `Defaults`
- [x] ActionButton refactor - rename current default constructor to `.custom(...)`, add new default constructor with `Future onAction` parameter
  - [x] Default constructor: `ActionButton(onAction: Future Function(), ...)`
  - [x] Custom constructor: `ActionButton.custom(onPressed: Function, inProgress: bool)`
- [x] ButtonsGroup https://gist.github.com/andyduke/718c503e4d614bb61bb8cc6e93f033d9
- [ ] CustomTabBar
- [x] ColorSet
- [x] StateProperty
- [ ] AuthScaffold?
- [x] LabeledContent
- [x] CustomAppBar https://gist.github.com/andyduke/3360de741a36a280a77e2da922c95883
- [x] CustomBottomBar https://gist.github.com/andyduke/3360de741a36a280a77e2da922c95883
- [x] AsyncSnapshot when extension https://gist.github.com/andyduke/aee33c192dcb8df58d8fbbb75459d6e0
- [x] EventBus https://gist.github.com/andyduke/d93f24815cfee30dbb8861b75ee1dbc0 https://github.com/marcojakob/dart-event-bus/blob/master/lib/event_bus.dart
- [ ] ListViewBuilder
- [ ] DataValue (alternate to Result?) https://gist.github.com/andyduke/06c7a240c8360201b91e17e11e3ccdb9

- [ ] GenericDropdown refactor with OverlayPortal https://gist.github.com/andyduke/9124e2a79bde9c1ad48e82487e0c9a86

- [ ] DateTime.format extension


## Documentation

### Widgets

- [ ] GenericControl
- [ ] GenericDropdown
- [ ] ButtonsGroup
- [ ] Label
- [ ] LabeledContent
- [ ] VStack/HStack/Spacing
- [ ] GlobalShortcuts
- [ ] Result use cases https://gist.github.com/andyduke/b06a6b71203972a5332e6c2f7724bb93
- [ ] CustomAppBar
- [ ] CustomBottomBar
- [ ] AsyncSnapshot when extension


### General

- [ ] Add examples for each widget
- [ ] README refactor:
      in the README, leave only a list of widgets with a brief description, move more detailed descriptions and examples into separate files
