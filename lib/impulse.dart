import 'package:flutter/material.dart';

class ImpulsePage extends StatefulWidget {
  const ImpulsePage({super.key});

  @override
  _ImpulsePageState createState() => _ImpulsePageState();
}

class _ImpulsePageState extends State<ImpulsePage> {
  final List<Map<String, dynamic>> _questions = [
    {'question': 'Have I thought about it for at least two weeks?', 'type': 'yesno', 'points': {'yes': 2, 'no': 0}},
    {'question': "Does it solve a problem that I've genuinely noticed?", 'type': 'yesno', 'points': {'yes': 2, 'no': 0}},
    {'question': 'Do I already own something similar?', 'type': 'yesno', 'points': {'yes': 0, 'no': 2}},
    {'question': 'Is buying it worth giving up progress towards my next financial goal?', 'type': 'yesno', 'points': {'yes': 2, 'no': 0}},
    {'question': 'Where will it be in five years?', 'type': 'custom', 'options': ['Used', 'In use', 'Not in use'], 'points': {'Used':1, 'In use': 3, 'Not in use': 0}},
    {'question': 'Where will I put it if I buy it?', 'type': 'custom', 'options': ['I have a place in mind', 'Not Sure'], 'points': {'I have a place in mind': 1, 'Not Sure': 0}},
    {'question': 'How long will I have to work in order to pay for it?', 'type': 'custom', 'options': ['Not very long', 'A significant amount of time'], 'points': {'Not very long': 1, 'A significant amount of time': 0}},
    {'question': 'Can I be productive and happy without it?', 'type': 'yesno', 'points': {'yes': 0, 'no': 2}},
    {'question': 'What is the cost of it per use?', 'type': 'custom', 'options': ['Worth my money', 'Not worth my money/Unsure'], 'points': {'Worth my money': 1, 'Not worth my money/Unsure': 0}},
    {'question': 'Does buying it support my priorities?', 'type': 'yesno', 'points': {'yes': 2, 'no': 0}},
    {'question': 'Is this the best way for me to obtain it?', 'type': 'yesno', 'points': {'yes': 1, 'no': 0}},
    {'question': 'Is it a high-quality item with a reasonable price tag?', 'type': 'yesno', 'points': {'yes': 1, 'no': 0}},
    {'question': 'What is my current mental state?', 'type': 'custom', 'options': ['Calm and neutral', 'Altered by internal or external forces'], 'points': {'Calm and neutral': 2, 'Altered by internal or external forces': 0}},
    {'question': "What is the real reason I'm considering buying it?", 'type': 'custom', 'options': ['Need', 'Want', 'Impulse'], 'points': {'Need': 3, 'Want': 1, 'Impulse': 0}},
  ];

  final List<dynamic> _responses = List.filled(14, null);

  void _submitResponses() {
    int totalScore = 0;
    int maxScore = 0;
    int proCount = 0;
    int conCount = 0;
    int necessityMin= 56;
    List<String> additionalConsiderations = [];

    for (int i = 0; i < _responses.length; i++) {
      final question = _questions[i];
      final response = _responses[i];

      if (response != null) {
        int points = 0;
        if (question['type'] == 'yesno') {
          points = question['points'][response ? 'yes' : 'no'] as int;
        } else if (question['type'] == 'custom') {
          points = question['points'][response] as int;
        }
        totalScore += points;

        // Update pro and con counts
        if (points > 0) {
          proCount++;
        } else {
          conCount++;
        }

        // Add additional considerations based on specific responses
        if (i == 0 && response == false) {
          additionalConsiderations.add('Consider thinking about it for at least two weeks before continuing.');
        } else if (i == 1 && response == false) {
          additionalConsiderations.add("You mentioned this won't solve a problem, so it's recommended you consider if you actually want this item.");
        } else if (i == 2 && response == true) {
          additionalConsiderations.add('Consider if the item you already own can be repurposed or modified to take the place of this item.');
        } else if (i == 5 && response == 'Not Sure') {
          additionalConsiderations.add('Consider if you have the room for this item and if you can reasonably find a permanent home for it.');
        }
      }

      // Calculate the maximum possible score
      if (question['type'] == 'yesno') {
        maxScore += (question['points']['yes'] as int) > (question['points']['no'] as int)
            ? question['points']['yes'] as int
            : question['points']['no'] as int;
      } else if (question['type'] == 'custom') {
        maxScore += question['points'].values.reduce((a, b) => (a as int) > (b as int) ? a : b) as int;
      }
    }

    double percentageScore = (totalScore / maxScore) * 100;
    String recommendation = percentageScore >= necessityMin
        ? 'You can go ahead and purchase the item!'
        : 'It is recommended not to purchase the item.';

    // Additional considerations based on specific responses
    if (percentageScore >= necessityMin && _responses[6] == 'A significant amount of time') {
      additionalConsiderations.add('You mentioned this will take a long time to pay for it, are you positive this item would be worth it?');
    }
    if (_responses[7] == true) {
      additionalConsiderations.add('If you can be productive without it, are you sure you need it?');
    }
    if (_responses[8] == 'Not worth my money/Unsure') {
      additionalConsiderations.add('You said this is not worth your money, are you positive you want it?');
    }
    if (_responses[9] == false) {
      additionalConsiderations.add('You said this does not support your priorities, do you think buying this item is truly worth it?');
    }
    if (_responses[10] == false) {
      additionalConsiderations.add('You said this is not the best way to obtain the item, is there a better way that is cheaper or more likely not to provide a defective item?');
    }
    if (_responses[11] == false) {
      additionalConsiderations.add('You said this is not a high-quality item, is this item worth the price, or is there something better at a more reasonable price tag?');
    }
    if (_responses[12] == 'Altered by internal or external forces') {
      additionalConsiderations.add('Consider purchasing this item when your mental state is more calm and collected.');
    }
    if (_responses[13] == 'Impulse') {
      additionalConsiderations.add('You said the real reason you are considering buying the item is because of impulse. Evaluate if you actually want the item. If the answer is no, then you should not consider it.');
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Results'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Necessity score: ${percentageScore.toStringAsFixed(2)}%'),
                SizedBox(height: 10),
                Text(recommendation),
                SizedBox(height: 10),
                Text('Pros: $proCount'),
                Text('Cons: $conCount'),
                SizedBox(height: 10),
                Text('Considerations:'),
                ...additionalConsiderations.map((consideration) => Text('• $consideration')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _refreshResponses() {
    setState(() {
      for (int i = 0; i < _responses.length; i++) {
        _responses[i] = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Impulse Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshResponses,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  final question = _questions[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            question['question'],
                            style: TextStyle(fontSize: 18),
                          ),
                          if (question['type'] == 'yesno') ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _responses[index] = true;
                                    });
                                  },
                                  child: Text(
                                    'Yes',
                                    style: TextStyle(
                                      color: _responses[index] == true
                                          ? (index == 2 || index == 7 ? Colors.red : Colors.green)
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _responses[index] = false;
                                    });
                                  },
                                  child: Text(
                                    'No',
                                    style: TextStyle(
                                      color: _responses[index] == false
                                          ? (index == 2 || index == 7 ? Colors.green : Colors.red)
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ] else if (question['type'] == 'custom') ...[
                            DropdownButton<String>(
                              value: _responses[index],
                              hint: Text('Select an option'),
                              onChanged: (value) {
                                setState(() {
                                  _responses[index] = value;
                                });
                              },
                              items: question['options']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _submitResponses,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}