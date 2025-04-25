import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handyman_bbk_panel/firebase_options.dart';
import 'package:handyman_bbk_panel/modules/banners/bloc/banner_bloc.dart';
import 'package:handyman_bbk_panel/modules/home/bloc/location_bloc.dart';
import 'package:handyman_bbk_panel/modules/login/bloc/login_bloc.dart';
import 'package:handyman_bbk_panel/modules/orders/bloc/orders_bloc.dart';
import 'package:handyman_bbk_panel/modules/products/bloc/products_bloc.dart';
import 'package:handyman_bbk_panel/modules/profile/bloc/profile_bloc.dart';
import 'package:handyman_bbk_panel/modules/splash%20screen/splash_screen.dart';
import 'package:handyman_bbk_panel/modules/workers/bloc/workers_bloc.dart';
import 'package:handyman_bbk_panel/services/locator_services.dart';
import 'package:handyman_bbk_panel/styles/color.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const myBox = "myBox";
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Handle background notifications
}

Future<void> _initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
  // Setup foreground message handler
  setupForegroundMessageHandler();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize notifications
  await _initializeNotifications();

  // Initialize Hive storage
  await Hive.initFlutter();
  await Hive.openBox(myBox);

  // Get saved locale
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
        BlocProvider<LocationBloc>(
          create: (context) => LocationBloc(LocationService()),
        ),
        BlocProvider<BannerBloc>(
          create: (context) => BannerBloc(),
        ),
        BlocProvider<OrdersBloc>(
          create: (context) => OrdersBloc(),
        ),
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

// Setup foreground message handler
void setupForegroundMessageHandler() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    if (message.notification != null) {
      // Show notification when the app is in the foreground
      await _showNotification(message.notification!);
    }
  });
}

// Show local notification
Future<void> _showNotification(RemoteNotification notification) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'handyman_channel', // Channel ID
    'Handyman Notifications', // Channel Name
    channelDescription: 'Notifications related to handyman tasks and updates',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformDetails = NotificationDetails(
    android: androidDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    notification.hashCode,
    notification.title,
    notification.body,
    platformDetails,
  );
}
