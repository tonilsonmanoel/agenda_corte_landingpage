class Profissional {
  String nome;
  int? uid;
  String email;
  String telefone;
  String telefoneWhatsapp;
  String codeTelefone;
  String codeTelefoneWhatsapp;
  String fotoPerfil;
  List<Map<String, dynamic>> horariosTrabalho;
  List<Map<String, dynamic>> diasTrabalho;
  bool status;
  int? idEstabelecimento;
  String perfil;
  int? token;
  String? keyhash;
  String isoCodePhone;
  String isoCodePhoneWhatsapp;
  Profissional(
      {required this.nome,
      required this.email,
      this.uid,
      this.token,
      this.keyhash,
      required this.telefone,
      required this.telefoneWhatsapp,
      required this.codeTelefone,
      required this.codeTelefoneWhatsapp,
      required this.fotoPerfil,
      required this.horariosTrabalho,
      required this.diasTrabalho,
      this.idEstabelecimento,
      required this.perfil,
      required this.status,
      required this.isoCodePhone,
      required this.isoCodePhoneWhatsapp});
}
