import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Map<String, dynamic>? _userInformation;

  Map<String, dynamic>? get userInformation => _userInformation;

  Future<Map<String, dynamic>?> loadUserInformation() async {
    final users = _db.collection("users");
    final doc = await users.doc(_auth.currentUser?.uid).get();
    try {
      if (doc.data() == null) {
        notifyListeners();
        return null;
      }
      final data = doc.data() as Map<String, dynamic>;
      _userInformation = data;
      notifyListeners();
      return data;
    } catch (e) {
      print("Error getting document: $e");
      notifyListeners();
      return null;
    }
  }

  Future<void> setUsername(String username) async {
    final data = {
      "name": username,
    };
    final users = _db.collection("users");
    final doc = await users.doc(_auth.currentUser?.uid).set(
          data,
          SetOptions(
            merge: true,
          ),
        );
    loadUserInformation();
  }
}
