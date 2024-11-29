part of 'fetch_view.dart';

class FetchViewProvider<T> extends StatelessWidget {
  final FetchViewController<T> controller;
  final Widget child;

  const FetchViewProvider({
    super.key,
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FetchViewController<T>>.value(
      value: controller,
      child: child,
    );
  }
}
