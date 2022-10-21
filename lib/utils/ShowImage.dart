import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ShowImage {
  static show(BuildContext context, String url){
    showGeneralDialog(
      context: context, 
      barrierDismissible: true,
      barrierLabel: '',
      transitionBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return ScaleTransition(scale: animation, child: child);
      },
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Center(
          child: SizedBox(
            height: 600,
            child: Image.network(
              url,
              errorBuilder: (context, error, stackTrace) {
                return AlertDialog(
                  title: const Text('404'),
                  content: const Text('Не удалось найти ресурс'),
                  actions: <Widget>[
                    ElevatedButton(
                      child: const Text('Понятно'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              }
            ),
          ),
        );
    }); 
  }
}