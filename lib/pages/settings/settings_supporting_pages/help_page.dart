import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 40,
              ),
              child: Image.asset(
                "lib/images/logo.png",
                scale: 2,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Welcome to Manoy App\'s Help Page',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'We\'re here to assist you in getting the most out of our application. If you have any questions or encounter any issues, our customer support team is ready to help.',
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Contact Customer Support',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const ListTile(
              title: Text('Email: support@manoyapp.com'),
              subtitle: Text(
                  'Response Time: We aim to respond within 24 hours on weekdays.'),
            ),
            const SizedBox(height: 20.0),
            const Divider(),
            const SizedBox(height: 20.0),
            const Text(
              'Frequently Asked Questions (FAQs)',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const FAQItem(
              question: 'How do I create a new account?',
              answer: 'To create a new account, follow these steps:\n'
                  '1. Open the app.\n'
                  '2. Tap on "Sign Up" on the main screen.\n'
                  '3. Fill in your details and follow the prompts to complete the registration process.',
            ),
            const FAQItem(
              question: 'How can I change my profile picture?',
              answer: 'Changing your profile picture is easy:\n'
                  '1. Go to your profile settings.\n'
                  '2. Select "Change Profile Picture" and choose an image from your gallery.',
            ),
            const FAQItem(
              question: 'I forgot my password. What should I do?',
              answer: 'If you\'ve forgotten your password, don\'t worry:\n'
                  '1. On the login screen, tap "Forgot Password?"\n'
                  '2. Enter your email address and follow the instructions in the password reset email.',
            ),
            const FAQItem(
              question: 'What should I do if the app crashes?',
              answer: 'If the app crashes unexpectedly:\n'
                  '- Make sure you have the latest app version installed.\n'
                  '- Try restarting your device.\n'
                  '- If the issue persists, email our support team at support@manoyapp.com with details about the problem.',
            ),
            const FAQItem(
              question: 'How can I provide feedback or suggest features?',
              answer: 'We value your feedback and suggestions! Feel free to:\n'
                  '- Email us at feedback@manoyapp.com.',
            ),
            const SizedBox(height: 20.0),
            const Text(
              'We hope this help page answers your questions. If you need further assistance, don\'t hesitate to reach out to our customer support team at support@manoyapp.com.',
            ),
          ],
        ),
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const FAQItem({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10.0),
        Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5.0),
        Text(answer),
        const Divider(),
      ],
    );
  }
}

void main() {
  runApp(const MaterialApp(home: HelpPage()));
}
