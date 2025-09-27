import 'package:email_validator/email_validator.dart';

mixin ValidationMixins {
  String? isNotEmpty(String? value, [String? message]) {
    if (value!.isEmpty) return message ?? "Esta campo é obrigatorio";

    return null;
  }

  String? emailValidation(String? value, [String? message]) {
    if (!EmailValidator.validate(value!)) return message ?? "Email invalido";

    return null;
  }

  String? minimoCaractere(String? value, int limite, [String? message]) {
    if (value!.length < limite)
      return message ?? "Você deve usar pelo menos $limite caracteres!";

    return null;
  }

  String? limiteCaractere(String? value, int limite, [String? message]) {
    if (value!.length > limite)
      return message ?? "Você deve usar até $limite caracteres!";

    return null;
  }

  String? combine(List<String? Function()> validators) {
    for (final func in validators) {
      final validation = func();
      if (validation != null) return validation;
    }
    return null;
  }
}
