import 'package:inventory/AllScreens.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 2),
      () {
        if (auth.currentUser == null) {
          print('Login Screen Route');
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false);
        } else {
          print('Home Screen Route');
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false);
        }
      },
    );
    return Scaffold(
      body: Center(
          child: Text(
        'Inventory',
        style: GoogleFonts.aBeeZee(
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
            fontSize: 50),
      )),
    );
  }
}
