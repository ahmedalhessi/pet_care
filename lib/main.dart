import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pets_app/bloc/bloc/api_bloc.dart';
import 'package:pets_app/screens/explore_screen.dart';
import '/bloc/bloc/pet_bloc.dart';
import '/bloc/bloc/tool_bloc.dart';
import '/bloc/bloc/vaccine_bloc.dart';
import '/bloc/states/pet_crud_state.dart';
import '/bloc/states/tool_crud_state.dart';
import '/bloc/states/vaccine_crud_state.dart';
import '/database/db_controller.dart';
import '/preferences/shared_pref_controller.dart';
import '/screens/pet_details/add_pet_screen.dart';
import '/screens/auth/login_screen.dart';
import '/screens/auth/register_screen.dart';
import '/screens/home_screen.dart';
import '/screens/tools/add_tool_screen.dart';
import '/screens/tools/all_tools_screen.dart';
import '/screens/vaccines/add_vaccine_screen.dart';
import '/screens/splash_screen.dart';
import '/screens/vaccines/all_vaccines_screen.dart';
import 'api/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefController().initPref();
  await DbController().initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PetBloc(PetLoadingState())),
        BlocProvider(create: (context) => VaccineBloc(VaccineLoadingState())),
        BlocProvider(create: (context) => ToolBloc(ToolLoadingState())),
        BlocProvider(create: (context) => CatApiBloc(ApiService())),
        // BlocProvider(
        //     create: (context) => PetVaccineBloc(PetVaccineLoadingState())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            foregroundColor: Color(0xFFFFDEDE),
            color: Color(0xFFEB4747),
            iconTheme: IconThemeData(color: Color(0xFFFFDEDE)),
          ),
          scaffoldBackgroundColor: const Color(0xFFECECEC),
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: GoogleFonts.nunito(),
            floatingLabelStyle: textStyle,
            labelStyle: textStyle,
            enabledBorder: outlineInputBorder,
            focusedBorder: outlineInputBorder,
          ),
        ),
        initialRoute: '/splash_screen',
        routes: {
          '/splash_screen': (context) => const SplashScreen(),
          '/login_screen': (context) => const LoginScreen(),
          '/register_screen': (context) => const RegisterScreen(),
          '/home_screen': (context) => const HomeScreen(),
          '/add_pet_screen': (context) => const AddPetScreen(),
          '/all_vaccines_screen': (context) => const AllVaccinesScreen(),
          '/add_vaccine_screen': (context) => const AddVaccineScreen(),
          '/all_tools_screen': (context) => const AllToolsScreen(),
          '/add_tool_screen': (context) => const AddToolScreen(),
          '/explore_pets': (context) => const ExploreScreen(),
        },
      ),
    );
  }

  OutlineInputBorder get outlineInputBorder {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: const BorderSide(width: 1, color: Color(0xFFEB4747)),
    );
  }

  TextStyle get textStyle {
    return const TextStyle(color: Color(0xFFEB4747));
  }
}
