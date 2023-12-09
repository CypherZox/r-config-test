// FutureBuilder<FirebaseRemoteConfig>(
//         future: setupRemoteConfig(),
//         builder: (BuildContext context,
//             AsyncSnapshot<FirebaseRemoteConfig> snapshot) {
//           if (snapshot.connectionState == ConnectionState.done &&
//               !snapshot.hasData) {
//             return Scaffold(
//               body: Center(
//                 child: Text('No Data'),
//               ),
//             );
//           }
//           return snapshot.hasData
//               ? WelcomeWidget(remoteConfig: snapshot.data!)
//               : Scaffold(
//                   body: SafeArea(
//                   child: Align(
//                     alignment: Alignment.topCenter,
//                     child: LinearProgressIndicator(
//                       color: Colors.purpleAccent.withOpacity(0.3),
//                     ),
//                   ),
//                 ));
//         },
//       )