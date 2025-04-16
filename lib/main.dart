import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handyman_bbk_panel/firebase_options.dart';
import 'package:handyman_bbk_panel/modules/jobs/jobs_page.dart';
import 'package:handyman_bbk_panel/modules/login/bloc/login_bloc.dart';
import 'package:handyman_bbk_panel/modules/splash%20screen/splash_screen.dart';
import 'package:handyman_bbk_panel/styles/color.dart';
import 'package:hive_flutter/hive_flutter.dart';

const myBox = "myBox";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox(myBox);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final box = Hive.box(myBox);
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Handyman Panel',
        theme: ThemeData(
          scaffoldBackgroundColor: AppColor.white,
          useMaterial3: true,
        ),
        home: JobsPage(),
      ),
    );
  }
}
