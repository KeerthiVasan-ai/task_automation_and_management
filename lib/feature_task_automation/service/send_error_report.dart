import 'package:flutter/cupertino.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:task_automation_and_management_system/feature_task_automation/utils/sharedpreference_helper.dart';

import '../../db/db_helper.dart';

Future<void> sendErrorReport() async {
  final email = await SharedPreferencesHelper.getEmail();
  final accessToken = await SharedPreferencesHelper.getAccessToken();

  if (accessToken == null || email == null) {
    debugPrint('Missing email or accessToken.');
    return;
  }

  final errors = await DBHelper.instance.getErrorRecords();
  if (errors.isEmpty) {
    debugPrint('No error records found.');
    return;
  }

  String emailBody = "The following transactions encountered errors:\n\n";
  for (var record in errors) {
    emailBody +=
        "ID: ${record['TransID']}, Desc: ${record['TransDesc']}, Time: ${record['TransDateTime']}\n";
  }

  final smtpServer = gmailSaslXoauth2(email, accessToken);

  final message = Message()
    ..from = Address(email, 'Task Automation System')
    ..recipients.add('csesmartclass@gmail.com')
    ..subject = 'Daily Error Report'
    ..text = emailBody;

  try {
    final sendReport = await send(message, smtpServer);
    debugPrint('Message sent: ${sendReport.toString()}');
  } catch (e) {
    debugPrint('Message not sent: $e');
  }
}
