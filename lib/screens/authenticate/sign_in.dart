import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import '../../main.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({super.key, required this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}
class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = ''; bool loading = false; String email = '', password = '';
  @override
  Widget build(BuildContext context) {
    return loading ? const Loading() : Scaffold(
      backgroundColor: cream,
      body: SafeArea(child: Center(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(25, 28, 25, 32), child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 440), child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 58, height: 58, decoration: BoxDecoration(color: espresso, borderRadius: BorderRadius.circular(20)), child: const Icon(Icons.coffee_rounded, color: cream, size: 30)),
        const SizedBox(height: 36),
        const Text('BREW CLUB  /  MEMBERS', style: TextStyle(color: ember, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.w900)),
        const SizedBox(height: 12),
        const Text('Welcome back.', style: TextStyle(color: espresso, fontSize: 38, height: 1.03, fontWeight: FontWeight.w900, letterSpacing: -1.5)),
        const SizedBox(height: 12),
        Text('Sign in to get back to your cup and your people.', style: const TextStyle(color: muted, fontSize: 14, height: 1.5)),
        const SizedBox(height: 34),
        const Text('EMAIL ADDRESS', style: TextStyle(color: roast, fontSize: 10, letterSpacing: 1.3, fontWeight: FontWeight.w800)), const SizedBox(height: 9),
        TextFormField(keyboardType: TextInputType.emailAddress, decoration: textInputDecoration.copyWith(hintText: 'you@example.com', prefixIcon: const Icon(Icons.mail_outline_rounded, color: muted, size: 20)), validator: (val) => val!.trim().isEmpty ? 'Enter an email' : null, onChanged: (val) => email = val.trim()),
        const SizedBox(height: 18),
        const Text('PASSWORD', style: TextStyle(color: roast, fontSize: 10, letterSpacing: 1.3, fontWeight: FontWeight.w800)), const SizedBox(height: 9),
        TextFormField(obscureText: true, decoration: textInputDecoration.copyWith(hintText: 'At least 6 characters', prefixIcon: const Icon(Icons.lock_outline_rounded, color: muted, size: 20)), validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null, onChanged: (val) => password = val),
        const SizedBox(height: 22),
        if (error.isNotEmpty) Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFFFE8E1), borderRadius: BorderRadius.circular(12)), child: Text(error, style: const TextStyle(color: Color(0xFF9B3928), fontSize: 12))),
        const SizedBox(height: 8),
        SizedBox(width: double.infinity, height: 56, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: espresso, foregroundColor: cream, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), onPressed: () async {
          if (!_formKey.currentState!.validate()) return;
          setState(() { loading = true; error = ''; });
          final result = await _auth.signInWithEmailAndPassword(email, password);
          if (!mounted) return;
          if (result == null) setState(() { loading = false; error = 'Could not sign in with those credentials'; });
        }, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('SIGN IN', style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)), const SizedBox(width: 10), const Icon(Icons.arrow_forward_rounded, size: 19)]))),
        const SizedBox(height: 22),
        Center(child: Wrap(alignment: WrapAlignment.center, children: [Text('New around here? ', style: const TextStyle(color: muted, fontSize: 12)), GestureDetector(onTap: () => widget.toggleView(), child: const Text('Create account', style: TextStyle(color: ember, fontSize: 12, fontWeight: FontWeight.w900)))])),
        const SizedBox(height: 38),
        const Center(child: Text('GOOD COFFEE. BETTER COMPANY.', style: TextStyle(color: muted, fontSize: 9, letterSpacing: 1.7, fontWeight: FontWeight.w800))),
      ])))))));
  }
}
