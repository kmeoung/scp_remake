import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:refactory_scp/src/common/colors.dart';
import 'package:refactory_scp/src/pages/home/home_page.dart';

import 'http/scp_http_client.dart';
import 'dart:html' as html;

void main() => runApp(Scp());

/// SCP Project
class Scp extends StatelessWidget {
  Scp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: CustomColors.yellow,
        backgroundColor: CustomColors.white,
        appBarTheme: const AppBarTheme(
          color: CustomColors.deepPurple,
          centerTitle: false,
          foregroundColor: CustomColors.white,
        ),
        textTheme: const TextTheme(
          bodyText1: TextStyle(color: CustomColors.deepPurple),
          bodyText2: TextStyle(color: CustomColors.deepPurple),
          headline1: TextStyle(color: CustomColors.deepPurple),
          headline2: TextStyle(color: CustomColors.deepPurple),
        ),
      ),
      home: LoadingPage(),
    );
  }
}

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  @override
  void initState() {
    Timer(const Duration(milliseconds: 1000), () {
      String uid = '';
      String token = '';
      String? cookies = html.window.document.cookie;

      Fluttertoast.showToast(
          msg: 'Origin Cookies\n{$cookies}',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 10,
          webBgColor: 'red',
          webPosition: 'left',
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

      List<String> arrCookie = cookies!.split(';');

      Fluttertoast.showToast(
          msg: 'cookie List\n{${arrCookie}}',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 10,
          webBgColor: 'red',
          webPosition: 'left',
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);



      for(String cookie in arrCookie){
        List<String> keyValue = cookie.split("=");
        String key = keyValue[0];
        String value = keyValue[1];

        Fluttertoast.showToast(
            msg: 'cookie\n${keyValue.toString()}\n{$key : $value}',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 10,
            webBgColor: '#000000',
            webPosition: 'left',
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);

        if(key.contains('uid')){
          Fluttertoast.showToast(
              msg: 'cookie uid\n{$key : $value}',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 10,
              webBgColor: '#000000',
              webPosition: 'left',
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
          uid = value;
        }else if(key.contains('JSESSIONID')){
          Fluttertoast.showToast(
              msg: 'cookie JESSIONID\n{$key : $value}',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 10,
              webBgColor: '#000000',
              webPosition: 'left',
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
          token = value;
        }else if(key.contains('SCP')){
          Fluttertoast.showToast(
              msg: 'cookie SCP\n{$key : $value}',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 10,
              webBgColor: '#000000',
              webPosition: 'left',
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
          token = value;
        }
      }

      Fluttertoast.showToast(
          msg:'cookie save uid\n{$uid}',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 10,
          webBgColor: '#000000',
          webPosition: 'left',
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

      Fluttertoast.showToast(
          msg:'cookie save token\n{$token}',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 10,
          webBgColor: '#000000',
          webPosition: 'left',
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

      // token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxMyIsImlhdCI6MTY1NDU0NTg3MywiZXhwIjoxNjU1NDA5ODczfQ.ZME_gQs2jN5Z4xlScjj4EVs3fxBXFjoS25GERTBRDtWtwmLH--7iIzK0SVDab5hbYMINdxwT8AbYq9FtstDsdw';
      // uid = '1';

      ScpHttpClient.TOKEN = token;

      if(token.isNotEmpty) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(uid: uid),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: CustomColors.deepPurple,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'SCP ',
                style: TextStyle(color: CustomColors.yellow,fontWeight: FontWeight.bold,fontSize: 40),
              ),
              Text(
                'PROJECT',
                style: TextStyle(color: CustomColors.white,fontWeight: FontWeight.bold,fontSize: 40),
              )
            ],
          ),
        ),
      ),
    );
  }
}
