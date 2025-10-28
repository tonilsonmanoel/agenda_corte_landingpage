class Servico {
  int? uid;
  String nome;
  double valor;
  String urlImg;
  bool ativo;
  int? idProfissional;
  bool ativoLadingpage;
  int idEstabelecimento;
  Servico({
    this.uid,
    required this.nome,
    required this.valor,
    required this.urlImg,
    required this.ativo,
    this.idProfissional,
    required this.ativoLadingpage,
    required this.idEstabelecimento,
  });
}
