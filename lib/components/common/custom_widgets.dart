import 'package:flutter/material.dart';

Widget loadingWidget (){
  return const Scaffold(
      backgroundColor: Color(0xFF35344A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              'Loading',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
}

Widget nextButton ({required String displayText, required void Function() action}){
  return Center(
    child: ElevatedButton(
      onPressed: action,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 100,
          vertical: 15,
        ),
        backgroundColor: const Color.fromRGBO(88, 198, 169, 1),
      ),
      child: Text(
        displayText,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}


Widget nextButtonWithSkip ({required String displayText, required void Function() action, required Widget nextPage, required BuildContext context}){
  return Center(
    child: Column(
      children: [
        ElevatedButton(
          onPressed: action,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 100,
              vertical: 15,
            ),
            backgroundColor: const Color.fromRGBO(88, 198, 169, 1),
          ),
          child: Text(
            displayText,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => nextPage,
              ),
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Divider(
                  color: Color.fromARGB(255, 199, 199, 199),
                  thickness: 1,
                  endIndent: 10,
                ),
              ),
              Text(
                'Skip for now',
                style: TextStyle(
                  color: Color(0xFF58C6A9),
                  decoration: TextDecoration.underline,
                ),
              ),
              Expanded(
                child: Divider(
                  color: Color.fromARGB(255, 199, 199, 199),
                  thickness: 1,
                  indent: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    )
    );
}