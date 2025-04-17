//
//  Data.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 22/03/25.
//

import Foundation

// Dummy Recipe Data
let recipeData: [Recipe] = [
    Recipe(
        id: 1,
        title: "Spaghetti Carbonara",
        ingredients: """
        - 200g spaghetti
        - 100g pancetta
        - 2 large eggs
        - 50g Parmesan cheese
        - Salt and pepper
        """,
        instructions: """
        1. Cook spaghetti in salted water.
        2. Fry pancetta until crispy.
        3. Beat eggs and mix with Parmesan.
        4. Mix spaghetti with pancetta and egg mixture.
        5. Serve immediately.
        """,
        category: "Italian",
        preparationTimeInHours: 02,
        preparationTimeInMinutes: 30,
        images: ["spaghetti_carbonara"],
        isFavourite: false
    ),
    Recipe(
        id: 2,
        title: "Chicken Biryani",
        ingredients: """
        - 300g basmati rice
        - 500g chicken
        - 2 onions, sliced
        - 4 cloves garlic, minced
        - 1 tbsp ginger paste
        - 100g yogurt
        - Spices (garam masala, cumin, coriander)
        """,
        instructions: """
        1. Marinate chicken with yogurt and spices.
        2. Cook onions, garlic, and ginger in a pot.
        3. Add chicken and cook for 15 mins.
        4. Add rice and cook with water until done.
        5. Garnish with coriander and serve.
        """,
        category: "Indian",
        preparationTimeInHours: 01,
        preparationTimeInMinutes: 13,
        images: ["ABC1","rasgulla1"],
        isFavourite: false
    ),
    Recipe(
        id: 3,
        title: "Pancakes",
        ingredients: """
        - 1 cup flour
        - 1 tbsp sugar
        - 1 tsp baking powder
        - 1 cup milk
        - 1 egg
        - 2 tbsp melted butter
        """,
        instructions: """
        1. Mix dry ingredients in a bowl.
        2. Whisk milk, egg, and melted butter.
        3. Combine wet and dry ingredients.
        4. Pour batter onto a hot griddle.
        5. Flip when bubbles form, cook until golden.
        """,
        category: "Breakfast",
        preparationTimeInHours: 01,
        preparationTimeInMinutes: 05,
        images: ["applej uice0","applej uice1","applej uice2"],
        isFavourite: false
    ),
    Recipe(
        id: 4,
        title: "Caesar Salad",
        ingredients: """
        - 1 romaine lettuce
        - 50g Parmesan cheese
        - 100g croutons
        - 2 tbsp Caesar dressing
        - Salt and pepper
        """,
        instructions: """
        1. Chop romaine lettuce.
        2. Add croutons and Parmesan cheese.
        3. Drizzle with Caesar dressing.
        4. Toss gently and serve immediately.
        """,
        category: "Salad",
        preparationTimeInHours: 03,
        preparationTimeInMinutes: 10,
        images: ["caesar_salad"],
        isFavourite: false
    ),
    Recipe(
        id: 5,
        title: "Chocolate Brownie",
        ingredients: """
        - 200g dark chocolate
        - 150g butter
        - 3 eggs
        - 200g sugar
        - 100g flour
        """,
        instructions: """
        1. Melt chocolate and butter together.
        2. Beat eggs and sugar until fluffy.
        3. Mix with melted chocolate and add flour.
        4. Pour into a baking tray and bake.
        5. Allow to cool before serving.
        """,
        category: "Dessert",
        preparationTimeInHours: 02,
        preparationTimeInMinutes: 22,
        images: ["chocolate_brownie"],
        isFavourite: false
    ),
    Recipe(
        id: 6,
        title: "Chocolate Brownie",
        ingredients: """
        - 200g dark chocolate
        - 150g butter
        - 3 eggs
        - 200g sugar
        - 100g flour
        """,
        instructions: """
        1. Melt chocolate and butter together.
        2. Beat eggs and sugar until fluffy.
        3. Mix with melted chocolate and add flour.
        4. Pour into a baking tray and bake.
        5. Allow to cool before serving.
        """,
        category: "Dessert",
        preparationTimeInHours: 00,
        preparationTimeInMinutes: 30,
        images: ["chocolate_brownie"],
        isFavourite: false
    ),
    Recipe(
        id: 7,
        title: "Chocolate Brownie",
        ingredients: """
        - 200g dark chocolate
        - 150g butter
        - 3 eggs
        - 200g sugar
        - 100g flour
        """,
        instructions: """
        1. Melt chocolate and butter together.
        2. Beat eggs and sugar until fluffy.
        3. Mix with melted chocolate and add flour.
        4. Pour into a baking tray and bake.
        5. Allow to cool before serving.
        """,
        category: "Dessert",
        preparationTimeInHours: 02,
        preparationTimeInMinutes: 45,
        images: ["chocolate_brownie"],
        isFavourite: false
    )
]

