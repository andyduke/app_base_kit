# AppBaseKit

A basic set of widgets and functions for creating a Flutter application.


## Widgets

### InheritedSettings

A generic `InheritedWidget` that defines a set of settings for underlying widgets.


### OfflineBuilder

A widget that is built based on the state of the network connection.


### GenericDropdown

A generalized dropdown button widget that implements all functionality without a user interface.

Used to create dropdown buttons with a custom user interface. Allows you to define the implementation of the user interface.


### ExpansionDetails

A widget that displays summary content and expandable long-form content.


### FlavorOverlay

An overlay displayed on top of the entire application.

Typically used to display debugging information such as build type, API host IP address, etc.


### FocusBuilder

A widget that defines how focus should be displayed around the nested widget.


### BottomSheetScaffold

Scaffolding Scrollable Bottom Sheet.


### ModalBottomSheetPage

Modal route page Bottom Sheet for Navigator 2.0. Used in conjunction with [BottomSheetScaffold](#bottomsheetscaffold).


### ErrorView

A widget that displays an error message, a detailed error message (for example, a stack trace) that expands by button, and an optional "Retry" button.


### ActionButton

Action button in the user interface.

The button can display a progress indicator and
prevent tapping while showing progress.



## Credits

Copyright &copy; [Andy Chentsov](https://github.com/andyduke/)


## License

This project is licensed under the terms of the [BSD 3-Clause license](LICENSE).
