import 'package:cubby/models/food_item.dart';
import 'package:cubby/services/crud.dart';
import 'package:cubby/views/home/inventory.dart';
import 'package:cubby/views/home/recipes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  String displayName = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  bool userSignedIn = false;
  @override
  late BuildContext context;
  int _currentIndex = 1;
  String currentUID = '';

  final PageController _pageController = PageController(initialPage: 1);

  userNotSignedIn() async {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, "/SignInPage");
      }
    });
  }

  setUserSignedIn() async {
    _auth.authStateChanges().listen((User? user) {
      if (this.user != null) {
        setState(() {
          this.user = user;
          userSignedIn = true;
        });
      }
    });
  }

  signOut() {
    _auth.signOut();
    print('SignOut: Sign out was successful.');
  }

  @override
  void initState() {
    super.initState();
    userNotSignedIn();
    setUserSignedIn();
    displayName = _auth.currentUser?.displayName ?? '';
    currentUID = _auth.currentUser?.uid ?? '';
  }

  @override
  Widget build(context) {
    setState(() => this.context = context);
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      appBar: AppBar(
        title: const Text('Cubby'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              signOut();
            },
          ),
        ],
    ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (newIndex){
          setState(() {
            _currentIndex = newIndex;
          });
        },
        children: [
          InventoryPage(),
          Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Welcome, ' + displayName),
                ElevatedButton(
                  onPressed: () async {
                    // FoodItem item = FoodItem('apple', 0);
                    // firebaseCRUD.addFoodItem(item, _auth.currentUser?.uid.toString() ?? '');
                    List<FoodItem> foodItems =
                      await firebaseCRUD.getFoodItems(
                          _auth.currentUser?.uid.toString() ?? ''
                        );
                    for (var item in foodItems) {
                      print(item.name);
                    }
                  },
                  child: const Center(
                  child: Text('Get Items'),
                  ),
                ),
              ]
            ),
          ),
          RecipePage()
        ]
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.lightGreen,
        items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_basket_rounded),
          label: 'Inventory',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Recipes',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index){
          _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease
          );
        },
      ),
    );
  }
}