import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handyman_bbk_panel/firebase_options.dart';
import 'package:handyman_bbk_panel/modules/login/bloc/login_bloc.dart';
import 'package:handyman_bbk_panel/modules/products/bloc/products_bloc.dart';
import 'package:handyman_bbk_panel/modules/profile/bloc/profile_bloc.dart';
import 'package:handyman_bbk_panel/modules/splash%20screen/splash_screen.dart';
import 'package:handyman_bbk_panel/modules/workers/bloc/workers_bloc.dart';
import 'package:handyman_bbk_panel/styles/color.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

const myBox = "myBox";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox(myBox);
  final savedLocale = ProfileBloc.getSavedLocale();
  runApp(MyApp(initialLocale: savedLocale));
}

class MyApp extends StatelessWidget {
  static final box = Hive.box(myBox);
  final Locale initialLocale;
  const MyApp({super.key, required this.initialLocale});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
        BlocProvider<ProductsBloc>(create: (context) => ProductsBloc()),
        BlocProvider<WorkersBloc>(create: (context) => WorkersBloc()),
        BlocProvider<ProfileBloc>(create: (context) => ProfileBloc()),
      ],
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Handyman Panel',
            theme: ThemeData(
              scaffoldBackgroundColor: AppColor.white,
              useMaterial3: true,
            ),
            locale: state.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('ar')],
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}
