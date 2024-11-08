import 'package:flutter/material.dart';
import 'package:sail/resources/app_strings.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebViewWidget extends StatefulWidget {
  final String? url;
  final String? name;

  const CustomWebViewWidget({Key? key, this.url, this.name}) : super(key: key);

  @override
  CustomWebViewWidgetState createState() => CustomWebViewWidgetState();
}

class CustomWebViewWidgetState extends State<CustomWebViewWidget> {
  late final WebViewController controller;

  final String _javaScript = '''
  const styles = `
  #page-header {
    display: none;
  }
  #main-container {
    padding-top: 0 !important;
  }
  `
  const styleSheet = document.createElement("style")
  styleSheet.innerText = styles
  document.head.appendChild(styleSheet)
  ''';

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            print('url=$url');
            controller.runJavaScript(_javaScript);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url?.isEmpty == true ? AppStrings.appName : widget.url!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name ?? ''),
        centerTitle: true,
      ),
      body: WebViewWidget( // This is the one from `webview_flutter`
        controller: controller,
      ),
    );
  }
}
