import 'package:flutter/material.dart';
<<<<<<< HEAD
<<<<<<< Updated upstream
=======
<<<<<<< HEAD
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
=======
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55

class ErrorScreen extends StatelessWidget {
  final Object? error;
  final VoidCallback? onRetry;

  const ErrorScreen({Key? key, required this.error, this.onRetry}) : super(key: key);
<<<<<<< HEAD
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
=======
>>>>>>> 9f01e9fe824b24f769f882f918aba04fcc7d0f67
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55

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
<<<<<<< HEAD
<<<<<<< Updated upstream
                  error.toString(), // Display the error message
=======
                  _errorString, // Display the error message
>>>>>>> Stashed changes
=======
<<<<<<< HEAD
                  _errorString, // Display the error message
=======
                  error.toString(), // Display the error message
>>>>>>> 9f01e9fe824b24f769f882f918aba04fcc7d0f67
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
<<<<<<< HEAD
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
=======
<<<<<<< HEAD
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
=======
                  onPressed:onRetry,
>>>>>>> 9f01e9fe824b24f769f882f918aba04fcc7d0f67
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55
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