import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:oauth2_client/github_oauth2_client.dart';
import 'package:oauth2_client/google_oauth2_client.dart';
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
  Future<void> gitHubDetails(BuildContext context) async {
    OAuth2Client ghClient = GitHubOAuth2Client(
        redirectUri: 'com.example.oauthiviva://oauth2redirect',
        customUriScheme: 'com.example.oauthiviva');

    var tknResp = await ghClient.getTokenWithAuthCodeFlow(
      clientId: "9ffaa88a8e3f2804d3c7",
      clientSecret: "93c27ae0008efcc1d9d3f1f45e785eb580840344",
      scopes: ["repo"],
    );

    String? token = tknResp.accessToken;

    var client = http.Client();
    try {
      var response = await client.get(Uri.parse("https://api.github.com/user"),
          headers: {"Authorization": "token ${token ?? ""}"});
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
      client.close();
    }
  }

  Future<void> googleDetails(BuildContext context) async {
    OAuth2Client googleClient = GoogleOAuth2Client(
        redirectUri:
            'com.example.oauthiviva:/oauth2redirect', //Just one slash, required by Google specs
        customUriScheme: 'com.example.oauthiviva');

    var tknResp = await googleClient.getTokenWithAuthCodeFlow(
      clientId:
          "303836879310-pbtrd5qhg4d9i6i0p1vu7u3g3a4r3d69.apps.googleusercontent.com",
      scopes: ["https://www.googleapis.com/auth/drive.readonly"],
    );

    String? token = tknResp.accessToken;

    var client = http.Client();
    try {
      var response = await client.get(
        Uri.parse("https://www.googleapis.com/drive/v3/files"),
        headers: {"Authorization": "Bearer ${token ?? ""}"},
      );
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
      client.close();
    }
  }

  Future<void> ivivaDetails(BuildContext context) async {
    var client = OAuth2Client(
      authorizeUrl: "http://lucy1.lucy.local:5000/oauth2/oidc/keycloak/auth",
      tokenUrl: "http://lucy1.lucy.local:5000/oauth2/token",
      // authorizeUrl: "https://mobile.v4.iviva.cloud/oauth2/auth",
      // tokenUrl: "https://mobile.v4.iviva.cloud/oauth2/token",
      redirectUri: "com.example.oauthiviva://oauth2redirect",
      customUriScheme: "com.example.oauthiviva",
      credentialsLocation: CredentialsLocation.BODY,
    );

    var tknResp = await client.getTokenWithAuthCodeFlow(
      // clientId: "beb89a31b3ad85e77b5f5dfb47282c1d631df3b3cac1e3de",
      clientId: "bfc0d52bc8b82247f388b2f30551dc9ce831d13781941173",
      // clientSecret:
          // "a04074be51be3935f48ab6023edca976871a3690fb9afe694208f1ff297b90fdd4bc917238c696bc262807bd722adf87",
      clientSecret: "a72dbaabcb2d64232ecf30e65292a8d2c6e4a00f9acc1f676113c9a0ca6a6a2aae62839afd767cc6248fc43620f64a55",
      scopes: ["user:read"],
    );

    String? token = tknResp.accessToken;

    var httpClient = http.Client();
    try {
      var response = await httpClient.get(Uri.parse(
              //"https://mobile.v4.iviva.cloud/Lucy/oauth_test/user_details"),
              // "https://mobile.v4.iviva.cloud/Lucy/LucyMobileAuth/me"),
              "http://lucy1.lucy.local:5000/Lucy/LucyMobileAuth/me"),
          headers: {"Authorization": "Bearer ${token ?? ""}"});
      log(response.body);
      print("((((((((((("+(token ?? "") + response.statusCode.toString());
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
                gitHubDetails(context);
              },
              child: const Text("Github login details"),
            ),
            ElevatedButton(
              onPressed: () {
                googleDetails(context);
              },
              child: const Text("google login details"),
            ),
            ElevatedButton(
              onPressed: () {
                ivivaDetails(context);
              },
              child: const Text("iviva login details"),
            ),
          ],
        ),
      ),
    );
  }
}
