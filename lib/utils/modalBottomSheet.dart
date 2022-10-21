import 'package:flutter/material.dart';

//Icons.signal_cellular_connected_no_internet_4_bar
//'Ошибка соединения'
void showModalWithIcon(BuildContext context, IconData icon, String message){

  showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    elevation: 100,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    builder: (BuildContext context) { 
          return Container(
            height: 200,
            child: Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(icon),
                  Container(
                    margin: const EdgeInsets.only(left: 5.0),
                    child: Text(message, style: Theme.of(context).textTheme.button),
                  ),
        ],
              ),
            ),
          );
    },
  );
}