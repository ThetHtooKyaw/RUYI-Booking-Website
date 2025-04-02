import 'package:flutter/material.dart';
import 'package:ruyi_booking/screens/admin_screens/admin_screen.dart';
import 'package:ruyi_booking/screens/home_screens/home_screen.dart';
import 'package:ruyi_booking/services/adminAuth_service.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/extras/custom_Dialog.dart';

class AdminAuthProvider extends ChangeNotifier {
  final AdminAuthService _adminAuthService = AdminAuthService();
  Map<String, dynamic> adminData = {};
  final signUpFormKey = GlobalKey<FormState>();
  final loginFormKey = GlobalKey<FormState>();
  final updateFormKey = GlobalKey<FormState>();

  final TextEditingController signUpNameController = TextEditingController();
  final TextEditingController signUpEmailController = TextEditingController();
  final TextEditingController signUpPasswordController =
      TextEditingController();
  final TextEditingController signUpConfirmPasswordController =
      TextEditingController();

  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();

  final TextEditingController updateNameController = TextEditingController();
  final TextEditingController updateEmailController = TextEditingController();
  final TextEditingController passwordForEmailUpdateController =
      TextEditingController();
  final TextEditingController updatePasswordController =
      TextEditingController();
  final TextEditingController passwordForPasswordUpdateController =
      TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _nameEdit = false;
  bool get nameEdit => _nameEdit;

  bool _emailEdit = false;
  bool get emailEdit => _emailEdit;

  bool _passwordEdit = false;
  bool get passwordEdit => _passwordEdit;

  void setNameEdit(bool value) {
    _nameEdit = value;
    notifyListeners();
  }

  void setEmailEdit(bool value) {
    _emailEdit = value;
    notifyListeners();
  }

  void setPasswordEdit(bool value) {
    _passwordEdit = value;
    notifyListeners();
  }

  Future<void> loadAdminData() async {
    try {
      _isLoading = true;
      notifyListeners();

      adminData = await _adminAuthService.fetchAdminData();
    } catch (e) {
      debugPrint('Error fetching admin data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> adminSignUp(BuildContext context) async {
    try {
      if (signUpFormKey.currentState != null &&
          signUpFormKey.currentState!.validate()) {
        _isLoading = true;
        notifyListeners();

        bool signupSuccess = await _adminAuthService.adminSignUp(
            context: context,
            name: signUpNameController.text.trim(),
            email: signUpEmailController.text.trim(),
            password: signUpPasswordController.text.trim());

        if (signupSuccess) {
          DialogUtils.showBookingConfirmationDialog(
            context,
            'Create Admin Account Successful',
            'Your admin account has been successfully created!',
            () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return const AdminScreen();
              }));
            },
            isClickable: false,
          );

          signUpNameController.clear();
          signUpEmailController.clear();
          signUpPasswordController.clear();
        }
      }
    } catch (e) {
      DialogUtils.showErrorDialog(context, e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> adminLogin(BuildContext context) async {
    try {
      if (loginFormKey.currentState != null &&
          loginFormKey.currentState!.validate()) {
        _isLoading = true;
        notifyListeners();

        bool loginSuccess = await _adminAuthService.adminLogin(
            email: loginEmailController.text.trim(),
            password: loginPasswordController.text.trim());

        if (loginSuccess) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return const AdminScreen();
          }));

          loginEmailController.clear();
          loginPasswordController.clear();
        } else {
          handleError(context, 'Invalid email or password!');
        }
      }
    } catch (e) {
      debugPrint('Error logging in: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> adminSignOut(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _adminAuthService.adminSignOut();

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const HomeScreen();
      }));
    } catch (e) {
      debugPrint('Error signning out: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateAdminName(BuildContext context) async {
    try {
      if (updateFormKey.currentState != null &&
          updateFormKey.currentState!.validate()) {
        _isLoading = true;
        notifyListeners();

        bool updateNameSuccess = await _adminAuthService
            .updateAdminName(updateNameController.text.trim());

        if (updateNameSuccess) {
          await loadAdminData();
          _nameEdit = false;
          notifyListeners();
          updateNameController.clear();
        } else {
          handleError(context, 'Error updating admin name!');
        }
      }
    } catch (e) {
      debugPrint('Error updating admin name: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateEmail(BuildContext context) async {
    try {
      if (updateFormKey.currentState != null &&
          updateFormKey.currentState!.validate()) {
        _isLoading = true;
        notifyListeners();

        bool updateEmailSuccess = await _adminAuthService.updateEmail(
            context,
            updateEmailController.text.trim(),
            passwordForEmailUpdateController.text.trim());

        if (updateEmailSuccess) {
          _emailEdit = false;
          notifyListeners();
          passwordForEmailUpdateController.clear();
          updateEmailController.clear();
        } else {
          handleError(context, 'Error updating email!');
        }
      }
    } catch (e) {
      debugPrint('Error updating email: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePassword(BuildContext context) async {
    try {
      if (updateFormKey.currentState != null &&
          updateFormKey.currentState!.validate()) {
        _isLoading = true;
        notifyListeners();

        bool updatePasswordSuccess = await _adminAuthService.updatePassword(
          updatePasswordController.text.trim(),
          passwordForPasswordUpdateController.text.trim(),
        );

        if (updatePasswordSuccess) {
          _passwordEdit = false;
          notifyListeners();
          passwordForPasswordUpdateController.clear();
          updatePasswordController.clear();

          DialogUtils.showBookingConfirmationDialog(
            context,
            'Password Updated Successfully',
            'Your password has been changed successfully!',
            () {
              Navigator.pop(context);
            },
            isClickable: false,
          );
        } else {
          handleError(context, 'Error updating password!');
        }
      }
    } catch (e) {
      debugPrint('Error updating password: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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

  @override
  void dispose() {
    signUpNameController.dispose();
    signUpEmailController.dispose();
    signUpPasswordController.dispose();
    signUpConfirmPasswordController.dispose();

    loginEmailController.dispose();
    loginPasswordController.dispose();

    updateNameController.dispose();
    updateEmailController.dispose();
    passwordForEmailUpdateController.dispose();
    updatePasswordController.dispose();
    passwordForPasswordUpdateController.dispose();
    super.dispose();
  }
}
