
# ToDo

- [ ] Rename `InheritedSettings` to `Defaults` ???
- [x] ActionButton refactor - rename current default constructor to `.custom(...)`, add new default constructor with `Future onAction` parameter
  - [x] Default constructor: `ActionButton(onAction: Future Function(), ...)`
  - [x] Custom constructor: `ActionButton.custom(onPressed: Function, inProgress: bool)`