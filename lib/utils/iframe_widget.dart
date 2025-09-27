import 'dart:ui' as ui; // Necessário para registrar a view
import 'dart:html'; // Para usar IFrameElement
import 'package:flutter/material.dart';

class IframeWidget extends StatefulWidget {
  final String url;
  const IframeWidget({super.key, required this.url});

  @override
  State<IframeWidget> createState() => _IframeWidgetState();
}

class _IframeWidgetState extends State<IframeWidget> {
  @override
  void initState() {
    super.initState();

    // Registrar o viewType (único por app)
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
      (int viewId) => IFrameElement()
        ..src = widget.url
        ..style.border = 'none'
        ..width = '100%'
        ..height = '100%',
    );
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(
      viewType: 'iframeElement',
    );
  }
}
