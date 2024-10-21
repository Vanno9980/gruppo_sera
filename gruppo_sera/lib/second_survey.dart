import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'firebase_service.dart';

class SecondSurveyPage extends StatefulWidget {
  @override
  State<SecondSurveyPage> createState() => _SecondSurveyPageState();
}

class _SecondSurveyPageState extends State<SecondSurveyPage> {
  String? selectedOption;
  final FirebaseService firebaseService = FirebaseService();

  void submitSecondVote() {
    if (selectedOption != null) {
      setState(() {
        if (selectedOption == 'yes'){
          firebaseService.addVoteCosa(selectedOption);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bravo scemo')));
        }
        if (selectedOption == 'no'){
          firebaseService.addVoteCosa(selectedOption);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Un po\' morto, ma ti rispetto')));
        }
        if (selectedOption == 'maybe'){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TrollPage()),
          );
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OPS')));
        }
        selectedOption = null;
      });
    }
  }

  ButtonStyle getButtonStyle(String option) {
    return TextButton.styleFrom(
      backgroundColor: selectedOption == option ? Colors.deepOrange : Colors.grey[200],
      foregroundColor: selectedOption == option ? Colors.white : Colors.black,
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Hai staccato')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Che cazzo facciamo?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedOption = 'yes';
                      });
                    },
                    style: getButtonStyle('yes'),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.local_bar),
                        Text('Centro'),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedOption = 'no';
                      });
                    },
                    style: getButtonStyle('no'),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.wine_bar),
                        Text('Baracca'),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedOption = 'maybe';
                      });
                    },
                    style: getButtonStyle('maybe'),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(FontAwesomeIcons.tableTennisPaddleBall),
                        Text('Ping pong'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: selectedOption == null
                    ? null
                    : () => submitSecondVote(),  
                child: Text('Invia risposta'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrollPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sei stato trollato')),
      body: Center(
              child: Image.asset('assets/images/troll.jpg'),
            ),
      );
  }
}