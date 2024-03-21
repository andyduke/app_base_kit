import 'package:app_base_kit/src/utils/defaults.dart';
import 'package:flutter/widgets.dart';

class HSpacer extends StatelessWidget {
  static const double defaultSize = 0;

  final double? size;

  const HSpacer({
    super.key,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final settings = Defaults.defaultsOf<HSpacerDefaults>(context, HSpacerDefaults.defaults);

    final effectiveSize = size ?? settings.size ?? defaultSize;

    return SizedBox(width: effectiveSize);
  }
}

class HSpacerDefaults implements DefaultsData {
  static HSpacerDefaults defaults = HSpacerDefaults();

  final double? size;

  HSpacerDefaults({
    this.size,
  });
}
