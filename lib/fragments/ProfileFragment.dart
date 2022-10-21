import 'package:citysight_editor/pages/Home.dart';
import 'package:citysight_editor/ui/Body.dart';
import 'package:citysight_editor/utils/SystemPrefs.dart';
import 'package:flutter/material.dart';

class ProfileFragment extends StatefulWidget {
  ProfileFragment({Key? key}) : super(key: key);

  @override
  State<ProfileFragment> createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  final SystemPrefs _prefs = SystemPrefs();

  void _exitButtonTapped(){
    _prefs.setAuthToken("");
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    return Body(
      widget: Container(
        child: Center(
          child: Column(
            children: [
              const Text("Profole IN Development..."),
              OutlinedButton(onPressed: _exitButtonTapped, child: const Text("Выход"))
            ],
          )
        ),
      ),
    );
  }
}