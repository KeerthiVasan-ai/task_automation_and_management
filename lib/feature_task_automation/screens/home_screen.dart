import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_automation_and_management_system/feature_github_repo/blocs/repo_bloc.dart';
import 'package:task_automation_and_management_system/feature_github_repo/screens/repository_screen.dart';

import '../../feature_issue_ticket/blocs/ticket_bloc.dart';
import '../../feature_issue_ticket/blocs/ticket_event.dart';
import '../../feature_issue_ticket/repository/ticket_repository.dart';
import '../../feature_issue_ticket/screens/ticket_list_screen.dart';
import '../service/send_error_report.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo, Colors.lightBlueAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Task Automation and Management System",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                _buildHomeButton(
                  context,
                  label: "Send Email",
                  icon: Icons.email_outlined,
                  onPressed: () async {
                    await sendErrorReport();
                  },
                ),
                const SizedBox(height: 16),
                _buildHomeButton(
                  context,
                  label: "Go to Ticket Screen",
                  icon: Icons.list_alt,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => TicketBloc(TicketRepository())
                            ..add(FetchTicketsEvent()),
                          child: const TicketListScreen(),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildHomeButton(
                  context,
                  label: "Go to Repo Screen",
                  icon: Icons.storage_outlined,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: BlocProvider.of<RepositoryBloc>(context),
                          child: const RepositoryScreen(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.indigo,
        elevation: 5,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
