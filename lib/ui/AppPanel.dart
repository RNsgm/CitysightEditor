import 'package:citysight_editor/pages/Editor.dart';
import 'package:citysight_editor/network/NetService.dart';
import 'package:citysight_editor/pages/Home.dart';
import 'package:citysight_editor/pages/Login.dart';
import 'package:citysight_editor/utils/SystemPrefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class AppPanel extends StatefulWidget {
  AppPanel({Key? key, required this.body, this.login = false, this.bottomNavigation, this.isShowActions = true}) : super(key: key);

  Widget body;
  Widget? bottomNavigation;
  bool? login;
  bool isShowActions;

  @override
  State<AppPanel> createState() => _AppPanelState();
}

class _AppPanelState extends State<AppPanel> {
  final SystemPrefs _prefs = SystemPrefs();

  final Future<bool> _isEditor = isEditor();
  late bool _login = false;

  @override
  void initState() {
    super.initState();

    _login = widget.login??false;

    _prefs.getAuthToken().then((value) => {
      setState(()=>{
        if(value.isEmpty){
          _login = true
        }else{
          _login = false,
        }
      })
    });
  }

  Widget _editorButton(){
    return FutureBuilder<bool>(
            future: _isEditor,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              switch (snapshot.connectionState){
                case ConnectionState.waiting:
                  return Container(
                    margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 30.0),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                default:
                  if(snapshot.hasError || !snapshot.data!){
                    return Container();
                  }else{
                    return Container(
                      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10.0),
                      child: OutlinedButton(
                        onPressed: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Editor()));},
                        child: Row(
                          children: [
                            const Icon(Icons.edit),
                            Container(
                              margin: const EdgeInsets.only(left: 5.0),
                              child: Text('Редактор', style: Theme.of(context).textTheme.button),
                            )
                          ],
                        )
                      ),
                    );
                  }
              }
            }
          );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD8E2FF),
        leading: Container(
          margin: const EdgeInsets.only(left: 5.0),
          child: Image.asset("images/logo.png", isAntiAlias: true, filterQuality: FilterQuality.high,)
        ),
        title: TextButton(
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
          },
          child: Text(
            "CITYSIGHT", 
            style: Theme.of(context).textTheme.headlineLarge
          ), 
        ),
        actions: widget.isShowActions ? [
          _editorButton(),
          _login ? Container(
            margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: TextButton(
              onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
              }, 
              child: Text('Войти', style: Theme.of(context).textTheme.button)
            ),
          ) : Container(),
          _login ? Container(
            margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: OutlinedButton(
              style: Theme.of(context).outlinedButtonTheme.style,
              onPressed: (){}, 
              child: Text('Регистрация', style: Theme.of(context).textTheme.button),
            ),
          ) : Container(),
        ] : [
          _editorButton(),
        ],
      ),
      body: widget.body,
      bottomNavigationBar: widget.bottomNavigation,
    );
  }
}