# AppBaseKit

A basic set of widgets and functions for creating a Flutter application.


## Widgets

### Defaults

A generic `InheritedWidget` that defines a set of defaults for underlying widgets.

Usage example:
```dart
// Defaults class
class ActionButtonDefaults implements DefaultsData {

  static ActionButtonDefaults defaults = ActionButtonDefaults(
    builder: (context, child, onPressed) => ElevatedButton(
      onPressed: onPressed,
      child: child,
    ),
  );

  final Widget Function(BuildContext context, Widget child, VoidCallback? onPressed) builder;

  ActionButtonDefaults({
    required this.builder,
  });

}

// Widget that uses defaults
class ActionButton extends StatelessWidget {

  final Widget child;
  final VoidCallback? onPressed;

  const ActionButton({
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Getting defaults
    final settings = Defaults.defaultsOf<ActionButtonDefaults>(context, ActionButtonDefaults.defaults);

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 200,
      ),
      child: settings.builder(
        context,
        child,
        onPressed,
      ),
    );
  }

}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // Defining defaults for underlying widgets
              Defaults(
                [
                  ActionButtonDefaults(
                    builder: (context, child, onPressed) => OutlinedButton(
                      onPressed: onPressed,
                      child: child,
                    ),
                  ),
                ],
                child: MyWidget(),
              ),

              //
              const Divider(),

              //
              MyWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ActionButton(
      onPressed: () {},
      child: const Text('OK'),
    );
  }
}
```


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


### TripleTapDetector

Widget that recognizes triple tap.



## Credits

Copyright &copy; [Andy Chentsov](https://github.com/andyduke/)


## License

This project is licensed under the terms of the [BSD 3-Clause license](LICENSE).
