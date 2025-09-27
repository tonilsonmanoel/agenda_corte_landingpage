import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class CarrosselLandingPage {
  Widget carroseul3Img(
      {required List<String> listaImagens,
      required List<String> titulos,
      required CarouselSliderController buttonCarouselController}) {
    return SizedBox(
      height: 400,
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                buttonCarouselController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.linear);
              },
              icon: Icon(
                FontAwesomeIcons.arrowLeft,
                color: Colors.white,
                size: 70,
              )),
          Expanded(
            child: CarouselSlider.builder(
              options: CarouselOptions(
                  aspectRatio: 2.0,
                  enlargeCenterPage: false,
                  viewportFraction: 1,
                  autoPlayInterval: Duration(seconds: 7),
                  autoPlay: true),
              carouselController: buttonCarouselController,
              itemCount: (listaImagens.length / 3).ceil(),
              itemBuilder: (context, index, realIdx) {
                final int first = index * 3;
                final int second = first + 1;
                final int third = first + 2;

                final indices = [first, second, third]
                    .where((idx) => idx < listaImagens.length)
                    .toList();

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: indices.map((idx) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              listaImagens[idx],
                              fit: BoxFit.fill,
                              height: 340,
                              width: 300,
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            child: SizedBox(
                              width: 300,
                              child: AutoSizeText(
                                titulos[idx],
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.robotoCondensed(
                                  color: Colors.white,
                                  fontSize: 40,
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
                            ),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          IconButton(
              onPressed: () {
                buttonCarouselController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.linear);
              },
              icon: Icon(
                FontAwesomeIcons.arrowRight,
                color: Colors.white,
                size: 70,
              )),
        ],
      ),
    );
  }

  Widget carroseul2Img(
      {required List<String> listaImagens,
      required List<String> titulos,
      required CarouselSliderController buttonCarouselController}) {
    return SizedBox(
      height: 360,
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                buttonCarouselController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.linear);
              },
              icon: Icon(
                FontAwesomeIcons.arrowLeft,
                color: Colors.white,
                size: 70,
              )),
          Expanded(
            child: CarouselSlider.builder(
              options: CarouselOptions(
                  enlargeCenterPage: false,
                  viewportFraction: 1,
                  autoPlayInterval: Duration(seconds: 7),
                  autoPlay: true),
              carouselController: buttonCarouselController,
              itemCount: (listaImagens.length / 2).ceil(),
              itemBuilder: (context, index, realIdx) {
                final int first = index * 2;
                final int second = first + 1;

                final indices = [
                  first,
                  second,
                ].where((idx) => idx < listaImagens.length).toList();

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: indices.map((idx) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              listaImagens[idx],
                              fit: BoxFit.fill,
                              height: 320,
                              width: 280,
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            child: SizedBox(
                              width: 290,
                              child: AutoSizeText(
                                titulos[idx],
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.robotoCondensed(
                                  color: Colors.white,
                                  fontSize: 40,
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
                            ),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          IconButton(
              onPressed: () {
                buttonCarouselController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.linear);
              },
              icon: Icon(
                FontAwesomeIcons.arrowRight,
                color: Colors.white,
                size: 70,
              )),
        ],
      ),
    );
  }

  Widget carroseul1Img(
      {required List<String> listaImagens,
      required List<String> titulos,
      required CarouselSliderController buttonCarouselController}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: CarouselSlider.builder(
        options: CarouselOptions(
          aspectRatio: 2,
          autoPlayInterval: Duration(seconds: 7),
          enlargeCenterPage: false,
          autoPlay: true,
          viewportFraction: 1,
        ),
        itemCount: listaImagens.length,
        carouselController: buttonCarouselController,
        itemBuilder: (context, index, realIdx) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    listaImagens[index],
                    fit: BoxFit.fill,
                    height: 420,
                    width: 350,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  child: SizedBox(
                    width: 290,
                    child: AutoSizeText(
                      titulos[index],
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.robotoCondensed(
                        color: Colors.white,
                        fontSize: 40,
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
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget carrosselMobileimg(
      {required List<String> listaImagens,
      required List<String> titulos,
      required CarouselSliderController buttonCarouselController}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: CarouselSlider.builder(
        options: CarouselOptions(
            aspectRatio: 1.5,
            enlargeCenterPage: false,
            autoPlayInterval: Duration(seconds: 7),
            viewportFraction: 1,
            autoPlay: true),
        itemCount: listaImagens.length,
        carouselController: buttonCarouselController,
        itemBuilder: (context, index, realIdx) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    listaImagens[index],
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  child: SizedBox(
                    width: 290,
                    child: AutoSizeText(
                      titulos[index],
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.robotoCondensed(
                        color: Colors.white,
                        fontSize: 40,
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
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
