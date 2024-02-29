# AppBaseKit

A basic set of widgets and functions for creating a Flutter application.


## Widgets

### Defaults

A generic `InheritedWidget` that defines a set of defaults for underlying widgets.

<details>
  <summary>Usage example</summary>

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
</details>


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


### Button (Custom Buttons)

To create buttons with a custom design, you can use the abstract `Button` widget as a scaffold. The `Button` widget handles typical button states such as focused, hovered, pressed, disabled, but does not implement the UI.

<details>
  <summary>An example of implementing a button in a specific design</summary>

```dart
class PrimaryButton extends Button {
  static const animationDuration = Duration(milliseconds: 300);

  const PrimaryButton({
    super.key,
    required super.onPressed,
    required super.child,
    super.enabled,
    super.autofocus,
    super.focusNode,
    super.canRequestFocus,
    super.enableFeedback,
  }) : super(
          pressedDuration: animationDuration,
        );

  @override
  Widget builder(BuildContext context, Set<ButtonState> states, Widget child) {
    return AnimatedContainer(
      duration: animationDuration,
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: switch (states) {
          Set<ButtonState>() when states.contains(ButtonState.focused) => Border.all(color: Colors.teal, width: 2.0),
          Set<ButtonState>() => Border.all(color: Colors.transparent, width: 2.0),
        },
        color: switch (states) {
          Set<ButtonState>() when states.contains(ButtonState.pressed) => Colors.teal.shade300,
          Set<ButtonState>() when states.contains(ButtonState.hovered) => Colors.teal.shade200,
          Set<ButtonState>() when states.contains(ButtonState.disabled) => Colors.grey.shade300,
          _ => Colors.teal.shade100,
        },
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: child,
      ),
    );
  }
}
```
</details>

<details>
  <summary>Example of using this button</summary>

```dart
PrimaryButton(
  onPressed: () {
    print('Primary Button Pressed!');
  },
  child: const Text('Primary Button'),
),
```
</details>


### ColorSet

Makes it possible to describe a pair of colors: foreground and background. Convenient to use with theme extensions.


### StateProperty

Interface for classes that `resolve` to a value of type `T` based on a widget's interactive "state", which is defined as a set of `S` states.

For example, based on `StateProperty`, you can implement a property class for various **button states**:
```dart
enum ButtonState {
  hovered,
  pressed,
  disabled,
}

class ButtonStateProperty<T> implements StateProperty<T, ButtonState> {
  final T normal;
  final T? hovered;
  final T? pressed;
  final T? disabled;

  const ButtonStateProperty(
    this.normal, {
    this.hovered,
    this.pressed,
    this.disabled,
  });

  @override
  T resolve(Set<ButtonState> states) {
    if (states.contains(ButtonState.disabled)) {
      return disabled ?? normal;
    }
    if (states.contains(ButtonState.pressed)) {
      return pressed ?? normal;
    }
    if (states.contains(ButtonState.hovered)) {
      return hovered ?? normal;
    }
    return normal;
  }

  static ButtonStateProperty<T>? lerp<T>(
    ButtonStateProperty<T>? a,
    ButtonStateProperty<T>? b,
    double t,
    T? Function(T?, T?, double) lerpFunction,
  ) {
    return StateProperty.lerp<ButtonStateProperty<T>, T, ButtonState>(a, b, t, lerpFunction);
  }
}
```

Now, using `ButtonStateProperty`, you can set, for example, the color for different button states:
```dart
final buttonColors = ButtonStateProperty<Color>(
  Colors.black,
  hovered: Colors.teal,
  pressed: Colors.blue,
);
```

To get the color value for a specific state, you need to use the resolve method:
```dart
final buttonHoverColor = buttonColors.resolve({ButtonState.hovered});
```

> Because such property classes are commonly used in theme extensions, `StateProperty` provides a static `lerp` method.


## Credits

Copyright &copy; [Andy Chentsov](https://github.com/andyduke/)


## License

This project is licensed under the terms of the [BSD 3-Clause license](LICENSE).
