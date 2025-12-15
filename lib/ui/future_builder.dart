import "package:flutter/material.dart";

///Reusable and shorter [FutureBuilder] based [T]
class CustomFutureBuilder<T> extends StatelessWidget {
  ///It requires the [future] like the [FutureBuilder]
  ///And the [success] which reprent only the
  ///[success] case for the future state
  const CustomFutureBuilder({
    required this.future,
    required this.success,
    super.key,
  });

  ///[Future] of [T] which is the main "action"
  final Future<T> future;

  ///Function of [T] which is building the [success] [Widget]
  final Widget Function(T) success;

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
