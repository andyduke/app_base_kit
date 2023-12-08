import 'package:app_base_kit/src/defaults.dart';
import 'package:flutter/widgets.dart';

class VSpacer extends StatelessWidget {
  static const double defaultSize = 0;

  final double? size;

  const VSpacer({
    super.key,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final settings = Defaults.defaultsOf<VSpacerDefaults>(context, VSpacerDefaults.defaults);

    final effectiveSize = size ?? settings.size ?? defaultSize;

    return SizedBox(height: effectiveSize);
  }
}

class VSpacerDefaults implements DefaultsData {
  static VSpacerDefaults defaults = VSpacerDefaults();

  final double? size;

  VSpacerDefaults({
    this.size,
  });
}
