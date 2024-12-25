part of 'fetch_view.dart';

// Defaults class
class FetchViewDefaults implements DefaultsData {
  static FetchViewDefaults defaults = FetchViewDefaults(
    loadingBuilder: FetchView.defaultLoadingBuilder,
    errorBuilder: FetchView.defaultErrorBuilder,
  );

  final WidgetBuilder loadingBuilder;
  final FetchViewErrorBuilder errorBuilder;

  FetchViewDefaults({
    required this.loadingBuilder,
    required this.errorBuilder,
  });
}

typedef FetchViewBuilder<T> = Widget Function(BuildContext context, T data);
typedef FetchViewErrorBuilder = Widget Function(
  BuildContext context,
  Object error,
  StackTrace? stackTrace,
  void Function() tryAgain,
);

class FetchView<T> extends StatefulWidget {
  final FetchViewController<T> controller;
  final FetchViewBuilder<T> builder;
  final WidgetBuilder? loadingBuilder;
  final FetchViewErrorBuilder? errorBuilder;

  const FetchView({
    super.key,
    required this.controller,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
  });

  static Widget defaultLoadingBuilder(BuildContext context) {
    return const Center(
      child: Waiting(),
    );
  }

  static Widget defaultErrorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
    void Function() tryAgain,
  ) {
    // TODO: Wrap with SingleChildScrollView if Scrollable.maybeOf() is null
    return Center(
      child: ErrorView(
        error: '$error\n\n$stackTrace',
        isDebugMode: kDebugMode,
      ),
    );
  }

  @override
  State<FetchView<T>> createState() => _FetchViewState<T>();
}

class _FetchViewState<T> extends State<FetchView<T>> {
  late FetchViewController<T> controller;

  @override
  void initState() {
    super.initState();

    controller = widget.controller;
    _attachController();
    _fetch();
  }

  @override
  void didUpdateWidget(covariant FetchView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      _detachController();
      controller = widget.controller;
      _attachController();
    }
  }

  @override
  void dispose() {
    _detachController();

    super.dispose();
  }

  void _attachController() {
    controller.addListener(_updated);
  }

  void _detachController() {
    controller.removeListener(_updated);
  }

  void _updated() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _fetch() async {
    await controller.fetch();
  }

  void _reload() {
    // controller.reload();
    controller.fetch();
  }

  @override
  Widget build(BuildContext context) {
    // Getting defaults
    final settings = Defaults.defaultsOf<FetchViewDefaults>(context, FetchViewDefaults.defaults);
    final loadingBuilder = widget.loadingBuilder ?? settings.loadingBuilder;
    final errorBuilder = widget.errorBuilder ?? settings.errorBuilder;

    return switch (controller.data) {
      ResultSuccess<T>(data: var d) => widget.builder(context, d),
      ResultError<T>(error: var e, stackTrace: var s) => errorBuilder(context, e, s, _reload),
      _ => loadingBuilder(context),
    };
  }
}
