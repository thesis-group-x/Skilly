import 'package:flutter/material.dart';
import 'second.dart';

class TermsPage extends StatefulWidget {
  const TermsPage({Key? key}) : super(key: key);

  @override
  _TermsPageState createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
         child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('TERMS OF USE\n',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF284855),
                )),
            const Text('Last updated June 18, 2023\n',
                textAlign: TextAlign.center),
            const Text('AGREEMENT TO OUR LEGAL TERMS\n',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF284855),
                )),
            const Text('''
We are Skilly , a company registered in  Tunis, Tunisia .
We operate the mobile application Skilly , as well as any other related products and services that refer or link to these legal terms (the 'Legal Terms') (collectively, the 'Services').
You can contact us by phone at +21658120561 or email at skilly.app@gmail.com .
These Legal Terms constitute a legally binding agreement made between you, whether personally or on behalf of an entity ('you'), and Skilly, concerning your access to and use of the Services. You agree that by accessing the Services, you have read, understood, and agreed to be bound by all of these Legal Terms. IF YOU DO NOT AGREE WITH ALL OF THESE LEGAL TERMS, THEN YOU ARE EXPRESSLY PROHIBITED FROM USING THE SERVICES AND YOU MUST DISCONTINUE USE IMMEDIATELY.
We will provide you with prior notice of any scheduled changes to the Services you are using. The modified Legal Terms will become effective upon posting or notifying you by skilly.app@gmail.com, as stated in the email message. By continuing to use the Services after the effective date of any changes, you agree to be bound by the modified terms
All users who are minors in the jurisdiction in which they reside (generally under the age of 18) must have the permission of, and be directly supervised by, their parent or guardian to use the Services. If you are a minor, you must have your parent or guardian read and agree to these Legal Terms prior to you using the Services.
We recommend that you print a copy of these Legal Terms for your records.\n \n \n OUR SERVICES\n

The information provided when using the Services is not intended for distribution to or use by any person or entity in any jurisdiction or country where such distribution or use would be contrary to law or regulation or which would subject us to any registration requirement within such jurisdiction or country. Accordingly, those persons who choose to access the Services from other locations do so on their own initiative and are solely responsible for compliance with local laws, if and to the extent local laws are applicable.
The Services are not tailored to comply with industry-specific regulations (Health Insurance Portability and Accountability Act (HIPAA), Federal Information Security Management Act
(FISMA), etc.), so if your interactions would be subjected to such laws, you may not use the Services. You may not use the Services in a way that would violate the Gramm-Leach-Bliley Act (GLBA).
''',
                textAlign: TextAlign.center),
            CheckboxListTile(
  title: const Text('I agree to the Terms of Use'),
  value: _isChecked,
  onChanged: (value) {
    setState(() {
      _isChecked = value!;
    });
  },
  activeColor: Color(0xFF284855), 
  controlAffinity: ListTileControlAffinity.leading,
),

            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF284855),
              ),
              onPressed: _isChecked
                  ? () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SecondPage()),
                      );
                    }
                  : null, 
              child: const Text('Agree and Continue'),
            ),
          ],
        ),
      ),
      )
    );
  }
}
