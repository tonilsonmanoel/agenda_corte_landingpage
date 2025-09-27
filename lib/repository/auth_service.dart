import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<AuthResponse> signInWithEmailPassword(
      String email, String password) async {
    return await _supabase.auth
        .signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUpWithEmailPassword(
      String email, String password) async {
    return await _supabase.auth.signUp(
      password: password,
      email: email,
    );
  }

  Future<void> limpaPeistencia() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<void> loginPesitencia({
    required String email,
    required String senha,
    required int idEstabelecimento,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", email);
    prefs.setString("senha", senha);
    prefs.setInt("idEstabelecimento", idEstabelecimento);
  }

  Future<void> criarUsuario(
      {required String email, required String senha}) async {
    await _supabase.auth.admin
        .createUser(AdminUserAttributes(
          email: email,
          password: senha,
        ))
        .then((value) {});
  }

  String? getCurrentUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }
}
