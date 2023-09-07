import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            _buildTermsAndConditions(),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTerm(
          '1. Introduction',
          'Welcome to Manoy App! By accessing or using our app, you agree to comply with and be bound by these terms and conditions. If you do not agree with these terms, please do not use our app.',
        ),
        _buildTerm(
          '2. User Registration',
          'To use our app\'s services, users and service providers must register with accurate and complete information. You are responsible for maintaining the confidentiality of your account and password.',
        ),
        _buildTerm(
          '3. Service Listings',
          'Service providers can list their services on our app. All service listings must accurately represent the services offered.',
        ),
        _buildTerm(
          '4. Booking and Appointments',
          "Users can book appointments with service providers through our app. Availability is subject to the service provider's schedule. Cancellation and rescheduling policies may apply.",
        ),
        _buildTerm(
          '5. Payments',
          'Payments for services may be made directly to service providers.',
        ),
        _buildTerm(
          '6. User Conduct',
          'Users must not engage in illegal, abusive, or harmful activities on our app. Violation of this rule may result in account suspension or termination.',
        ),
        _buildTerm(
          '7. Service Provider Verification',
          'Service providers must undergo a verification process to be listed on our app. They must meet certain criteria to ensure the quality and legitimacy of their services.',
        ),
        _buildTerm(
          '8. Liability and Disclaimers',
          'Our app connects users with service providers, but we are not responsible for the services provided. We disclaim liability for any damages, losses, or injuries resulting from using our app or its services.',
        ),
        _buildTerm(
          '9. Privacy and Data Usage',
          'We collect and use user data as described in our Privacy Policy. By using our app, you consent to our data practices outlined in the Privacy Policy.',
        ),
        _buildTerm(
          '10. Intellectual Property',
          'All content on our app, including text, images, and logos, is owned by us. Users must not use, copy, or distribute our content without permission.',
        ),
        _buildTerm(
          '11. Termination',
          'We reserve the right to terminate user accounts or access to our app for violations of these terms. Users can also terminate their accounts at any time.',
        ),
        _buildTerm(
          '12. Changes to Terms',
          'We may update or modify these terms and conditions. Users will be notified of changes, and their continued use of the app constitutes acceptance of the modified terms.',
        ),
      ],
    );
  }

  Widget _buildTerm(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(content),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
