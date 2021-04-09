import 'package:emoup/Services/inspiration.dart';
import 'package:emoup/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

class InspirationTherapy extends StatefulWidget {

  final String uid;
  InspirationTherapy({this.uid});
  @override
  _InspirationTherapyState createState() => _InspirationTherapyState();
}

List<String> images = [];
double w, h;

class _InspirationTherapyState extends State<InspirationTherapy> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    List<String> lst = await getImages(widget.uid);
    setState(() {
      images = lst;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF405CC7),
        title: Text(
          "Inspiration",
          style: GoogleFonts.poppins(fontSize: 24, color: white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            child: Card(
              margin: EdgeInsets.only(bottom: 0.02 * h),
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Image.asset("assets/images/header.png", fit: BoxFit.fill),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                loading ? Center(
                  child: SpinKitWanderingCubes(
                    color: Colors.red,
                    size: 20,
                  )
                ) : Expanded(
                  child: StackedCardCarousel(
                    spaceBetweenItems: 600,
                    items: getStyleCard(),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 0.1 * h,
        child: Container(
          height: 0.1 * h,
          child: Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(top: 0.02 * h),
              height: 0.1 * h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20)
                ),
                color: eblue,
              ),
              child: Center(
                child: Text(
                  "Quotes often help us feel inspired",
                  style: GoogleFonts.poppins(
                    fontSize: 20, 
                    color: white
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getStyleCard() {
    List<Widget> cards = [];
    for (int i = 0; i < images.length; i++) {
      cards.add(StyleCard(image: Image.network(images[i])));
    }
    return cards;
  }
}

class StyleCard extends StatelessWidget {
  
  final Image image;
  const StyleCard({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5.0,
      shadowColor: Color(0x80405CC7),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.width * 0.65,
              child: image,
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}