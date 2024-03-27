import 'package:app_base_kit/app_base_kit.dart';
import 'package:flutter/material.dart';
import 'package:helper_widgets_proto/widgets/layout/layout.dart';
import 'package:helper_widgets_proto/widgets/layout/section.dart';
import 'package:helper_widgets_proto/widgets/layout/section_content.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Layout demo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: VStack(
            spacing: 24,
            crossAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Title'),
              const Divider(),
              ElevatedButton(
                onPressed: () {},
                child: const Text('OK'),
              ),

              // HStack
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 100,
                ),
                child: HStack(
                  spacing: 16,
                  crossAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ColoredBox(
                        color: Colors.amber.shade200,
                        child: const Text('Label'),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.blueGrey.shade100,
                        child: const Text('Value'),
                      ),
                    ),
                  ],
                ),
              ),

              // HStack defaults
              const Divider(),
              Defaults(
                [
                  HStackDefaults(spacing: 48),
                ],
                child: const HStack(
                  children: [
                    Text('ABC'),
                    Text('abc'),
                  ],
                ),
              ),

              // Labeled Content
              const Divider(),
              LabeledContent(
                label: ColoredBox(color: Colors.amber.shade200, child: const Text('Label')),
                child: ColoredBox(color: Colors.teal.shade100, child: const Text('CONTENT')),
              ),

              // HSpacer
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Expanded(child: ColoredBox(color: Colors.amber.shade200, child: const SizedBox.expand())),
                    const HSpacer(size: 20),
                    Expanded(child: ColoredBox(color: Colors.teal.shade100, child: const SizedBox.expand())),
                  ],
                ),
              ),
              const Divider(),

              // VSpacer
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ColoredBox(
                    color: Colors.amber.shade200,
                    child: const SizedBox(width: double.infinity, height: 20),
                  ),
                  const VSpacer(size: 10),
                  ColoredBox(
                    color: Colors.teal.shade100,
                    child: const SizedBox(width: double.infinity, height: 20),
                  ),
                ],
              ),

              // Form/Layout
              LabeledContent(
                label: const Text('Form/Layout'),
                child: Layout(
                  children: [
                    const LabeledContent(
                      label: Text('Text field'),
                      child: TextField(),
                    ),
                    Section(
                      builder: (context, children, header, headerSpacing, footer, footerSpacing, isExpanded) {
                        return Defaults(
                          [
                            SectionContentDefaults(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                            ),
                          ],
                          child: VStack(
                            children: [
                              if (header != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: header,
                                ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.secondaryContainer,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                child: VStack(
                                  spacing: 8.0,
                                  children: children.map((c) => SectionContent(child: c)).fold(
                                    [],
                                    (prev, c) => [
                                      ...prev,
                                      if (prev.isNotEmpty) const Divider(),
                                      c,
                                    ],
                                  ),
                                ),
                              ),
                              if (footer != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: footer,
                                ),
                            ],
                          ),
                        );
                      },

                      //
                      header: const Text('Section title'),
                      children: const [
                        LabeledContent(
                          label: Text('Field 1'),
                          child: TextField(
                            decoration: InputDecoration(
                              filled: true,
                              // fillColor: Theme.of(context).colorScheme.tertiaryContainer,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(gapPadding: 0, borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                        LabeledContent(
                          label: Text('Field 2'),
                          child: TextField(
                            decoration: InputDecoration(
                              filled: true,
                              // fillColor: Theme.of(context).colorScheme.tertiaryContainer,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(gapPadding: 0, borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
