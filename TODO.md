
# ToDo

- [x] Rename `InheritedSettings` to `Defaults`
- [x] ActionButton refactor - rename current default constructor to `.custom(...)`, add new default constructor with `Future onAction` parameter
  - [x] Default constructor: `ActionButton(onAction: Future Function(), ...)`
  - [x] Custom constructor: `ActionButton.custom(onPressed: Function, inProgress: bool)`
- [ ] ButtonsGroup https://gist.github.com/andyduke/718c503e4d614bb61bb8cc6e93f033d9
- [ ] CustomTabBar
- [x] ColorSet
- [x] StateProperty
- [ ] AuthScaffold?
- [x] LabeledContent
- [ ] AsyncSnapshot when extension https://gist.github.com/andyduke/aee33c192dcb8df58d8fbbb75459d6e0
- [ ] DataValue (alternate to Result) https://gist.github.com/andyduke/9a351c71d80e3d8aa0e9aa68baa88c5b
- [ ] EventBus https://gist.github.com/andyduke/52a8b9af1906904033961bda7265a844


## Documentation

### Widgets

- [ ] GenericControl
- [ ] Label
- [ ] LabeledContent
- [ ] VStack/HStack/Spacing
- [ ] GlobalShortcuts
- [ ] Result use cases https://gist.github.com/andyduke/b06a6b71203972a5332e6c2f7724bb93


### General

- [ ] Add examples for each widget
- [ ] README refactor:
      in the README, leave only a list of widgets with a brief description, move more detailed descriptions and examples into separate files
