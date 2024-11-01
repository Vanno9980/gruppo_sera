import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_service.dart';

class ClassificaPage extends StatelessWidget {

final FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Classifica dei morti',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firebaseService.getTotalVotesSera(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
            
                Map<String, int> userVotes = {};
                for (var doc in snapshot.data!.docs) {
                  String displayName= doc['displayName'];
                  userVotes[displayName] = (userVotes[displayName] ?? 0) + 1;
                }
            
                var sortedUsers = userVotes.entries.toList()
                  ..sort((a, b) => a.value.compareTo(b.value));
                
                return ListView.builder(
                  itemCount: sortedUsers.length,
                  itemBuilder: (context, index) {
                    var user = sortedUsers[index];
                    return ListTile(
                      title: Text('Cavallo: ${user.key}'),
                      subtitle: Text('Presenze: ${user.value}'),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Classifica degli sport minori',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firebaseService.getTotalVotesC(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                print('Dati ricevuti: ${snapshot.data!.docs.length} documenti');

                Map<String, int> userVotesC = {};
                for (var doc in snapshot.data!.docs) {
                  String displayName= doc['displayName'];
                  userVotesC[displayName] = (userVotesC[displayName] ?? 0) + 1;
                }
            
                var sortedUsersC = userVotesC.entries.toList()
                  ..sort((a, b) => a.value.compareTo(b.value));
            
                return ListView.builder(
                  itemCount: sortedUsersC.length,
                  itemBuilder: (context, index) {
                    var user = sortedUsersC[index];
                    return ListTile(
                      title: Text('Atleta: ${user.key}'),
                      subtitle: Text('Presenze: ${user.value}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
