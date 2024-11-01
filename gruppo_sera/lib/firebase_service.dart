import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addVoteSera(String? selectedOption) async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      String userId = currentUser.uid; 
      String? displayName = currentUser.displayName ?? 'Anonimo'; 

      CollectionReference votes = _firestore.collection('voti_sera');

      QuerySnapshot existingVotes = await _firestore.collection('voti_sera')
        .where('userId', isEqualTo: userId)
        .get();

      DateTime now = DateTime.now();
      DateTime startOfDay = DateTime(now.year, now.month, now.day);
      QuerySnapshot existingVotesDay = await _firestore.collection('voti_sera')
        .where('userId', isEqualTo: userId)
        .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
        .get();

      QuerySnapshot existingVotesSecond = await _firestore.collection('voti_attivita')
        .where('userId', isEqualTo: userId)
        .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
        .get();
      
      if (existingVotes.docs.isNotEmpty) {
        for (var vote in existingVotes.docs){
          await votes.doc(vote.id).update({
            'displayName': displayName, 
          });
        }
      }

      if (existingVotesDay.docs.isNotEmpty) {
        String voteId = existingVotesDay.docs.first.id;
        await votes.doc(voteId).update({
          'vote': selectedOption,
          'timestamp': FieldValue.serverTimestamp(),  
        });
        if (selectedOption=='no' && existingVotesSecond.docs.isNotEmpty){
          String secondVote = existingVotesSecond.docs.first.id;
          await _firestore.collection('voti_attivita').doc(secondVote).delete();
        }
      } else {
        await votes.add({
          'userId': userId,
          'displayName': displayName,  
          'vote': selectedOption,  
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } else {
      print('Utente non autenticato');
    }
  }

  Future<void> addVoteCosa(String? selectedOption) async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      String userId = currentUser.uid; 
      String? displayName = currentUser.displayName ?? 'Anonimo'; 

      CollectionReference votes = _firestore.collection('voti_attivita');

      DateTime now = DateTime.now();
      DateTime startOfDay = DateTime(now.year, now.month, now.day);
      QuerySnapshot existingVotes = await _firestore.collection('voti_attivita')
        .where('userId', isEqualTo: userId)
        .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
        .get();

      if (existingVotes.docs.isNotEmpty) {
        String voteId = existingVotes.docs.first.id;
        await votes.doc(voteId).update({
          'displayName': displayName,  
          'vote': selectedOption,
          'timestamp': FieldValue.serverTimestamp(),  
        });
      } else {
        await votes.add({
          'userId': userId,
          'displayName': displayName,  
          'vote': selectedOption,  
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } else {
      print('Utente non autenticato');
    }
  }

  Future<void> addVoteC(String? selectedOptionC) async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      String userId = currentUser.uid; 
      String? displayName = currentUser.displayName ?? 'Anonimo'; 

      CollectionReference votes = _firestore.collection('voti_calcetto');

      DateTime now = DateTime.now();
      DateTime startOfDay = DateTime(now.year, now.month, now.day);
      QuerySnapshot existingVotes = await _firestore.collection('voti_calcetto')
        .where('userId', isEqualTo: userId)
        .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
        .get();

      if (existingVotes.docs.isNotEmpty) {
        String voteId = existingVotes.docs.first.id;
        await votes.doc(voteId).update({
          'displayName': displayName,  
          'vote': selectedOptionC,
          'timestamp': FieldValue.serverTimestamp(),  
        });
      } else {
        await votes.add({
          'userId': userId,
          'displayName': displayName,  
          'vote': selectedOptionC,  
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } else {
      print('Utente non autenticato');
    }
  }

  Stream<QuerySnapshot> getTotalVotesSera() {
    return _firestore.collection('voti_sera')
      .where('vote', isEqualTo: 'yes')
      .snapshots();
  }

  Stream<QuerySnapshot> getDailyVotesCosa() {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);

    return _firestore.collection('voti_attivita')
      .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
      .snapshots();
  }

  Stream<QuerySnapshot> getDailyVotesC() {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);

    return _firestore.collection('voti_calcetto')
      .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
      .snapshots();
  }

  Stream<QuerySnapshot> getTotalVotesC() {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);

    print('Query voti sera dal: $startOfDay');

    return _firestore.collection('voti_calcetto')
      .where('vote', isEqualTo: 'yes')
      .snapshots();
  }
}
