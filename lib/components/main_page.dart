import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.only(top: 20.0), // Adjust this value to move the icon down
          child: IconButton(
            icon: Icon(Icons.menu, color: Colors.black, size: 30.0), // Increase the size of the menu icon
            onPressed: () {
              // Handle menu action
            },
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          // Background image of a map
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('../assets/map.webp'), // Update the path to your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 80.0, // Move the box down
            left: 20.0,
            right: 20.0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              height: 50.0, // Adjust the height to make the box smaller
              decoration: BoxDecoration(
                color: Color(0xFF35344A),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Where are you going?',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('../assets/navabr.png'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    spreadRadius: 0,
                    blurRadius: 14,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('../assets/home.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('../assets/wallet.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 60),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('../assets/history.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('../assets/settings.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: MediaQuery.of(context).size.width / 2 - 28,
            child: GestureDetector(
              onTap: () {
                // Handle image button press
              },
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('../assets/map.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MainPage(),
  ));
}
