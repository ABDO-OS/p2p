// core/services/user_data/user_data_validator.dart
class UserDataValidator {
  static String? validateUserData({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String age,
  }) {
    if (name.trim().isEmpty) return "الاسم مطلوب";
    if (email.trim().isEmpty) return "الايميل مطلوب";
    if (phone.trim().isEmpty) return "الرقم مطلوب";
    if (address.trim().isEmpty) return "العنوان مطلوب";
    if (age.trim().isEmpty) return "العمر مطلوب";

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email.trim())) {
      return "ادخل ايميل صحيح";
    }

    final ageInt = int.tryParse(age.trim());
    if (ageInt == null || ageInt < 1 || ageInt > 150) {
      return "ادخل عمراً صحيحاً";
    }

    if (phone.trim().length < 8) return "رقم الهاتف قصير جداً";
    if (name.trim().length < 2) return "الاسم قصير جداً";

    return null;
  }
}
