import 'package:flutter/material.dart';

class CustomFutureBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(T) success;
  const CustomFutureBuilder({
    required this.future,
    required this.success,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) => snapshot.hasData
          ? success(snapshot.data as T)
          : Center(
              child: snapshot.hasError
                  ? Text(
                      snapshot.error.toString(),
                    )
                  : const CircularProgressIndicator(),
            ),
    );
  }
}
