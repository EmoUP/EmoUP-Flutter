import 'package:emoup/OnBoarding/chartData.dart';
import 'package:emoup/Services/getReport.dart';
import 'package:emoup/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Report extends StatefulWidget {

  final String uid;
  final FileImage pfp;
  Report({this.uid, this.pfp});

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {

  double w,h;
  bool loading = true;
  List<ChartData> chartData;
  PageController controller = new PageController();
  String img;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    List<dynamic> temp = await getReport(widget.uid);
    setState(() {
      chartData = temp[0];
      img = temp[1];
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
        title: Text("Report",
          style: GoogleFonts.poppins(
            fontSize: 24,
            color: white
          ),
        ),
        centerTitle: true,
      ),
      body: loading ? Center(
        child: SpinKitWanderingCubes(
          color: Colors.red,
          size: 20,
        )
      ) : Column(
        children: [
          Container(
            child: Card(
              margin: EdgeInsets.only(bottom: 0.05 * h),
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Image.asset("assets/images/header.png", fit: BoxFit.fill),
            ),
          ),
          Container(
              height: 0.55 * h,
              child: PageView(
              controller: controller,
              scrollDirection: Axis.horizontal,
              children: [page1(), page2()],
            )
          ),
          SizedBox(
            height: 20,
          ),
          SmoothPageIndicator(
            controller: controller,  // PageController
            count:  2,
            effect:  ExpandingDotsEffect(
              activeDotColor: eblue
            )  // your preferred effect
          )
        ],
      )
    );
  }

  Widget page1() {
    return Container(
      height: 0.55 * h,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          SfCircularChart(
            legend: Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              textStyle: GoogleFonts.poppins(
                fontSize: 18
              ),
              iconHeight: 24,
              orientation: LegendItemOrientation.horizontal,
              overflowMode: LegendItemOverflowMode.wrap
            ),
            series: <CircularSeries>[
                RadialBarSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  cornerStyle: CornerStyle.bothCurve,
                  enableTooltip: true
                )
            ]
          ),
          Positioned(
            top: 0.155 * h,
              child: CircleAvatar(
              radius: 0.07 * h,
              backgroundColor: Colors.white,
              backgroundImage: widget.pfp,
            ),
          )
        ],
      )
    );
  }

  Widget page2() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Word Cloud",
            style: GoogleFonts.poppins(
              fontSize: 28
            )
          ),
          SizedBox(
            height: 0.05 * h,
          ),
          Image.network(img)
        ],
      ),
    );
  }
}