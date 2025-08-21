import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:udemy_course/helper/firebase_services/auth_gate.dart';
import 'package:udemy_course/pages/chat_app/home_chat.dart';
import 'package:udemy_course/pages/chat_app/login.dart';
import 'package:udemy_course/pages/chat_app/sign_up.dart';
import 'package:udemy_course/pages/expense_tracker/expense_dashboard.dart';
import 'package:udemy_course/pages/expense_tracker/new_expense.dart';
import 'package:udemy_course/pages/favorite_places/places_list.dart';
import 'package:udemy_course/pages/home.dart';
import 'package:udemy_course/pages/meals/category_screen.dart';
import 'package:udemy_course/pages/meals/favorite_meal.dart';
import 'package:udemy_course/pages/meals/filtered_meals_screen.dart';
import 'package:udemy_course/pages/meals/meals_screen.dart';
import 'package:udemy_course/pages/meals/setting_filter.dart';
import 'package:udemy_course/pages/quiz/quiz.dart';
import 'package:udemy_course/pages/quiz/result_quiz.dart';
import 'package:udemy_course/pages/shopping_list/shopping_screen.dart';
import 'package:udemy_course/providers/chat_app_provider.dart';
import 'package:udemy_course/providers/expense_provider.dart';
import 'package:udemy_course/providers/meals_provider.dart';
import 'package:udemy_course/providers/places_provider.dart';
import 'package:udemy_course/providers/quiz_provider.dart';
import 'package:udemy_course/providers/shopping_provider.dart';
import 'package:udemy_course/widgets/meals/meal_detail.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //
  await dotenv.load(fileName: ".env");
  //
  runApp(const MyApp());
}

///
var kColorScheme = ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent);

///
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => QuizProvider()),
        ChangeNotifierProvider(create: (context) => ExpenseProvider()),
        ChangeNotifierProvider(create: (context) => MealsProvider()),
        ChangeNotifierProvider(create: (context) => ShoppingProvider()),
        ChangeNotifierProvider(create: (context) => PlacesProvider()),
        ChangeNotifierProvider(create: (context) => ChatAppProvider()),
      ],
      child: MaterialApp(
        title: 'Udemy Courses',
        theme: ThemeData().copyWith(
          //
          colorScheme: kColorScheme,

          //
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: Colors.white,
          ),

          //
          textTheme: GoogleFonts.manropeTextTheme(),

          //
          popupMenuTheme: const PopupMenuThemeData().copyWith(
            shadowColor: Colors.grey.withValues(alpha: 0.5),
          ),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          // Home route
          "/": (context) => const Home(),
          // Quiz routes here
          "/quiz": (context) => const Quiz(),
          "/result": (context) => const ResultQuiz(),
          // Expense tracker routes here
          "/expTrackerDashboard": (context) => const ExpenseDashboard(),
          "/newExpense": (context) => const NewExpense(),
          // Meals routes here
          "/mealsCategory": (context) => const CategoryScreen(),
          "/mealsScreen": (context) => const MealsScreen(),
          "/mealDetail": (context) => const MealDetail(),
          "/favMeal": (context) => const FavoriteMeal(),
          "/settingFilter": (context) => const SettingFilter(),
          "/filteredMeals": (context) => const FilteredMealsScreen(),
          // Shopping routes here
          "/shopping": (context) => const ShoppingScreen(),
          // Favorite places routes here
          "/placesList": (context) => const PlacesList(),
          // Chat app routes here
          "/login": (context) => const Login(),
          "/signup": (context) => const SignUp(),
          "/authGate": (context) => const AuthGate(),
          "/homeChat": (context) => const HomeChat(),
        },
      ),
    );
  }
}
