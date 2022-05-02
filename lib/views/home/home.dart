import 'package:cubby/models/cubby_user.dart';
import 'package:cubby/views/home/inventory.dart';
import 'package:cubby/views/home/recipes.dart';
import 'package:cubby/views/home/shopping_list.dart';
import 'package:cubby/widgets/food_item_widgets/food_item_expiring_card.dart';
import 'package:cubby/widgets/recipe_widgets/recommended_recipe_card.dart';
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
          alignment: Alignment.center,
          child: Image.asset('assets/images/CubbyLogo.png'),
        ),
        actions: <Widget>[
          FutureBuilder(
            future: FirebaseCRUD.getUser(currentUID),
            builder: (BuildContext context, AsyncSnapshot<CubbyUser> snapshot) {
              if (snapshot.hasData) {
                CubbyUser cubbyUser = snapshot.data as CubbyUser;
                return Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  decoration: BoxDecoration(color: Colors.amber[400]),
                  message:
                      'Total Food Wasted: ${cubbyUser.foodWasted}\nTotal Food Used: ${cubbyUser.foodUsed}',
                  child: Column(children: [
                    Text(
                      'Welcome, ${cubbyUser.name}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.lightGreen,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'Food Waste: ${cubbyUser.percentWasted.toString()}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ]),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
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
          setState(
            () {
              _currentIndex = newIndex;
            },
          );
        },
        children: [
          InventoryPage(
            userID: currentUID,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Food expiring soon: ',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: FutureBuilder(
                    future: FirebaseCRUD.getExpiringFoodItems(currentUID),
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
                        if ((projectSnap.data as List).isEmpty) {
                          return Column(children: const [
                            SizedBox(
                              height: 50,
                            ),
                            SizedBox(
                              height: 120,
                              width: 300,
                              child: Card(
                                color: Colors.lightGreen,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    'Try adding food items in your inventory, items which are due to expire in the next 5 days will appear here.',
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ]);
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
                            },
                          );
                        }
                      }
                    },
                  ),
                ),
                const Text(
                  'Recommended Recipes: ',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 370,
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
                        if ((projectSnap.data as List).isEmpty) {
                          return Column(children: const [
                            SizedBox(
                              height: 50,
                            ),
                            SizedBox(
                              height: 160,
                              width: 300,
                              child: Card(
                                  color: Colors.lightGreen,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Try adding a recipe to your recipes with an expiring food item as a ingredient, when a recipe has an expiring food item (in the next 5 days) as an ingredient it will appear here.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  )),
                            )
                          ]);
                        } else {
                          return ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount:
                                  (projectSnap.data as List<Recipe>).length,
                              itemBuilder: (context, index) {
                                List<Recipe> recipes =
                                    projectSnap.data as List<Recipe>;
                                return RecommendedRecipeCard(
                                  recipe: recipes[index],
                                  userID: currentUID,
                                );
                              });
                        }
                      }
                    },
                    future: FirebaseCRUD.getRecommendedRecipes(
                      expiringFoodItems,
                      currentUID,
                    ),
                  ),
                ),
              ],
            ),
          ),
          RecipePage(
            userID: currentUID,
          ),
          ShoppingListPage(
            userID: currentUID,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
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
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shopping List',
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
