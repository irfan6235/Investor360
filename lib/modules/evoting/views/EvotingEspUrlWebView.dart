import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EvotingEspUrlWebViewPage extends StatefulWidget {
  final String sURL;
  final String sData;
  final String sEntityId;

  EvotingEspUrlWebViewPage({required this.sURL, required this.sData, required this.sEntityId});

  @override
  _EvotingEspUrlWebViewPageState createState() => _EvotingEspUrlWebViewPageState();
}

class _EvotingEspUrlWebViewPageState extends State<EvotingEspUrlWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebViewController();
  }

  void _initializeWebViewController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            print('Page started loading: $url');
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            print('Error: ${error.description}');
            setState(() {
              _isLoading = false;
            });
          },
        ),
      );

    _loadUrlWithData();
  }

  void _loadUrlWithData() {
    String postData = "data=${widget.sData}&source_entity_id=${widget.sEntityId}";

    if (widget.sURL.contains("evotingindia")) {
      _controller.loadRequest(Uri.parse("${widget.sURL}?$postData"));
    } else {
      // Using POST method via JavaScript
      _controller.runJavaScript(
          'document.body.innerHTML = "<form id=\'postForm\' method=\'POST\' action=\'${widget.sURL}\'>'
              '<input type=\'hidden\' name=\'data\' value=\'${widget.sData}\' />'
              '<input type=\'hidden\' name=\'source_entity_id\' value=\'${widget.sEntityId}\' />'
              '</form>"; document.getElementById(\'postForm\').submit();');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'eVoting',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller), // WebView
          if (_isLoading) // Loader
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
