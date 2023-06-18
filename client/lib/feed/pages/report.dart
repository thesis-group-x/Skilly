import 'package:flutter/material.dart';

class ReportDialog extends StatefulWidget {
  final Function(List<bool>) onSend;

  ReportDialog({required this.onSend});

  @override
  _ReportDialogState createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  List<bool> selectedOptions = [];

  // Example options
  List<String> options = [
    'Spam',
    'Inappropriate Content',
    'Harassment',
    'False Information',
    'Copyright Violation',
  ];

  @override
  void initState() {
    super.initState();

    selectedOptions = List<bool>.generate(options.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Options'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List<Widget>.generate(selectedOptions.length, (index) {
          return CheckboxListTile(
            title: Text(options[index]), // Display the option text
            value: selectedOptions[index],
            onChanged: (bool? value) {
              setState(() {
                selectedOptions[index] = value!;
              });
            },
            activeColor: Color(0xFF284855), // Set checkbox active color
            checkColor: Colors.white, // Set checkbox check color
            controlAffinity: ListTileControlAffinity.leading, // Move checkbox to the start of the tile
          );
        }),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            widget.onSend(selectedOptions);
            _showSuccessSnackBar(context); 
          },
          child: const Text('Send'),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Color(0xFF284855)), 
          ),
        ),
      ],
    );
  }

  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Report sent successfully'),
        duration: const Duration(seconds: 2),
        backgroundColor: Color(0xFF284855), 
      ),
    );
  }
}
