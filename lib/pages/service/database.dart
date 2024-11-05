import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseMethods {

  //CREATE
  Future addCourseDetails(
      Map<String, dynamic> courseInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Course")
        .doc(id)
        .set(courseInfoMap);
  }

  // READ
  Future<Stream<QuerySnapshot>> getCourseDetails()async{
    return await FirebaseFirestore.instance.collection("Course").snapshots();
  }

  // UPDATE
  Future updateCourseDetail(String id, Map<String, dynamic> updateInfo)async{
    return await FirebaseFirestore.instance.collection("Course").doc(id).update(updateInfo);
  }

  // DELETE
  Future deleteCourseDetail(String id)async{
    return await FirebaseFirestore.instance.collection("Course").doc(id).delete();
  }
}
