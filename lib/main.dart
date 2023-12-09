// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:r_config_test/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
      title: 'Remote Config Example',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: FutureBuilder<FirebaseRemoteConfig>(
        future: setupRemoteConfig(),
        builder: (BuildContext context,
            AsyncSnapshot<FirebaseRemoteConfig> snapshot) {
          return snapshot.hasData
              ? WelcomeWidget(remoteConfig: snapshot.data!)
              : Container();
        },
      )));
}

class WelcomeWidget extends StatelessWidget {
  WelcomeWidget({required this.remoteConfig});

  final FirebaseRemoteConfig remoteConfig;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent.withOpacity(0.3),
        title: const Text('Remote Config Example'),
      ),
      body: Center(
          child: Text('Welcome ${remoteConfig.getString('example_param_4')}')),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.refresh),
          onPressed: () async {
            try {
              // Using default duration to force fetching from remote server.
              await remoteConfig.setConfigSettings(RemoteConfigSettings(
                  fetchTimeout: Duration(seconds: 0),
                  minimumFetchInterval: Duration(seconds: 0)));
              await remoteConfig.fetchAndActivate();
            } catch (exception) {
              print(
                  'Unable to fetch remote config. Cached or default values will be '
                  'used');
            }
          }),
    );
  }
}

Future<FirebaseRemoteConfig> setupRemoteConfig() async {
  final FirebaseRemoteConfig remoteConfig = await FirebaseRemoteConfig.instance;
  // Enable developer mode to relax fetch throttling
  await remoteConfig.fetch();
  await remoteConfig.fetchAndActivate();

  return remoteConfig;
}
