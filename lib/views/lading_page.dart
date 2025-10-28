import 'package:agendamento_barber/models/Estabelecimento.dart';
import 'package:agendamento_barber/models/Servico.dart';
import 'package:agendamento_barber/repository/estabelecimentoRepository.dart';
import 'package:agendamento_barber/repository/profissionalRepository.dart';
import 'package:agendamento_barber/repository/servicoRepository.dart';
import 'package:agendamento_barber/utils/iframe_widget.dart';
import 'package:agendamento_barber/utils/utils.dart';
import 'package:agendamento_barber/views/sections_lading_page/contato_serction.dart';
import 'package:agendamento_barber/views/sections_lading_page/carrossel_landing_page.dart';
import 'package:agendamento_barber/views/sections_lading_page/dialog_agendamento.dart';
import 'package:agendamento_barber/views/sections_lading_page/rodape.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class LadingPage extends StatefulWidget {
  final Estabelecimento? estabelecimento;
  const LadingPage({super.key, this.estabelecimento});

  @override
  State<LadingPage> createState() => _LadingPageState();
}

class _LadingPageState extends State<LadingPage> {
  Estabelecimento estabelecimento = Estabelecimento.vazio();

  final scrollController = ScrollController();
  final intSecao = 0;

  final keySecao1 = GlobalKey();
  final keySecao2 = GlobalKey();
  final keySecao3 = GlobalKey();
  final keySecao4 = GlobalKey();
  final keySecao5 = GlobalKey();
  final keySecao6 = GlobalKey();
  bool shimerValue = false;
  List<Servico>? servicos;
  List<Map<String, dynamic>>? equipe;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // Se o estabelecimento foi passado pelo roteador (quando vier da verificação de host), usa ele.
    if (widget.estabelecimento != null) {
      estabelecimento = widget.estabelecimento!;
    } else {
      carregarDadosEstabecimento();
    }
    carregarServicos();
    carregarEquipe();
    print("Host ${Uri.base.host.toString()}");
  }

  void carregarServicos() async {
    Servicorepository()
        .getServicosLandingPage(idEstabelecimento: widget.estabelecimento!.uid!)
        .then(
      (value) {
        setState(() {
          servicos = value;
        });
      },
    );
  }

  void carregarEquipe() async {
    Profissionalrepository()
        .getBarbeirosLandingPage(idEstabecimento: widget.estabelecimento!.uid!)
        .then(
      (value) {
        setState(() {
          equipe = value;
        });
      },
    );
  }

  void carregarDadosEstabecimento() async {
    Estabelecimentorepository().getEstabelecimentoRepository().then(
      (value) {
        setState(() {
          estabelecimento = value;
        });
      },
    );
  }

  Widget servicosCarrossel() {
    List<String> imgServicosList = [];
    List<String> nomeServicosList = [];
    for (var servico in servicos!) {
      imgServicosList.add(servico.urlImg);
      nomeServicosList.add(servico.nome);
    }

    return Column(
      children: [
        if (ResponsiveBreakpoints.of(context).screenWidth > 1220) ...[
          Wrap(
            children: [
              CarrosselLandingPage().carroseul3Img(
                  listaImagens: imgServicosList,
                  titulos: nomeServicosList,
                  buttonCarouselController: buttonCarouselControllerServico),
            ],
          ),
        ],
        if (ResponsiveBreakpoints.of(context).screenWidth >= 786 &&
            ResponsiveBreakpoints.of(context).screenWidth <= 1220) ...[
          Wrap(
            children: [
              CarrosselLandingPage().carroseul2Img(
                  listaImagens: imgServicosList,
                  titulos: nomeServicosList,
                  buttonCarouselController: buttonCarouselControllerServico),
            ],
          ),
        ],
        if (ResponsiveBreakpoints.of(context).screenWidth >= 451 &&
            ResponsiveBreakpoints.of(context).screenWidth <= 785) ...[
          SizedBox(
            width: double.infinity,
            child: Wrap(
              children: [
                CarrosselLandingPage().carroseul1Img(
                    listaImagens: imgServicosList,
                    titulos: nomeServicosList,
                    buttonCarouselController: buttonCarouselControllerServico),
              ],
            ),
          ),
        ],
        if (ResponsiveBreakpoints.of(context).screenWidth >= 0 &&
            ResponsiveBreakpoints.of(context).screenWidth <= 450) ...[
          SizedBox(
            width: double.infinity,
            child: Wrap(
              children: [
                CarrosselLandingPage().carrosselMobileimg(
                    listaImagens: imgServicosList,
                    titulos: nomeServicosList,
                    buttonCarouselController: buttonCarouselControllerServico),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget equipeCarrossel() {
    List<String> imgEquipeList = [];
    List<String> nomeEquipeList = [];
    for (var equipeValue in equipe!) {
      imgEquipeList.add(equipeValue["fotoperfil"]);
      nomeEquipeList.add(equipeValue["nome"]);
    }

    return Column(
      children: [
        if (ResponsiveBreakpoints.of(context).screenWidth > 1220) ...[
          Wrap(
            children: [
              CarrosselLandingPage().carroseul3Img(
                  listaImagens: imgEquipeList,
                  titulos: nomeEquipeList,
                  buttonCarouselController: buttonCarouselControllerEquipe),
            ],
          ),
        ],
        if (ResponsiveBreakpoints.of(context).screenWidth >= 786 &&
            ResponsiveBreakpoints.of(context).screenWidth <= 1220) ...[
          Wrap(
            children: [
              CarrosselLandingPage().carroseul2Img(
                  listaImagens: imgEquipeList,
                  titulos: nomeEquipeList,
                  buttonCarouselController: buttonCarouselControllerEquipe),
            ],
          ),
        ],
        if (ResponsiveBreakpoints.of(context).screenWidth >= 451 &&
            ResponsiveBreakpoints.of(context).screenWidth <= 785) ...[
          SizedBox(
            width: double.infinity,
            child: Wrap(
              children: [
                CarrosselLandingPage().carroseul1Img(
                    listaImagens: imgEquipeList,
                    titulos: nomeEquipeList,
                    buttonCarouselController: buttonCarouselControllerEquipe),
              ],
            ),
          ),
        ],
        if (ResponsiveBreakpoints.of(context).screenWidth >= 0 &&
            ResponsiveBreakpoints.of(context).screenWidth <= 450) ...[
          SizedBox(
            width: double.infinity,
            child: Wrap(
              children: [
                CarrosselLandingPage().carrosselMobileimg(
                    listaImagens: imgEquipeList,
                    titulos: nomeEquipeList,
                    buttonCarouselController: buttonCarouselControllerEquipe),
              ],
            ),
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _onMenuClick(int value) {
    final RenderBox renderBox;
    switch (value) {
      case 1:
        renderBox = keySecao1.currentContext!.findRenderObject() as RenderBox;
        break;
      case 2:
        renderBox = keySecao2.currentContext!.findRenderObject() as RenderBox;
        break;
      case 3:
        renderBox = keySecao3.currentContext!.findRenderObject() as RenderBox;
        break;
      case 4:
        renderBox = keySecao4.currentContext!.findRenderObject() as RenderBox;
        break;
      case 5:
        renderBox = keySecao5.currentContext!.findRenderObject() as RenderBox;
        break;
      case 6:
        renderBox = keySecao6.currentContext!.findRenderObject() as RenderBox;
        break;
      default:
        throw Exception();
    }
    final offset = renderBox.localToGlobal(Offset.zero);

    scrollController.animateTo((offset.dy + scrollController.offset) - 50,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  CarouselSliderController buttonCarouselControllerServico =
      CarouselSliderController();
  CarouselSliderController buttonCarouselControllerEquipe =
      CarouselSliderController();

  Widget calendarioWidget() {
    return CalendarDatePicker2(
      config: CalendarDatePicker2WithActionButtonsConfig(
        selectedDayHighlightColor: const Color.fromARGB(255, 194, 175, 3),
        dayTextStyle: const TextStyle(color: Colors.white),
        weekdayLabelTextStyle: const TextStyle(color: Colors.grey),
        controlsTextStyle: const TextStyle(color: Colors.white),
        yearTextStyle: const TextStyle(color: Colors.white),
        monthTextStyle: const TextStyle(color: Colors.white),
        firstDate: DateTime.now(),
        disabledDayTextStyle: const TextStyle(color: Colors.grey),
        disabledMonthTextStyle: const TextStyle(color: Colors.grey),
        selectedDayTextStyle: const TextStyle(color: Colors.black),
        lastMonthIcon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        nextMonthIcon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
      ),
      value: [],
      onValueChanged: (value) {
        String formattedDate = Utils().getDataFormat(value[0]);

        String formattedDateNameDia = Utils().getDiaNomeFormat(value[0]);
        showDialog(
          context: context,
          builder: (context) => DialogAgendamento(
            data: formattedDate,
            dataDia: formattedDateNameDia,
            estabelecimento: widget.estabelecimento!,
            dateTimeDia: value[0],
          ),
        );
      },
    );
  }

  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  ];
  final List<String> imgListNomes = [
    "Barbeiro 1",
    "Barbeiro Tom",
    "Thomas",
    "Tim"
  ];
  final List<String> imgListEquipe = [
    "https://thumbs.dreamstime.com/b/armado-e-pronto-para-cortar-alguns-cabelos-retrato-de-um-belo-jovem-barbeiro-segurando-pente-cabelo-par-tesouras-dentro-sua-277685469.jpg",
    "https://thumbs.dreamstime.com/b/retrato-do-barbeiro-masculino-caucasiano-consider%C3%A1vel-com-penteado-elegante-118797782.jpg?w=576",
    "https://thumbs.dreamstime.com/b/barbeiro-moderno-novo-e-seu-cliente-farpado-satisfeito-considerável-62847082.jpg",
  ];
  final List<String> imgListEquipeNomes = [
    "Barbeiro 1",
    "Barbeiro Tom",
    "Thomas"
  ];
  final GlobalKey<ScaffoldState> keyScaffold = GlobalKey();

  @override
  Widget build(BuildContext context) {
    double widthMedia = MediaQuery.of(context).size.width;
    return Scaffold(
        key: keyScaffold,
        body: SingleChildScrollView(
          controller: scrollController,
          child: Stack(
            children: [
              Column(
                key: keySecao1,
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Image.asset(
                        "asset/fundotop2.png",
                        width: widthMedia,
                        fit: BoxFit.cover,
                        height: 480,
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 60,
                          ),
                          estabelecimento.urlLogo == ""
                              ? Shimmer(
                                  enabled: true,
                                  colorOpacity: 0.3,
                                  color: Colors.white,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.shade400,
                                    ),
                                    height: 250,
                                    width: 260,
                                  ))
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(
                                    estabelecimento.urlLogo,
                                    width: 260,
                                    fit: BoxFit.contain,
                                    height: 250,
                                  ),
                                ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveBreakpoints.of(context)
                                        .smallerOrEqualTo(TABLET)
                                    ? 10
                                    : 80,
                                vertical: 5),
                            child: estabelecimento.nome == ""
                                ? Shimmer(
                                    color: Colors.white,
                                    enabled: true,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey.shade400,
                                      ),
                                      width: 400,
                                      height: 90,
                                    ))
                                : AutoSizeText(
                                    estabelecimento.nome,
                                    style: GoogleFonts.bungee(
                                        color: Colors.white,
                                        fontSize: 60,
                                        wordSpacing: 0,
                                        height: 0),
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    minFontSize: 20,
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  //Seção Agendamento
                  Container(
                    width: widthMedia,
                    color: Colors.black,
                    key: keySecao2,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: ResponsiveBreakpoints.of(context)
                                          .smallerOrEqualTo(TABLET)
                                      ? 10
                                      : 80,
                                  vertical: 10),
                              child: AutoSizeText(
                                "AGENDE SEU ATENDIMENTO",
                                style: GoogleFonts.robotoCondensed(
                                  color: Colors.white,
                                  fontSize: 55,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                minFontSize: 5,
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: ResponsiveBreakpoints.of(context)
                                        .smallerOrEqualTo(TABLET)
                                    ? widthMedia * 0.85
                                    : widthMedia * 0.40,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white, width: 1.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                height: 275,
                                child: calendarioWidget(),
                              ),
                            ),
                            SizedBox(
                              height: 90,
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          child: Image.asset(
                            "asset/cardeira.png",
                            width: ResponsiveBreakpoints.of(context)
                                    .smallerOrEqualTo(TABLET)
                                ? 140
                                : 350,
                            height: ResponsiveBreakpoints.of(context)
                                    .smallerOrEqualTo(TABLET)
                                ? 110
                                : 280,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Fim Seção Agendamento
                  // Serviços

                  SizedBox(
                    key: keySecao3,
                    height:
                        ResponsiveBreakpoints.of(context).isMobile ? 390 : 470,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                flex: 4,
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                            "asset/ferramenstas.jpg",
                                          ),
                                          fit: BoxFit.fill)),
                                )),
                            Expanded(
                                flex: 7,
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                            "asset/fundo1.jpg",
                                          ),
                                          fit: BoxFit.fill)),
                                )),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            AutoSizeText(
                              "SERVIÇOS",
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.robotoCondensed(
                                color: Colors.white,
                                fontSize: 45,
                                height: 1,
                                shadows: [
                                  Shadow(
                                    blurRadius: 8.0,
                                    color: Colors.black,
                                    offset: Offset(3.0, 2.0),
                                  ),
                                ],
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (servicos != null && servicos!.isNotEmpty) ...[
                              servicosCarrossel(),
                            ] else if (servicos != null &&
                                servicos!.isEmpty) ...[
                              SizedBox(
                                height: 150,
                              ),
                              Center(
                                child: Card(
                                  color: Colors.black87,
                                  shadowColor: Colors.grey,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: AutoSizeText(
                                      "Nenhum serviço disponível no momento.",
                                      style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 25),
                                      minFontSize: 6,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              )
                            ] else ...[
                              Center(
                                child: CircularProgressIndicator(),
                              )
                            ]
                          ],
                        )
                      ],
                    ),
                  ),

                  //Fim Serviços
                  // Equipe
                  Container(
                      key: keySecao4,
                      color: Colors.black,
                      height: ResponsiveBreakpoints.of(context).isMobile
                          ? 390
                          : 470,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          AutoSizeText(
                            "EQUIPE",
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.robotoCondensed(
                              color: Colors.white,
                              fontSize: 45,
                              height: 1,
                              shadows: [
                                Shadow(
                                  blurRadius: 8.0,
                                  color: Colors.black,
                                  offset: Offset(3.0, 2.0),
                                ),
                              ],
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (equipe != null && equipe!.isNotEmpty) ...[
                            equipeCarrossel(),
                          ] else if (equipe != null && equipe!.isEmpty) ...[
                            Center(
                              child: AutoSizeText(
                                "Nenhum profissional disponível no momento.",
                                style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18),
                                minFontSize: 6,
                                textAlign: TextAlign.center,
                              ),
                            )
                          ] else ...[
                            Center(
                              child: CircularProgressIndicator(),
                            )
                          ]
                        ],
                      )),

                  //Fim Equipe

                  // Sobre nós
                  Container(
                      width: widthMedia,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                "asset/fundo2.png",
                              ),
                              fit: BoxFit.cover)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          AutoSizeText(
                            "SOBRE NÓS",
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.robotoCondensed(
                              color: Colors.white,
                              fontSize: 50,
                              height: 1,
                              shadows: [
                                Shadow(
                                  blurRadius: 8.0,
                                  color: Colors.black,
                                  offset: Offset(3.0, 2.0),
                                ),
                              ],
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (ResponsiveBreakpoints.of(context)
                              .smallerOrEqualTo(MOBILE)) ...[
                            estabelecimento.sobreNosImg == ""
                                ? Shimmer(
                                    child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white54),
                                    height: 300,
                                    width: 400,
                                  ))
                                : Image.network(
                                    estabelecimento.sobreNosImg!,
                                    height: 250,
                                    width: widthMedia * 0.90,
                                  ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: estabelecimento.sobreNos == ""
                                  ? Shimmer(
                                      child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white54),
                                      height: 400,
                                      width: 500,
                                    ))
                                  : AutoSizeText(
                                      estabelecimento.sobreNos!,
                                      style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                      minFontSize: 6,
                                      textAlign: TextAlign.justify,
                                    ),
                            )
                          ],
                          if (ResponsiveBreakpoints.of(context)
                              .largerThan(MOBILE)) ...[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: estabelecimento.sobreNosImg == ""
                                      ? Shimmer(
                                          child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white54),
                                          height: 300,
                                          width: 400,
                                        ))
                                      : Image.network(
                                          estabelecimento.sobreNosImg!,
                                          height: 300,
                                        ),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        right: 50, top: 15, bottom: 15),
                                    child: estabelecimento.sobreNos == ""
                                        ? Shimmer(
                                            child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.white54),
                                            height: 350,
                                            width: 700,
                                          ))
                                        : AutoSizeText(
                                            estabelecimento.sobreNos!,
                                            style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20),
                                            minFontSize: 6,
                                            textAlign: TextAlign.justify,
                                          ),
                                  ),
                                )
                              ],
                            ),
                          ],
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      )),
                  //Fim Sobre Nós

                  //Inicio Contato
                  Center(
                    child: Column(
                      children: [
                        Container(
                            key: keySecao5,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                image: DecorationImage(
                                    image: AssetImage(
                                      'asset/Frame_1.png',
                                    ),
                                    repeat: ImageRepeat.repeat)),
                            child: ContatoSection(
                              estabelecimento: estabelecimento,
                            )),
                        if (estabelecimento.urlIframeMapa != null &&
                            estabelecimento.urlIframeMapa != '') ...[
                          SizedBox(
                            height: 320,
                            width: double.infinity,
                            child: IframeWidget(
                                url: estabelecimento.urlIframeMapa!),
                          ),
                        ],
                      ],
                    ),
                  ),
                  //Fim Contato

                  //Inicio Rodape
                  Rodape(
                    estabelecimento: estabelecimento,
                  )
                  //Fim Rodape
                ],
              ),

              // Imagens em destaque transição
              Positioned(
                right: 0,
                top: ResponsiveBreakpoints.of(context).smallerOrEqualTo(TABLET)
                    ? 400
                    : 350,
                child: Image.asset(
                  "asset/wmremove-transformed-Photor.png",
                  width:
                      ResponsiveBreakpoints.of(context).smallerOrEqualTo(TABLET)
                          ? 100
                          : 180,
                  height:
                      ResponsiveBreakpoints.of(context).smallerOrEqualTo(TABLET)
                          ? 150
                          : 230,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                right: 10,
                top: ResponsiveBreakpoints.of(context).smallerOrEqualTo(TABLET)
                    ? 880
                    : 850,
                child: Image.asset(
                  "asset/tesoura.png",
                  width:
                      ResponsiveBreakpoints.of(context).smallerOrEqualTo(TABLET)
                          ? 90
                          : 200,
                  height:
                      ResponsiveBreakpoints.of(context).smallerOrEqualTo(TABLET)
                          ? 130
                          : 250,
                  fit: BoxFit.fill,
                ),
              ),

              Positioned(
                left: 0,
                top: ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE)
                    ? 1280
                    : 1330,
                child: Image.asset(
                  "asset/navalha_img.png",
                  width:
                      ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE)
                          ? 160
                          : 250,
                  height:
                      ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE)
                          ? 120
                          : 200,
                  fit: BoxFit.fill,
                ),
              ),

              //Fim Imagens em destaque transição

              //Topo Page
              if (ResponsiveBreakpoints.of(context)
                  .largerOrEqualTo(DESKTOP)) ...[
                topoPaginaDesktop()
              ] else ...[
                topoPaginaMobileTablet(keyScaffold),
              ]
            ],
          ),
        ),
        drawer: drawerLandingPage());
  }

  Widget drawerLandingPage() {
    return Drawer(
      backgroundColor: const Color.fromARGB(240, 5, 5, 5),
      child: Column(
        children: [
          DrawerHeader(
              child: Image.network(
            estabelecimento.urlLogo,
          )),
          ListTile(
            style: ListTileStyle.drawer,
            onTap: () {
              Navigator.pop(context);
              _onMenuClick(1);
            },
            leading: Icon(
              Icons.home,
              color: Colors.white,
            ),
            title: Text(
              "INÍCIO",
              style: GoogleFonts.roboto(
                  color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
          ListTile(
            style: ListTileStyle.drawer,
            onTap: () {
              Navigator.pop(context);
              _onMenuClick(2);
            },
            leading: Icon(
              Icons.calendar_month,
              color: Colors.white,
            ),
            title: Text(
              "AGENDAMENTO",
              style: GoogleFonts.roboto(
                  color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
          ListTile(
            style: ListTileStyle.drawer,
            onTap: () {
              Navigator.pop(context);
              _onMenuClick(3);
            },
            leading: Icon(
              FontAwesomeIcons.scissors,
              color: Colors.white,
            ),
            title: Text(
              "SERVIÇOS",
              style: GoogleFonts.roboto(
                  color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
          ListTile(
            style: ListTileStyle.drawer,
            onTap: () {
              Navigator.pop(context);
              _onMenuClick(4);
            },
            leading: Icon(
              Icons.person,
              color: Colors.white,
            ),
            title: Text(
              "EQUIPE",
              style: GoogleFonts.roboto(
                  color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
          ListTile(
            style: ListTileStyle.drawer,
            onTap: () {
              Navigator.pop(context);
              _onMenuClick(5);
            },
            leading: Icon(
              Icons.phone,
              color: Colors.white,
            ),
            title: Text(
              "CONTATO",
              style: GoogleFonts.roboto(
                  color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget topoPaginaDesktop() {
    return Container(
      height: 60,
      color: Colors.black87,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 20,
              ),
              estabelecimento.urlLogo == ""
                  ? Shimmer(
                      color: Colors.white,
                      enabled: true,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade400,
                        ),
                        width: 40,
                        height: 40,
                      ))
                  : Image.network(
                      estabelecimento.urlLogo,
                      height: 40,
                    ),
              SizedBox(
                width: 20,
              ),
              estabelecimento.nome == ""
                  ? Shimmer(
                      color: Colors.white,
                      colorOpacity: 0.3,
                      enabled: true,
                      child: Container(
                        color: Colors.grey.shade400,
                        width: 120,
                        height: 40,
                      ),
                    )
                  : Text(
                      estabelecimento.nome,
                      style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    )
            ],
          ),
          Wrap(
            direction: Axis.horizontal,
            children: [
              TextButton(
                  onPressed: () {
                    _onMenuClick(1);
                  },
                  style: ButtonStyle(
                      overlayColor: WidgetStatePropertyAll(Colors.white10),
                      surfaceTintColor: WidgetStatePropertyAll(Colors.white)),
                  child: Text(
                    "Início",
                    style: GoogleFonts.roboto(color: Colors.white),
                  )),
              TextButton(
                  onPressed: () {
                    _onMenuClick(2);
                  },
                  style: ButtonStyle(
                      overlayColor: WidgetStatePropertyAll(Colors.white10),
                      surfaceTintColor: WidgetStatePropertyAll(Colors.white)),
                  child: Text(
                    "Agendamento",
                    style: GoogleFonts.roboto(color: Colors.white),
                  )),
              TextButton(
                  onPressed: () {
                    _onMenuClick(3);
                  },
                  style: ButtonStyle(
                      overlayColor: WidgetStatePropertyAll(Colors.white10),
                      surfaceTintColor: WidgetStatePropertyAll(Colors.white)),
                  child: Text(
                    "Serviços",
                    style: GoogleFonts.roboto(color: Colors.white),
                  )),
              TextButton(
                  onPressed: () {
                    _onMenuClick(4);
                  },
                  style: ButtonStyle(
                      overlayColor: WidgetStatePropertyAll(Colors.white10),
                      surfaceTintColor: WidgetStatePropertyAll(Colors.white)),
                  child: Text(
                    "Equipe",
                    style: GoogleFonts.roboto(color: Colors.white),
                  )),
              TextButton(
                  onPressed: () {
                    _onMenuClick(5);
                  },
                  style: ButtonStyle(
                      overlayColor: WidgetStatePropertyAll(Colors.white10),
                      surfaceTintColor: WidgetStatePropertyAll(Colors.white)),
                  child: Text(
                    "Contato",
                    style: GoogleFonts.roboto(color: Colors.white),
                  )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: ElevatedButton(
                onPressed: () {
                  _onMenuClick(2);
                },
                style: ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.all(17)),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                    backgroundColor: WidgetStatePropertyAll(Colors.yellow),
                    elevation: WidgetStatePropertyAll(5),
                    shadowColor:
                        WidgetStatePropertyAll(Colors.yellow.shade800)),
                child: Text(
                  "Agendar Agora",
                  style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                )),
          ),
        ],
      ),
    );
  }

  Widget topoPaginaMobileTablet(GlobalKey<ScaffoldState> keyScaffold) {
    return Container(
      height: 60,
      color: Colors.black87,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                keyScaffold.currentState!.openDrawer();
              },
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              )),
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              estabelecimento.urlLogo == ""
                  ? Shimmer(
                      color: Colors.white,
                      enabled: true,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade400,
                        ),
                        width: 40,
                        height: 40,
                      ))
                  : Image.network(
                      estabelecimento.urlLogo,
                      height: 40,
                    ),
              SizedBox(
                width: 10,
              ),
              estabelecimento.nome == ""
                  ? Shimmer(
                      color: Colors.white,
                      colorOpacity: 0.3,
                      enabled: true,
                      child: Container(
                        color: Colors.grey.shade400,
                        width: 120,
                        height: 40,
                      ),
                    )
                  : Text(
                      estabelecimento.nome,
                      style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
                onPressed: () {
                  _onMenuClick(2);
                },
                style: ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.all(6)),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                    backgroundColor: WidgetStatePropertyAll(Colors.yellow),
                    elevation: WidgetStatePropertyAll(5),
                    shadowColor:
                        WidgetStatePropertyAll(Colors.yellow.shade800)),
                child: Text(
                  "Agendar Agora",
                  style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                )),
          ),
        ],
      ),
    );
  }
}
