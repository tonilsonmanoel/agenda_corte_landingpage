class Estabelecimento {
  int? uid;
  String nome;
  String telefone;
  String telefoneWhatsapp;
  String codeTelefone;
  String codeTelefoneWhatsapp;
  String endereco;
  String complemento;
  String cep;
  String urlLogo;
  String? cnpj;
  String? email;
  String? sobreNos;
  String? sobreNosImg;
  String? horarioFuncionamento;
  String? razaoSocial;
  String? urlIframeMapa;
  bool? setUp;
  String isoCodePhone;
  String urlBarbearia;
  bool ativoLanding;
<<<<<<< HEAD
  bool siteManutencao;
=======
>>>>>>> 239d25864a887bf664e2b0347b7de47912c0a8f3

  Estabelecimento(
      {required this.nome,
      required this.telefone,
      required this.telefoneWhatsapp,
      required this.codeTelefone,
      required this.codeTelefoneWhatsapp,
      required this.cep,
      required this.endereco,
      required this.complemento,
      required this.urlLogo,
      required this.isoCodePhone,
      this.uid,
      this.cnpj,
      this.email,
      required this.urlIframeMapa,
      this.horarioFuncionamento,
      this.razaoSocial,
      this.setUp,
      this.sobreNos,
      this.sobreNosImg,
      required this.ativoLanding,
<<<<<<< HEAD
      required this.siteManutencao,
=======
>>>>>>> 239d25864a887bf664e2b0347b7de47912c0a8f3
      required this.urlBarbearia});
  Estabelecimento.vazio(
      {this.nome = "",
      this.telefone = "",
      this.telefoneWhatsapp = "",
      this.codeTelefone = "",
      this.codeTelefoneWhatsapp = "",
      this.urlIframeMapa = '',
      this.cep = "",
      this.endereco = "",
      this.complemento = "",
      this.urlLogo = "",
      this.cnpj = "",
      this.email = "",
      this.horarioFuncionamento = "",
      this.razaoSocial = "",
      this.sobreNos = "",
      this.sobreNosImg = "",
      this.isoCodePhone = "",
      this.ativoLanding = false,
<<<<<<< HEAD
      this.siteManutencao = false,
=======
>>>>>>> 239d25864a887bf664e2b0347b7de47912c0a8f3
      this.urlBarbearia = ""});
}
