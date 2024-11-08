import 'package:flutter/material.dart';
<<<<<<< Updated upstream

class ErrorScreen extends StatelessWidget {
  final Object? error;
  final VoidCallback? onRetry;

  const ErrorScreen({Key? key, required this.error, this.onRetry}) : super(key: key);
=======
import 'package:flutter/services.dart';
import 'package:sail/constant/app_urls.dart';
import 'package:sail/http/api/AppSettingsManager.dart';

class ErrorScreen extends StatefulWidget {
  final Object? error;
  final VoidCallback? onRetry;
  final AppSettingsManager? appSettingsManager;

  const ErrorScreen({Key? key, required this.error, this.onRetry, this.appSettingsManager}) : super(key: key);

  @override
  _ErrorScreenState createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  String _errorString = '';
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _errorString = widget.error!= null? (widget.error.toString()) : "have Problem on my app";
  }

  void _restartApp() {
    SystemNavigator.pop();
    SystemNavigator.routeInformationUpdated(location: "/", replace: true);
  }
>>>>>>> Stashed changes

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          backgroundColor: Colors.red, // Or your error color
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red, // Or your error color
                ),
                const SizedBox(height: 16),
                Text(
                  'Oops, something went wrong!',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
<<<<<<< Updated upstream
                  error.toString(), // Display the error message
=======
                  _errorString, // Display the error message
>>>>>>> Stashed changes
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
<<<<<<< Updated upstream
                  onPressed:onRetry,
=======
                  onPressed: widget.onRetry??
                          () async {
                        setState(() {
                          _errorString = "Try Connect To Main Server";
                        });
                        var appSettingsManager = widget.appSettingsManager?? AppSettingsManager(apiEndpoint: AppUrls.baseUrl);
                        await appSettingsManager.getSettings(null).then((result) {
                          if (result!= null) {
                            setState(() {
                              _errorString = "App Connected To Server";
                              _isConnected = true;
                            });
                            _restartApp();
                          } else {
                            setState(() {
                              _errorString = "Can't Connected To Server";
                            });
                          }
                        });
                      },
>>>>>>> Stashed changes
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}