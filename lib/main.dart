import 'dart:developer';
import 'package:flutter/material.dart';
// import 'package:oauth2_client/github_oauth2_client.dart';
// import 'package:oauth2_client/google_oauth2_client.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:http/http.dart' as http;
import 'package:oauthiviva/oauth2redirect.dart';

import 'app_route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample Flutter app - iViva oauth',
      onGenerateRoute: AppRouteGenerator.generateRoute,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Sample Flutter app - iViva oauth'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  Future<void> ivivaDetails(BuildContext context) async {
    var client = OAuth2Client(
      authorizeUrl: "http://lucy1.lucy.local:5000/oauth2/oidc/keycloak/auth",
      tokenUrl: "http://lucy1.lucy.local:5000/oauth2/token",
      redirectUri: "com.example.oauthiviva://oauth2redirect",
      customUriScheme: "com.example.oauthiviva",
      credentialsLocation: CredentialsLocation.BODY,
    );

    var tknResp = await client.getTokenWithAuthCodeFlow(
      clientId: "bfc0d52bc8b82247f388b2f30551dc9ce831d13781941173",
      clientSecret: "a72dbaabcb2d64232ecf30e65292a8d2c6e4a00f9acc1f676113c9a0ca6a6a2aae62839afd767cc6248fc43620f64a55",
      scopes: ["user:read"],
    );

    String? token = tknResp.accessToken;

    var httpClient = http.Client();
    try {
      var response = await httpClient.get(Uri.parse(
              "http://lucy1.lucy.local:5000/Lucy/LucyMobileAuth/me"),
          headers: {"Authorization": "Bearer ${token ?? ""}"});
      log(response.body);
      if (response.statusCode == 200) {
        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OAuthScreen(
                    details: response.body.toString(),
                  )),
        );
      }
    } finally {
      httpClient.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
           
            ElevatedButton(
              onPressed: () {
                ivivaDetails(context);
              },
              child: const Text("Login to Raseel"),
            ),
          ],
        ),
      ),
    );
  }
}
