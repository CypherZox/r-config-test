// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:r_config_test/remote_config_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription? subscription;
  RemoteConfigUpdate? update;
  final remoteConfig = FirebaseRemoteConfigService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Remote Config Example'),
        ),
        body: Column(
          children: [
            Center(
                child: Text(
                    'Welcome ${remoteConfig.getString('example_param_4')}')),
            _ButtonAndText(
              defaultText: '',
              buttonText: 'Re-activate and fetch',
              onPressed: () async {
                try {
                  await remoteConfig.fetchAndActivate();
                  setState(() {});
                } catch (exception) {
                  debugPrint(
                      'Unable to fetch remote config. Cached or default values will be '
                      'used');
                }
                return '';
              },
            ),
          ],
        ));
  }
}

class _ButtonAndText extends StatefulWidget {
  const _ButtonAndText({
    Key? key,
    required this.defaultText,
    required this.onPressed,
    required this.buttonText,
  }) : super(key: key);

  final String defaultText;
  final String buttonText;
  final Future<String> Function() onPressed;

  @override
  State<_ButtonAndText> createState() => _ButtonAndTextState();
}

class _ButtonAndTextState extends State<_ButtonAndText> {
  String? _text;

  // Update text when widget is updated.
  @override
  void didUpdateWidget(covariant _ButtonAndText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.defaultText != oldWidget.defaultText) {
      setState(() {
        _text = widget.defaultText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Text(_text ?? widget.defaultText),
          const Spacer(),
          ElevatedButton(
            onPressed: () async {
              final result = await widget.onPressed();
              setState(() {
                _text = result;
              });
            },
            child: Text(widget.buttonText),
          ),
        ],
      ),
    );
  }
}
