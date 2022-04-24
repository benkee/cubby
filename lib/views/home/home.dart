import 'package:cubby/views/home/inventory.dart';
import 'package:cubby/views/home/recipes.dart';
import 'package:cubby/widgets/food_item_expiring_card.dart';
import 'package:cubby/widgets/recipe_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/food_item.dart';
import '../../models/recipe.dart';
import '../../services/firebase_crud.dart';

class HomePage extends StatefulWidget {
  int selectedIndex;
  HomePage(this.selectedIndex, {Key? key}) : super(key: key);
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  PageController? _pageController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String displayName =
      FirebaseAuth.instance.currentUser?.displayName ?? '';
  late String currentUID = FirebaseAuth.instance.currentUser?.uid ?? '';
  User? user;
  bool userSignedIn = false;
  @override
  late BuildContext context;
  int _currentIndex = 1;
  late List<FoodItem> expiringFoodItems;

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
  }

  @override
  void initState() {
    super.initState();
    userNotSignedIn();
    setUserSignedIn();
    _pageController = PageController(initialPage: widget.selectedIndex);
    expiringFoodItems = [];
  }

  @override
  Widget build(context) {
    setState(() => this.context = context);
    return Scaffold(
      backgroundColor: Colors.amber[300],
      appBar: AppBar(
        backgroundColor: Colors.amber[400],
        automaticallyImplyLeading: false,
        title: Container(
          width: 180,
          height: 160,
          padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
          alignment: Alignment.centerRight,
          child: Image.asset('assets/images/CubbyLogo.png'),
        ),
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
          onPageChanged: (newIndex) {
            setState(() {
              _currentIndex = newIndex;
            });
          },
          children: [
            InventoryPage(
              userID: currentUID,
            ),
            Center(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                const SizedBox(height: 10),
                Text('Welcome, ' + displayName),
                const SizedBox(height: 10),
                const Text('Food expiring soon: '),
                Container(
                  height: 200,
                  child: FutureBuilder(
                    builder: (context, projectSnap) {
                      if (projectSnap.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (projectSnap.hasError) {
                        return Center(
                          child: Text(
                              'Error gathering data: ${projectSnap.error}'),
                        );
                      } else {
                        return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: false,
                            itemCount:
                                (projectSnap.data as List<FoodItem>).length,
                            itemBuilder: (context, index) {
                              expiringFoodItems =
                                  projectSnap.data as List<FoodItem>;
                              return ExpiringFoodItemCard(
                                foodItem: expiringFoodItems[index],
                                userID: currentUID,
                              );
                            });
                      }
                    },
                    future: FirebaseCRUD.getExpiringFoodItems(currentUID),
                  ),
                ),
                const Text('Recommended Recipes: '),
                SizedBox(
                  height: 300,
                  child: FutureBuilder(
                    builder: (context, projectSnap) {
                      if (projectSnap.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (projectSnap.hasError) {
                        return Center(
                          child: Text(
                              'Error gathering data: ${projectSnap.error}'),
                        );
                      } else {
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount:
                                (projectSnap.data as List<Recipe>).length,
                            itemBuilder: (context, index) {
                              List<Recipe> recipes =
                                  projectSnap.data as List<Recipe>;
                              return RecipeCard(
                                recipe: recipes[index],
                                userID: currentUID,
                              );
                            });
                      }
                    },
                    future: FirebaseCRUD.getRecommendedRecipes(
                        expiringFoodItems, currentUID),
                  ),
                ),
              ]),
            ),
            RecipePage(
              userID: currentUID,
            )
          ]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.amber[400],
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
        onTap: (index) {
          _pageController?.animateToPage(index,
              duration: const Duration(milliseconds: 500), curve: Curves.ease);
        },
      ),
    );
  }
}
