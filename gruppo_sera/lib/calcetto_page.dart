import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_service.dart';

class CalcettoPage extends StatefulWidget {
  @override
  State<CalcettoPage> createState() => _CalcettoPageState();
}

class _CalcettoPageState extends State<CalcettoPage> {

  String? selectedOptionC; 
  final FirebaseService firebaseService = FirebaseService();

  void submitVote() {
    if (selectedOptionC != null) {
      setState(() {
        if (selectedOptionC == 'yes') {
          firebaseService.addVoteC(selectedOptionC);
        } else if (selectedOptionC == 'no') {
          firebaseService.addVoteC(selectedOptionC);
        } 
        selectedOptionC = null;
      });
    }
  }

  ButtonStyle getButtonStyle(String option) {
    return TextButton.styleFrom(
      backgroundColor: selectedOptionC == option ? Colors.deepOrange : Colors.grey[200],
      foregroundColor: selectedOptionC == option ? Colors.white : Colors.black,
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
              'Chi cazzo c\'è al calcetto?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedOptionC = 'yes';
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
                        selectedOptionC = 'no';
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
                onPressed: selectedOptionC == null
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
              stream: firebaseService.getDailyVotesC(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                List yesVotesC = [];
                List noVotesC = [];
                for (var doc in snapshot.data!.docs) {
                  String displayName= doc['displayName'];
                  String vote = doc['vote'];
                  if (vote == 'yes') {
                    yesVotesC.add(displayName);
                  } else {
                    noVotesC.add(displayName);
                  }
                }
                return Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.check_circle, color: Colors.green),
                      title: Text('Partecipo'),
                      trailing: Text(yesVotesC.isNotEmpty ? yesVotesC.join(', ') : 'Nessun voto'),
                      ),
                      ListTile(
                        leading: Icon(Icons.cancel, color: Colors.red),
                        title: Text('Non partecipo'),
                        trailing: Text(noVotesC.isNotEmpty ? noVotesC.join(', ') : 'Nessun voto'),
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