
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_service.dart';
import 'second_survey.dart';

class GeneratorPage extends StatefulWidget {
  @override
  State<GeneratorPage> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  String? selectedOption; 
  List yesVotes = []; 
  int noVotes = 0; 
  final FirebaseService firebaseService = FirebaseService();

  void submitVote() {
    if (selectedOption != null) {
      setState(() {
        if (selectedOption == 'yes') {
          firebaseService.addVoteSera(selectedOption);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SecondSurveyPage()),
          );
        } else if (selectedOption == 'no') {
          firebaseService.addVoteSera(selectedOption);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Stacca il cuscino')));
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Chi cazzo c\'è stasera?',
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
                        Icon(Icons.favorite),
                        Text(' Ci sono'),
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
                    child: Text('🐸 Non ci sono'),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: selectedOption == null
                    ? null
                    : () => submitVote(),
                child: Text('Invia risposta'),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Risultati del sondaggio:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: firebaseService.getDailyVotesCosa(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                List centroVotes = [];
                List baraccaVotes = [];
                List pingVotes = [];
                for (var doc in snapshot.data!.docs) {
                  String displayName= doc['displayName'];
                  String vote = doc['vote'];
                  if (vote == 'yes') {
                    centroVotes.add(displayName);
                  } else if (vote == 'no'){
                    baraccaVotes.add(displayName);
                  }
                }
                return Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.local_bar),
                      title: Text('Centro'),
                      trailing: Text(centroVotes.isNotEmpty ? centroVotes.join(', ') : 'Nessun voto'),
                      ),
                      ListTile(
                        leading: Icon(Icons.wine_bar),
                        title: Text('Baracca'),
                        trailing: Text(baraccaVotes.isNotEmpty ? baraccaVotes.join(', ') : 'Nessun voto'),
                      ),
                      ListTile(
                        leading: FaIcon(FontAwesomeIcons.tableTennisPaddleBall),
                        title: Text('Ping pong'),
                        trailing: Text(pingVotes.isNotEmpty ? pingVotes.join(', ') : 'Nessun voto'),
                      ),
                    ],
                  );
                }
              ),
          ],
        ),
      ),
    );
  }
}
