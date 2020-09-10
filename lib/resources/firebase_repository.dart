import 'dart:io';
import 'package:contacts/models/message.dart';
import 'package:contacts/models/user.dart';
import 'package:contacts/provider/image_upload_provider.dart';
import 'package:contacts/resources/firebase_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
class FirebaseRepository {
FirebaseMethods _firebaseMethods=FirebaseMethods();
Future<User> getUserDetails() => _firebaseMethods.getUserDetails();

Future<FirebaseUser> getCurrentUser()=>_firebaseMethods.getCurrentUser();
Future<FirebaseUser> signIn()=> _firebaseMethods.signIn();
Future<bool> authenticateUser(FirebaseUser user)=>_firebaseMethods.authenticateUser(user);
Future<void> addDataToDb(FirebaseUser user)=>_firebaseMethods.addDataToDb(user);
Future<void> signOut()=>_firebaseMethods.signOut();
Future<List<User>> fetchAllUsers(FirebaseUser user) => _firebaseMethods.fetchAllUsers(user);
Future<void> addMessageToDb(Message message, User sender, User receiver) => _firebaseMethods.addMessageToDb(message, sender, receiver);
Future<String> uploadImageToStorage(File imageFile) =>
    _firebaseMethods.uploadImageToStorage(imageFile);
void uploadImageMsgToDb(String url, String receiverId, String senderId) =>
    _firebaseMethods.setImageMsg(url, receiverId, senderId);
void uploadImage({
  @required File image,
  @required String receiverId,
  @required String senderId,
  @required ImageUploadProvider imageUploadProvider
}) =>
    _firebaseMethods.uploadImage(image, receiverId, senderId, imageUploadProvider);

}