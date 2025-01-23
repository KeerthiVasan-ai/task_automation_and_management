import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_automation_and_management_system/auth/screens/google_signIn_screen.dart';
import 'package:task_automation_and_management_system/feature_github_repo/blocs/repo_bloc.dart';
import 'package:task_automation_and_management_system/feature_task_automation/service/send_error_report.dart';
import 'package:workmanager/workmanager.dart';

import 'auth/blocs/auth_bloc.dart';
import 'db/db_helper.dart';
import 'feature_issue_ticket/blocs/ticket_bloc.dart';
import 'feature_issue_ticket/repository/ticket_repository.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == 'sendDailyEmail') {
      debugPrint('Executing sendDailyEmail task...');
      try {
        await sendErrorReport();
        debugPrint('Periodic task executed successfully.');
      } catch (e) {
        debugPrint('Error in executing periodic task: $e');
      }
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await DBHelper.instance.database;
  await DBHelper.instance.insertSampleData();

  DateTime now = DateTime.now();
  DateTime firstRun = DateTime(now.year, now.month, now.day, 12, 5);
  if (now.isAfter(firstRun)) {
    firstRun = firstRun.add(const Duration(days: 1));
  }
  Duration initialDelay = firstRun.difference(now);

  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  Workmanager().registerPeriodicTask(
    '1',
    'sendDailyEmail',
    initialDelay: initialDelay,
    frequency: const Duration(hours: 24),
    inputData: {
      'task': 'sendDailyEmail',
    },
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => TicketBloc(TicketRepository())),
        BlocProvider(create: (context) => RepositoryBloc())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Automation and Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const GoogleSignInScreen(),
    );
  }
}
