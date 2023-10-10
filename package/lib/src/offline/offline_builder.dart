import 'package:app_base_kit/src/offline/offline_tracker.dart';
import 'package:flutter/widgets.dart';

/// A widget that is built based on the state of the network connection.
class OfflineBuilder extends StatefulWidget {
  final WidgetBuilder onlineBuilder;
  final WidgetBuilder offlineBuilder;
  final WidgetBuilder? preparingBuilder;
  final bool enabled;

  const OfflineBuilder({
    Key? key,
    required this.onlineBuilder,
    required this.offlineBuilder,
    this.preparingBuilder,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<OfflineBuilder> createState() => _OfflineBuilderState();
}

class _OfflineBuilderState extends State<OfflineBuilder> with WidgetsBindingObserver {
  final GlobalKey _onlineKey = GlobalKey(debugLabel: 'online-state');

  Widget? _body;
  bool? _isOffline;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    OfflineTracker.state.removeListener(_stateUpdate);

    super.dispose();
  }

  @override
  Future<bool> didPopRoute() async {
    // Block pop route if offline
    return (_isOffline == true);
  }

  Future<void> _init() async {
    await OfflineTracker.state.readyFuture;

    if (mounted) {
      setState(() {
        _isOffline = OfflineTracker.state.isOffline;
      });
    }

    OfflineTracker.state.addListener(_stateUpdate);
  }

  void _stateUpdate() {
    final isOffline = OfflineTracker.state.isOffline;
    if (_isOffline != isOffline) {
      if (mounted) {
        setState(() {
          _isOffline = isOffline;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (_isOffline == false) {
      _body ??= widget.onlineBuilder(context);
    }

    child = Stack(
      children: [
        // Online
        Offstage(
          offstage: _isOffline != false,
          child: (_body != null) ? KeyedSubtree(key: _onlineKey, child: _body!) : const SizedBox(),
        ),

        // Offline
        Offstage(
          offstage: _isOffline != true,
          child: widget.offlineBuilder(context),
        ),

        // Preparing
        if (widget.preparingBuilder != null)
          Offstage(
            offstage: _isOffline != null,
            child: widget.preparingBuilder?.call(context),
          ),
      ],
    );

    return child;
  }
}
