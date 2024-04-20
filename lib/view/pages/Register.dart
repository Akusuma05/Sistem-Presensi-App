part of 'Pages.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  static const String routeName = "/Register";

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,

                  // This is the custom back button.
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, Login.routeName, (route) => false);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color.fromARGB(255, 145, 145, 145),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),

                // This is the create account text.
                Container(
                  width: double.infinity,
                  child: const Text(
                    "Create Account",
                    style: TextStyle(
                        color: Color.fromARGB(255, 40, 107, 53),
                        fontWeight: FontWeight.w900,
                        fontSize: 38),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),

                // This is the name input.
                TextFormField(
                  style: const TextStyle(
                      color: Color.fromARGB(255, 145, 145, 145), fontSize: 14),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),

                // This is the email input.
                TextFormField(
                  style: const TextStyle(
                      color: Color.fromARGB(255, 145, 145, 145), fontSize: 14),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),

                // This is the password input.
                TextFormField(
                  style: const TextStyle(
                      color: Color.fromARGB(255, 145, 145, 145), fontSize: 14),
                  keyboardType: TextInputType.visiblePassword,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.key),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),

                // This is the confirm password input.
                TextFormField(
                  style: const TextStyle(
                      color: Color.fromARGB(255, 145, 145, 145), fontSize: 14),
                  keyboardType: TextInputType.visiblePassword,
                  decoration: const InputDecoration(
                    labelText: "Confirm Password",
                    prefixIcon: Icon(Icons.key),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),

                // This is the sign up button.
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, Login.routeName, (route) => false);
                    },
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 40, 107, 53),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // This is the bottom text.
          Align(
            alignment: const Alignment(0, 0.9),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, Login.routeName, (route) => false);
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
                    "Sign In",
                    style: TextStyle(
                        color: Color.fromARGB(255, 40, 107, 53),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
