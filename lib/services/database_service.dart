import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Singleton
  String? id;

  static final DatabaseService _databaseService = DatabaseService._internal();

  factory DatabaseService(String id) {
    _databaseService.id = id;
    return _databaseService;
  }

  DatabaseService._internal();

  CollectionReference get _usersColl => _firestore.collection('users');

  /// Init user with a collection is more reliable with firestore
  /// cloud functions
  // Future<void> initUser() async {
  //   if (id != null) {
  //     Map<String, dynamic> data = {"userId": id, "tasks": []};

  //     await _usersColl.add(data);
  //   }
  // }
}
