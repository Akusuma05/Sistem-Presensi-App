part of '../Pages.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  static const String routeName = "/Login";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // final _loginKey = GlobalKey<FormState>();
  final ctrlEmail = TextEditingController();
  final ctrlPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(children: [
          Container(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              // This is the login text.
              children: [
                Container(
                  width: double.infinity,
                  child: const Text(
                    "Login",
                    style: TextStyle(
                        color: Color.fromARGB(255, 40, 107, 53),
                        fontWeight: FontWeight.w900,
                        fontSize: 42),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  height: 6,
                ),

                // This is the text under the login text.
                Container(
                  width: double.infinity,
                  child: const Text(
                    "Please sign in to continue",
                    style: TextStyle(
                      color: Color.fromARGB(255, 145, 145, 145),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),

                // This is the input form.
                Form(
                    // key: _loginKey,
                    child: Column(
                  children: [
                    SizedBox(height: 16),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          labelText: "Email", prefixIcon: Icon(Icons.email)),
                      controller: ctrlEmail,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return value.toString().isEmpty
                            ? 'Please fill in the blank!'
                            : null;
                      },
                    ),
                    SizedBox(height: 16),

                    // This is the password input.
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: "Password", prefixIcon: Icon(Icons.lock)),
                      controller: ctrlPass,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return value.toString().isEmpty
                            ? 'Please fill in the blank!'
                            : null;
                      },
                    ),
                    SizedBox(height: 64),

                    // This is the login button.
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          // if (ctrlPass.text.toString() == "" ||
                          //     ctrlEmail.text.toString() == "") {
                          //   showDialog(
                          //       context: context,
                          //       builder: ((((context) {
                          //         return AlertDialog(
                          //           title: Text(
                          //             "There is an Error!",
                          //             textAlign: TextAlign.center,
                          //             style: TextStyle(color: Colors.red),
                          //           ),
                          //           content: Column(
                          //               mainAxisSize: MainAxisSize.min,
                          //               children: [
                          //                 Text(
                          //                   "Please fill in the blanks!",
                          //                   textAlign: TextAlign.center,
                          //                   style: TextStyle(
                          //                       color: Color.fromARGB(
                          //                           255, 145, 145, 145)),
                          //                 ),
                          //               ]),
                          //         );
                          //       }))));
                          // } else {
                          //   // PostLogin();
                          // }

                          Navigator.pushReplacement(this.context,
                              MaterialPageRoute(builder: (context) => Home()));
                        },
                        child: const Text(
                          'LOGIN',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 40, 107, 53),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
              ],
            ),
          ), // This is the bottom text.
          Align(
            alignment: const Alignment(0, 0.9),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Register.routeName);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(color: Color.fromARGB(255, 145, 145, 145)),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Color.fromARGB(255, 40, 107, 53),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ]));
  }
}
