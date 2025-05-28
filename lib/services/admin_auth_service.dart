import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/extras/custom_dialog.dart';
import 'package:universal_html/html.dart' as html;

class AdminAuthService {
  var db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> fetchAdminData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot doc =
            await db.collection('admins').doc(user.uid).get();
        if (doc.exists) {
          return doc.data() as Map<String, dynamic>;
        }
      }
    } catch (e) {
      debugPrint('Error fetching admin data: $e');
    }
    return {};
  }

  Future<bool> adminSignUp(
      {required BuildContext context,
      required String name,
      required String email,
      required String password}) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        handleError(context, "Unauthorized: No admin is currently logged in.");
        return false;
      }

      final adminRole = await db.collection('admins').doc(user.uid).get();
      if (!adminRole.exists || adminRole.data()?['role'] != 'admin') {
        handleError(context, "You are not authorized to create a new admin.");
        return false;
      }

      UserCredential admin = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      String? uid = admin.user?.uid;
      if (uid != null) {
        await db.collection('admins').doc(uid).set({
          'admin_name': name,
          'email': email,
          'role': "admin",
        });
        return true;
      }
      debugPrint('Admin account added successfully');
    } catch (e) {
      debugPrint('Error signning up: $e');
      return false;
    }
    return false;
  }

  Future<bool> adminLogin(
      {required String email, required String password}) async {
    try {
      UserCredential admin = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      await db
          .collection('admins')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'email': email});

      if (admin.user != null) {
        return true;
      }
    } catch (e) {
      debugPrint('Error logging in: $e');
      return false;
    }
    return false;
  }

  Future<void> adminSignOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      html.window.location.reload();
    } catch (e) {
      debugPrint('Error signning out: $e');
    }
  }

  Future<bool> updateAdminName(String newName) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await db
            .collection('admins')
            .doc(user.uid)
            .update({'admin_name': newName});

        debugPrint("Admin name updated successfully. $newName");
        return true;
      }
    } catch (e) {
      debugPrint('Error updating admin name: $e');
      return false;
    }
    return false;
  }

  Future<bool> updateEmail(
      BuildContext context, String newEmail, String password) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: user.email!, password: password);

        await user.verifyBeforeUpdateEmail(newEmail).then(
          (value) {
            DialogUtils.showBookingConfirmationDialog(
              context,
              'Email Update Pending',
              'A confirmation email has been sent to your new email address. Please verify it and sign in again.',
              () {
                adminSignOut();
              },
              isClickable: false,
            );
            debugPrint("Email update successfully. $newEmail");
          },
        );
        return true;
      }
    } catch (e) {
      debugPrint('Error updating email: $e');
      return false;
    }
    return false;
  }

  Future<bool> updatePassword(String newPassword, String oldPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.reauthenticateWithCredential(
          EmailAuthProvider.credential(
              email: user.email!, password: oldPassword),
        );

        await user.updatePassword(newPassword);

        return true;
      }
    } catch (e) {
      debugPrint('Error updating password: $e');
      return false;
    }
    return false;
  }

  void handleError(BuildContext context, String errorMessage) {
    debugPrint(errorMessage);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        errorMessage,
        style: const TextStyle(color: AppColors.appBackground),
      ),
      backgroundColor: AppColors.appAccent,
    ));
  }
}
