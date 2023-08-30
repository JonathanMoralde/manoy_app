import 'package:flutter/material.dart';
import 'package:manoy_app/widgets/styledTextfield.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactInfoPage extends StatefulWidget {
  final String userId;
  const ContactInfoPage({super.key, required this.userId});

  @override
  State<ContactInfoPage> createState() => _ContactInfoPageState();
}

class _ContactInfoPageState extends State<ContactInfoPage> {
  final contactController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CONTACT INFORMATION'),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Center(
                child: Image.asset(
                  'lib/images/logo.png',
                  width: 250,
                  height: 250,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Welcome to Manoy!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Your nearby shop locator for automobile services in Polangui, Albay. Whether you're in need of repairs, maintenance, or just seeking the best service provider, Manoy! has got you covered.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                "Our app offers real-time location tracking using GPS technology, ensuring you find the most convenient and reliable workshops near you. With features like real-time messaging, service postings, appointment scheduling, and user ratings, we're here to enhance your automotive service experience.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                "Business owners can post updates and promotions directly to the app, engaging with their customer base effectively. Moreover, users can leave ratings and reviews, fostering trust and transparency within the community. By harnessing the power of Flutter and Firebase, 'Manoy!' elevates the automobile service experience, making it a win-win for users seeking top-notch services and local businesses striving for growth and success.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              // StyledTextField(
              //   controller: contactController,
              //   hintText: 'Enter your contact information...',
              // ),
              Text('HOW TO CONTACT US? REFER TO THE LINKS BELOW',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(height: 10),

              GestureDetector(
                onTap: () async {
                  const facebookUrl =
                      'https://www.facebook.com/jonnel.red.1'; // Replace with your Facebook page URL
                  if (await canLaunch(facebookUrl)) {
                    await launch(facebookUrl);
                  } else {
                    throw 'Could not launch $facebookUrl';
                  }
                },
                child: Text(
                  'Visit Jonnel Angelo Red',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  const facebookUrl =
                      'https://www.facebook.com/arvinjay.ong.98'; // Replace with your Facebook page URL
                  if (await canLaunch(facebookUrl)) {
                    await launch(facebookUrl);
                  } else {
                    throw 'Could not launch $facebookUrl';
                  }
                },
                child: Text(
                  'Visit Arvin Jay Ong',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  const facebookUrl =
                      'https://www.facebook.com/manuel.adol'; // Replace with your Facebook page URL
                  if (await canLaunch(facebookUrl)) {
                    await launch(facebookUrl);
                  } else {
                    throw 'Could not launch $facebookUrl';
                  }
                },
                child: Text(
                  'Visit Manuel Adol',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
