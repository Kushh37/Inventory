import 'package:inventory/AllScreens.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.15),
              Text(
                'Inventory\nManagement',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunitoSans(
                    fontSize: width * 0.1,
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: width * 0.05),
              Text(
                '  ',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                    fontSize: width * 0.08,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(height: width * 0.05),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.poppins(
                    textStyle: GoogleFonts.poppins(
                        color: Colors.blueAccent,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.bold)),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent)),
                  filled: true,
                  labelStyle:
                      GoogleFonts.poppins(color: Colors.deepOrangeAccent),
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: width * 0.04),
              TextFormField(
                controller: _password,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                style: GoogleFonts.poppins(
                    textStyle: GoogleFonts.poppins(
                        color: Colors.blueAccent,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.bold)),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent)),
                  filled: true,
                  labelStyle:
                      GoogleFonts.poppins(color: Colors.deepOrangeAccent),
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: width * 0.04),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.25),
                height: height * 0.08,
                child: ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blueAccent),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)))),
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });

                      AuthClass()
                          .signIN(
                              email: _email.text.trim(),
                              password: _password.text.trim())
                          .then((value) {
                        if (value == "Welcome" &&
                            _email.text.isNotEmpty &&
                            _password.text.isNotEmpty) {
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()),
                              (route) => false);
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.deepOrangeAccent,
                              content: Text(value)));
                        }
                      });
                    },
                    child: isLoading == false
                        ? Text(
                            'LOGIN',
                            style: GoogleFonts.poppins(
                                fontSize: width * 0.05,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        : Center(
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          )),
              ),
              SizedBox(height: width * 0.04),
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUpScreen())),
                child: Container(
                  alignment: Alignment.center,
                  child: Text.rich(TextSpan(
                      text: "Don't have an Account?",
                      style: GoogleFonts.poppins(
                          fontSize: width * 0.04,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                      children: [
                        TextSpan(
                          text: " Sign Up",
                          style: GoogleFonts.poppins(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold),
                        )
                      ])),
                ),
              ),
              SizedBox(
                height: width * 0.04,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
