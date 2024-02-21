import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HorizontalInfiniteScrollingDailyCalendar(),
    );
  }
}

class HorizontalInfiniteScrollingDailyCalendar extends StatefulWidget {
  @override
  _HorizontalInfiniteScrollingDailyCalendarState createState() =>
      _HorizontalInfiniteScrollingDailyCalendarState();
}

class _HorizontalInfiniteScrollingDailyCalendarState
    extends State<HorizontalInfiniteScrollingDailyCalendar> {
  final double dayContainerWidth = 100.0; // Fixed width for each day container
  late ScrollController _scrollController;
  List<DateTime> days = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    int initialDaysBeforeToday =
        15; // Number of days to pre-render before today
    days = List.generate(
        60,
        (index) =>
            DateTime.now().add(Duration(days: index - initialDaysBeforeToday)));

    // Calculate initial scroll position so that today's date is towards the right side of the screen
    double initialScrollOffset = initialDaysBeforeToday * dayContainerWidth;
    _scrollController =
        ScrollController(initialScrollOffset: initialScrollOffset);

    // Listen to scroll events to dynamically load more days
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      // Load more days at the end
      setState(() {
        DateTime lastDay = days.last;
        for (int i = 1; i <= 10; i++) {
          // Load 10 more days
          days.add(lastDay.add(Duration(days: i)));
        }
      });
    }

    // else if (_scrollController.offset < dayContainerWidth * 10) {
    //   // Load more days at the start
    //   if (!_isLoading) {
    //     _isLoading = true; // Start loading

    //     DateTime firstDay = days.first;
    //     List<DateTime> newDays =
    //         List.generate(20, (i) => firstDay.subtract(Duration(days: i + 1)));

    //     // Schedule a microtask to avoid setState during build
    //     Future.delayed(Duration.zero, () {
    //       setState(() {
    //         days = newDays.reversed.toList() + days;
    //         // After updating the days, smoothly adjust the scroll position
    //         // to maintain the user's current viewport
    //         Future.microtask(() => _scrollController.animateTo(
    //               _scrollController.offset +
    //                   (dayContainerWidth * newDays.length),
    //               duration: Duration(
    //                   milliseconds:
    //                       1), // Minimal duration for an instant feel with smooth transition
    //               curve: Curves
    //                   .linear, // Use a linear curve for consistent scrolling speed
    //             ));
    //       });

    //       _isLoading = false; // End loading
    //     });
    //   }
    // }

    // Check if we're near the start of the list

    // else if (_scrollController.offset < dayContainerWidth * 10) {
    //   // Load more days at the start
    //   if (!_isLoading) {
    //     // Add a loading flag to debounce loading
    //     _isLoading = true;
    //     List<DateTime> newDays = [];
    //     DateTime firstDay = days.first;

    //     for (int i = 1; i <= 20; i++) {
    //       // Load 20 more days for smoother experience
    //       newDays.add(firstDay.subtract(Duration(days: i)));
    //     }

    //     setState(() {
    //       days = newDays.reversed.toList() + days;
    //     });

    //     _isLoading = false;
    //     // Adjust the scroll position to account for the new content
    //     _scrollController
    //         .jumpTo(_scrollController.offset + (dayContainerWidth * 20));
    //   }
    // }

    // else if (_scrollController.position.pixels <=
    //     _scrollController.position.minScrollExtent) {
    //   // Load more days at the start
    //   setState(() {
    //     DateTime firstDay = days.first;
    //     List<DateTime> newDays = [];
    //     for (int i = 1; i <= 10; i++) {
    //       // Load 10 more days
    //       newDays.add(firstDay.subtract(Duration(days: i)));
    //     }
    //     days = newDays.reversed.toList() + days;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Horizontal Infinite Daily Calendar'),
      ),
      body: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (context, index) {
          DateTime day = days[index];
          return Container(
            width: dayContainerWidth,
            child: Card(
              color:
                  Colors.lightBlueAccent, // Example color to differentiate days
              child: Center(
                child: Text(
                  '${day.day}\n${day.month}/${day.year}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
