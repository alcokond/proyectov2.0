import 'dart:io';

import 'package:flutter_login_ui/modelo/denuncias.dart';
import 'package:flutter_login_ui/modelo/usuario.dart';
import 'package:flutter_login_ui/notifier/auth_notifier.dart';
import 'package:flutter_login_ui/notifier/denuncia_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

login(Usuario user, AuthNotifier authNotifier) async {
  UserCredential authResult = await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: user.nombre, password: user.contrasena)
      .catchError((error) => print(error.code));

  if (authResult != null) {
    User firebaseUser = authResult.user;

    if (firebaseUser != null) {
      print("Log In: $firebaseUser");
      authNotifier.setUser(firebaseUser);
    }
  }
}

signup(Usuario user, AuthNotifier authNotifier) async {
  UserCredential authResult = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: user.nombre, password: user.contrasena)
      .catchError((error) => print(error.code));

  if (authResult != null) {


    User firebaseUser = authResult.user;

    if (firebaseUser != null) {
      await FirebaseAuth.instance.currentUser.updateProfile(displayName:user.nombre);


      await firebaseUser.reload();

      print("Sign up: $firebaseUser");

      User currentUser = await FirebaseAuth.instance.currentUser;
      authNotifier.setUser(currentUser);
    }
  }
}

signout(AuthNotifier authNotifier) async {
  await FirebaseAuth.instance.signOut().catchError((error) => print(error.code));

  authNotifier.setUser(null);
}

initializeCurrentUser(AuthNotifier authNotifier) async {
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser;

  if (firebaseUser != null) {
    print(firebaseUser);
    authNotifier.setUser(firebaseUser);
  }
}

getDenuncias(DenunciaNotifier denunciaNotifier) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Denuncias')
      .get();

  List<Denuncia> _denunciaList = [];

  snapshot.docs.forEach((document) {
    Denuncia denuncia = Denuncia.fromMap(document.data());
    _denunciaList.add(denuncia);
  });

  denunciaNotifier.denunciaList = _denunciaList;
}

uploadDenunciaAndImage(Denuncia denuncia, bool isUpdating, File localFile, Function denunciaUploaded) async {
  if (localFile != null) {
    print("subiendo");

    var fileExtension = path.extension(localFile.path);
    print(fileExtension);

    var uuid = Uuid().v4();

    final StorageReference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('denuncias/images/$uuid$fileExtension');

    await firebaseStorageRef.putFile(localFile).onComplete.catchError((onError) {
      print(onError);
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();
    print("download url: $url");
    _uploadDenuncia(denuncia, isUpdating, denunciaUploaded, imageUrl: url);
  } else {
    print('...skipping image upload');
    _uploadDenuncia(denuncia, isUpdating, denunciaUploaded);
  }
}

_uploadDenuncia(Denuncia denuncia, bool isUpdating, Function denunciaUploaded, {String imageUrl}) async {
  CollectionReference denunciaRef = FirebaseFirestore.instance.collection('Denuncias');

  if (imageUrl != null) {
    denuncia.imagen = imageUrl;
  }

  if (isUpdating) {


    await denunciaRef.doc(denuncia.id).update(denuncia.toMap());

    denunciaUploaded(denuncia);
    print('updated denuncia with id: ${denuncia.id}');
  } else {


    DocumentReference documentRef = await denunciaRef.add(denuncia.toMap());

    denuncia.id = documentRef.id;

    print('uploaded denuncia successfully: ${denuncia.toString()}');

    await documentRef.set(denuncia.toMap());

    denunciaUploaded(denuncia);
  }
}

deleteDenuncia(Denuncia denuncia, Function denunciaDeleted) async {
  if (denuncia.imagen != null) {
    StorageReference storageReference =
    await FirebaseStorage.instance.getReferenceFromUrl(denuncia.imagen);

    print(storageReference.path);

    await storageReference.delete();

    print('image deleted');
  }

  await FirebaseFirestore.instance.collection('Denuncias').doc(denuncia.id).delete();
  denunciaDeleted(denuncia);
}