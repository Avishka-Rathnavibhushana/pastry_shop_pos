import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key, required this.loading});

  final bool loading;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Container(
            color: Colors.black38,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: SpinKitChasingDots(
                color: Colors.white,
                size: 150.0,
              ),
            ))
        : Container();
  }
}
