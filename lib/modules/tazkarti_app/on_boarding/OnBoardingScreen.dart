import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tazkarti_app/modules/tazkarti_app/login/login_screen.dart';
import 'package:tazkarti_app/shared/components/components.dart';


class BoardingModel {
  final String image;
  final String title;
  final String body;

  BoardingModel({
    required this.title,
    required this.image,
    required this.body,
  });
}

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  var boardController = PageController();

  List<BoardingModel> boarding =
  [
    BoardingModel(
      image: 'assets/images/on1.jpg',
      title: 'Book your ticket now',
      body: 'Booking the Ticket',
    ),
    BoardingModel(
      image: 'assets/images/on2.png',
      title: 'Receiving the FanID from FAN ID Room',
      body: 'Taking the FanID',
    ),
    BoardingModel(
      image: 'assets/images/on3.png',
      title: 'Receiving the ticket from tazkarti location',
      body: 'Receiving the Ticket',
    ),
    BoardingModel(
      image: 'assets/images/on4.png',
      title: 'Know any match location on google map',
      body: 'Location',
    ),
  ];

  bool isLast = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[600],
        actions:
        [
          TextButton(
            onPressed: ()
            {
              navigateAndFinish(context, TazkartiLoginScreen(),);
            },
            child: Text(
              'Skip',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
        title: Text(
          'Welcome to Tazkarti App',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 2.0),
        child: Column(
          children:
          [
            Expanded(
              child: PageView.builder(
                itemBuilder: (context, index) =>
                    buildBoardingItem(boarding[index]),
                itemCount: boarding.length,
                physics: BouncingScrollPhysics(),
                controller: boardController,
                onPageChanged: (int index) {
                  if (index == boarding.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                  }
                  else {
                    setState(() {
                      isLast = false;
                    });
                  }
                },
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Row(
              children:
              [
                SmoothPageIndicator(
                  controller: boardController,
                  effect: ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    activeDotColor: Colors.green.shade600,
                    dotHeight: 10,
                    expansionFactor: 4,
                    dotWidth: 20,
                    spacing: 5.0,
                  ),
                  count: boarding.length,
                ),
                Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if (isLast)
                    {
                      navigateAndFinish(context, TazkartiLoginScreen(),);
                    }
                    else {
                      boardController.nextPage(
                        duration: Duration(
                          milliseconds: 750,
                        ),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBoardingItem(BoardingModel model) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded  (
        child: Image(
          image: AssetImage('${model.image}'),
          fit: BoxFit.fill,
        ),
      ),
      SizedBox(
        height: 30.0,
      ),
      Text(
        '${model.title}',
        style: TextStyle(
            fontSize: 20.0,
        ),
      ),
      SizedBox(
        height: 15.0,
      ),
      Text(
        '${model.body}',
        style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold
        ),
      ),
      SizedBox(
        height: 30.0,
      ),
    ],
  );
}