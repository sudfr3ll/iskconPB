import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Dialog(
        insetPadding: EdgeInsets.all(0),
        backgroundColor: Color.fromARGB(10, 0, 0, 0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(
                    color: Colors.purple,
                    strokeWidth: 6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
