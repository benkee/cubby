const List<String> foodTypes = [
  'Fruits',
  'Vegetables',
  'Meat',
  'Tinned',
  'Dairy',
  'Grains',
  'Frozen'
];

const List<String> foodTypeImage = [
  'assets/images/fruits.png',
  'assets/images/vegetables.png',
  'assets/images/meat.png',
  'assets/images/tinned.png',
  'assets/images/dairy.png',
  'assets/images/grains.png',
  'assets/images/frozen.png',
];

const List<String> foodMeasurements = [
  'g',
  'ml',
  'item/s',
];

const List<String> foodTypeExamples = [
  'Apples, Pears, Berries...',
  'Leafy Greens, Cruciferous, Allium...',
  'Red Meat, Poultry, Seafood...',
  'Any Tinned Items',
  'Milk, Butter, Cheese...',
  'Bread, Pasta, Oats...',
  'Any Frozen Items',
];

const List<Map<String, dynamic>> startingRecipes = [
  {
    'name': 'Sausage Ragu',
    'preparationTime': 50,
    'cost': 3.50,
    'instructions': [
      {
        'id': 0,
        'step': 'Fry the onion for 7 mins, add chilli and garlic and cook '
            'for 1 minute.',
      },
      {
        'id': 1,
        'step': 'Add the tomatoes and sugar and simmer for 20 minutes.',
      },
      {
        'id': 2,
        'step':
            'In a new pan, squeeze the sausagemeat and fry, breaking up with a'
                ' wooden spoon, for 5-7 minutes.',
      },
      {
        'id': 3,
        'step': 'Add this to the sauce with the milk and the zest of the lemon,'
            ' then simmer for 5 minutes more.',
      },
      {
        'id': 4,
        'step': 'Cook the pasta following the pack instructions, then toss in'
            'with the sauce, then sprinkle over the cheese to serve.',
      },
      {
        'id': 5,
        'step':
            'In a new pan, squeeze the sausagemeat and fry, breaking up with a'
                'wooden spoon, for 5-7 minutes.',
      },
      {
        'id': 6,
        'step': 'Add the tomatoes and sugar and simmer for 20 minutes',
      }
    ],
    'ingredients': [
      {'id': 0, 'amount': '1', 'measurement': 'item/s', 'name': 'Onion'},
      {
        'id': 1,
        'amount': '2',
        'measurement': 'item/s',
        'name': 'Garlic Cloves'
      },
      {'id': 2, 'amount': '5', 'measurement': 'g', 'name': 'Chilli Flakes'},
      {
        'id': 3,
        'amount': '2',
        'measurement': 'item/s',
        'name': 'Chopped Tomatoes'
      },
      {'id': 4, 'amount': '15', 'measurement': 'g', 'name': 'Brown Sugar'},
      {
        'id': 5,
        'amount': '6',
        'measurement': 'item/s',
        'name': 'Pork Sausages'
      },
      {'id': 6, 'amount': '150', 'measurement': 'ml', 'name': 'Milk'},
      {'id': 7, 'amount': '1', 'measurement': 'item/s', 'name': 'Lemon'},
      {'id': 8, 'amount': '350', 'measurement': 'g', 'name': 'Pasta'},
      {'id': 9, 'amount': '50', 'measurement': 'g', 'name': 'Cheese'},
    ],
  },
  {
    'name': 'Cheese, Ham and Broccoli Pasta',
    'preparationTime': 25,
    'cost': 2.50,
    'instructions': [
      {
        'id': 0,
        'step': 'Cook the pasta following the pack instructions, add '
            'the chopped broccoli for the final 4 minutes, drain and set aside.',
      },
      {
        'id': 1,
        'step': 'Meanwhile, cook the chopped onion for 5 minutes, then add '
            'in the garlic and cook for another minute.',
      },
      {
        'id': 2,
        'step': 'Add in the ham, cream and mustard and bring to the boil.',
      },
      {
        'id': 3,
        'step': 'Add the pasta and broccoli, '
            'then stir in the cheese and serve.',
      },
    ],
    'ingredients': [
      {'id': 0, 'amount': '300', 'measurement': 'g', 'name': 'Pasta'},
      {'id': 1, 'amount': '1', 'measurement': 'item/s', 'name': 'Broccoli'},
      {'id': 2, 'amount': '1', 'measurement': 'item/s', 'name': 'Onion'},
      {
        'id': 3,
        'amount': '2',
        'measurement': 'item/s',
        'name': 'Garlic Cloves'
      },
      {'id': 4, 'amount': '250', 'measurement': 'g', 'name': 'Ham'},
      {'id': 5, 'amount': '300', 'measurement': 'ml', 'name': 'Double Cream'},
      {'id': 6, 'amount': '15', 'measurement': 'ml', 'name': 'Mustard'},
      {'id': 7, 'amount': '140', 'measurement': 'g', 'name': 'Cheese'},
    ],
  },
  {
    'name': 'Tuna and Sweetcorn Fishcakes',
    'preparationTime': 40,
    'cost': 2,
    'instructions': [
      {
        'id': 0,
        'step': 'Cook the potatoes in salted boiling water until very tender'
            ', drain and allow to steam dry.',
      },
      {
        'id': 1,
        'step': 'Add to a bowl, season and mash. Then stir in the mayonnaise, '
            'tuna and sweetcorn and shape into 4 cakes and chill until firm.',
      },
      {
        'id': 2,
        'step': 'Dip each cake in the beaten eggs, let excess to drip off then '
            'coat in breadcrumbs and chill for a further 15 minutes.',
      },
      {
        'id': 3,
        'step': 'Gently fry the cakes for 2-3 minutes on '
            'each side until golder and serve.',
      },
    ],
    'ingredients': [
      {'id': 0, 'amount': '450', 'measurement': 'g', 'name': 'Potato'},
      {'id': 1, 'amount': '30', 'measurement': 'g', 'name': 'Mayonnaise'},
      {'id': 2, 'amount': '2', 'measurement': 'item/s', 'name': 'Tuna'},
      {'id': 3, 'amount': '1', 'measurement': 'item/s', 'name': 'Sweetcorn'},
      {'id': 4, 'amount': '2', 'measurement': 'item/s', 'name': 'Eggs'},
      {'id': 5, 'amount': '100', 'measurement': 'g', 'name': 'Breadcrumbs'},
    ],
  },
  {
    'name': 'Tandoori Chicken Curry',
    'preparationTime': 45,
    'cost': 2,
    'instructions': [
      {
        'id': 0,
        'step': 'Mix together 75g of the yoghurt with half of the spice mix, '
            'add the chicken and leave to marinate '
            'for between 15 minutes to overnight.',
      },
      {
        'id': 1,
        'step': 'Heat the remaining spice, chopped onion and a good splash'
            ' of water and soften for 5 minutes, stirring ofter.',
      },
      {
        'id': 2,
        'step': 'Tip in the chopped pepper and passata and leave to simmer.',
      },
      {
        'id': 3,
        'step': 'Grill the chicken under a high heat until the edges start'
            ' to char, add back into the sauce with most of the chopped'
            ' coriander and leave to simmer.',
      },
      {
        'id': 4,
        'step': 'Cook the rice and peas following packaging instructions, '
            'then serve with the chicken and remaining yoghurt, sprinkle '
            'with the remaining coriander',
      },
    ],
    'ingredients': [
      {'id': 0, 'amount': '100', 'measurement': 'g', 'name': 'Coconut Yoghurt'},
      {
        'id': 1,
        'amount': '30',
        'measurement': 'g',
        'name': 'Tandoori Spice Mix'
      },
      {
        'id': 2,
        'amount': '2',
        'measurement': 'item/s',
        'name': 'Chicken Breast'
      },
      {'id': 3, 'amount': '1', 'measurement': 'item/s', 'name': 'Onion'},
      {'id': 4, 'amount': '1', 'measurement': 'item/s', 'name': 'Red Pepper'},
      {'id': 5, 'amount': '250', 'measurement': 'ml', 'name': 'Passata'},
      {'id': 6, 'amount': '250', 'measurement': 'g', 'name': 'Rice'},
      {'id': 7, 'amount': '100', 'measurement': 'g', 'name': 'Peas'},
      {
        'id': 8,
        'amount': '1',
        'measurement': 'item/s',
        'name': 'Bunched Coriander'
      },
    ],
  },
  {
    'name': 'Chicken Fajitas',
    'preparationTime': 25,
    'cost': 2,
    'instructions': [
      {
        'id': 0,
        'step': 'Heat oven to 200C and wrap the tortillas in foil.',
      },
      {
        'id': 1,
        'step': 'Mix the smoked paprika, coriander, cumin, crushed garlic,'
            ' some olive oil, the juice of 1 lime and tabasco together with'
            ' some salt and pepper.',
      },
      {
        'id': 2,
        'step': 'Stir the finely sliced breasts, finely sliced onion, sliced '
            'red pepper and finely sliced chilli into the marinade.',
      },
      {
        'id': 3,
        'step': 'Add the chicken and marinade into the pan, cooking on a high'
            ' heat until charred and the chicken is cooked',
      },
      {
        'id': 4,
        'step': 'Heat the tortillas in the over, then serve with the chicken, '
            'salad and salsa',
      },
    ],
    'ingredients': [
      {'id': 0, 'amount': '100', 'measurement': 'g', 'name': 'Coconut Yoghurt'},
      {'id': 1, 'amount': '1', 'measurement': 'item/s', 'name': 'Red Onion'},
      {
        'id': 2,
        'amount': '2',
        'measurement': 'item/s',
        'name': 'Chicken Breast'
      },
      {'id': 3, 'amount': '1', 'measurement': 'item/s', 'name': 'Red Chilli'},
      {'id': 4, 'amount': '1', 'measurement': 'item/s', 'name': 'Red Pepper'},
      {'id': 5, 'amount': '20', 'measurement': 'g', 'name': 'Smoked Paprika'},
      {'id': 6, 'amount': '15', 'measurement': 'g', 'name': 'Ground Cumin'},
      {
        'id': 7,
        'amount': '2',
        'measurement': 'item/s',
        'name': 'Garlic Cloves'
      },
      {'id': 8, 'amount': '1', 'measurement': 'item/s', 'name': 'Lime'},
      {'id': 9, 'amount': '10', 'measurement': 'ml', 'name': 'Tabasco'},
      {'id': 10, 'amount': '6', 'measurement': 'item/s', 'name': 'Tortillas'},
      {'id': 11, 'amount': '1', 'measurement': 'item/s', 'name': 'Salad'},
      {'id': 12, 'amount': '1', 'measurement': 'item/s', 'name': 'Salsa'},
    ],
  },
];
