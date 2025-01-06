import 'package:flutter/material.dart';

class RunningPlanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Running Plan'),
      ),
      body: ListView.builder(
        itemCount:
            12, // 10 weeks + 1 for "Getting Started" + 1 for "After Completion"
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ExpansionTile(
                  title: Text('Getting Started'),
                  children: <Widget>[
                    ListTile(
                      title: Text('The first 8 days'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Before you start the running program, you should get your legs ready by walking for 8 days prior. This will strengthen the muscles in your legs, reducing the likelihood of injury.'),
                          SizedBox(
                              height: 8.0), // Add some space between the texts
                          Text(
                              'For the first four days, walk 20 minute each day.'),
                          Text(
                              'After you have completed 4 days, increase your walk duration to 30 minutes each day for the next four days.'),
                          SizedBox(
                              height: 20.0), // Add some space between the texts
                          Text(
                              'After you have completed the 8 days of walking, you are ready to start the running program.'),
                          SizedBox(
                              height: 12.0), // Add some space between the texts
                          Text(
                              'For each week of the running program, you will complete your workouts on Mondays, Wednesdays, Fridays and Saturdays. '),
                          Text("On Tuesdays, Thursdays, and Sundays, take a rest day with an easy walk!"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (index == 11) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ExpansionTile(
                  title: Text('After Completion'),
                  children: <Widget>[
                    ListTile(
                      title: Text('Congratulations!'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'You have successfully completed the 10-week running plan.'),
                          SizedBox(
                              height: 8.0), // Add some space between the texts
                          Text(
                              'Keep up the good work and continue running to maintain your fitness.'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: WeekExpansionTile(
                  weekNumber: index,
                  content: getContentForWeek(index),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  List<Widget> getContentForWeek(int weekNumber) {
    switch (weekNumber) {
      case 1:
        return [
          ListTile(
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Run 2 minutes.'),
                Text('Walk 4 minutes.'),
                SizedBox(height: 8.0), // Add some space between the texts
                Text('Complete 5 cycles.'),
              ],
            ),
          ),
        ];
      case 2:
        return [
          ListTile(
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Run 3 minutes.'),
                Text('Walk 3 minutes.'),
                SizedBox(height: 8.0), // Add some space between the texts
                Text('Complete 5 cycles.'),
              ],
            ),
          ),
        ];
      case 3:
        return [
          ListTile(
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Run 5 minutes.'),
                Text('Walk 2.5 minutes.'),
                SizedBox(height: 8.0), // Add some space between the texts
                Text('Complete 4 cycles.'),
              ],
            ),
          ),
        ];
      case 4:
        return [
          ListTile(
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Run 7 minutes.'),
                Text('Walk 3 minutes.'),
                SizedBox(height: 8.0), // Add some space between the texts
                Text('Complete 3 cycles.'),
              ],
            ),
          ),
        ];
      case 5:
        return [
          ListTile(
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Run 8 minutes.'),
                Text('Walk 2 minutes.'),
                SizedBox(height: 8.0), // Add some space between the texts
                Text('Complete 3 cycles.'),
              ],
            ),
          ),
        ];
      case 6:
        return [
          ListTile(
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Run 9 minutes.'),
                Text('Walk 2 minutes.'),
                SizedBox(height: 8.0), // Add some space between the texts
                Text('Complete 2 cycles, then run 8 minutes.'),
              ],
            ),
          ),
        ];
      case 7:
        return [
          ListTile(
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Run 9 minutes.'),
                Text('Walk 1 minute.'),
                SizedBox(height: 8.0), // Add some space between the texts
                Text('Complete 3 cycles.'),
              ],
            ),
          ),
        ];
      case 8:
        return [
          ListTile(
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Run 13 minutes.'),
                Text('Walk 2 minutes.'),
                SizedBox(height: 8.0), // Add some space between the texts
                Text('Complete 2 cycles.'),
              ],
            ),
          ),
        ];
      case 9:
        return [
          ListTile(
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Run 14 minutes.'),
                Text('Walk 1 minute.'),
                SizedBox(height: 8.0), // Add some space between the texts
                Text('Complete 2 cycles.'),
                SizedBox(height: 12.0), // Add some space between the texts
                Text(
                  'Note: If you feel tired after completing week 9, repeat this week of training before moving on to week 10.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ];
      case 10:
        return [
          ListTile(
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Run for 30 minutes.'),
              ],
            ),
          ),
        ];
      // Add more cases for other weeks here
      default:
        return [
          ListTile(title: Text('Something went wrong here...')),
        ];
    }
  }
}

class WeekExpansionTile extends StatelessWidget {
  final int weekNumber;
  final List<Widget> content;

  WeekExpansionTile({required this.weekNumber, required this.content});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('Week $weekNumber'),
      children: content,
    );
  }
}
