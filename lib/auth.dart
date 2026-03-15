import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  bool _loading = false;
  String _error = '';

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  Future<void> _submit() async {
    if (!mounted) return;
    setState(() { _loading = true; _error = ''; });
    try {
      if (_isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        await FirebaseAuth.instance.currentUser?.updateDisplayName(_nameController.text.trim());
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = e.code == 'user-not-found' ? 'Compte introuvable.' :
                 e.code == 'wrong-password' ? 'Mot de passe incorrect.' :
                 e.code == 'email-already-in-use' ? 'Email déjà utilisé.' :
                 e.code == 'weak-password' ? 'Mot de passe trop faible.' :
                 'Erreur : ${e.message}';
      });
    } finally {
      if (mounted) setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Logo
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: 'Write', style: GoogleFonts.syne(fontSize: 36, fontWeight: FontWeight.w800, color: C.dark)),
                    TextSpan(text: 'Wise', style: GoogleFonts.syne(fontSize: 36, fontWeight: FontWeight.w800, color: C.accent)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isLogin ? 'Bon retour 👋' : 'Créer ton compte ✨',
                style: GoogleFonts.nunito(fontSize: 16, color: C.muted),
              ),
              const SizedBox(height: 40),

              // Formulaire
              if (!_isLogin) ...[
                _field('Ton prénom', _nameController, false),
                const SizedBox(height: 14),
              ],
              _field('Email', _emailController, false),
              const SizedBox(height: 14),
              _field('Mot de passe', _passwordController, true),
              const SizedBox(height: 8),

              // Erreur
              if (_error.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: C.redSoft, borderRadius: BorderRadius.circular(10)),
                  child: Text(_error, style: GoogleFonts.nunito(fontSize: 13, color: C.red)),
                ),
              const SizedBox(height: 24),

              // Bouton principal
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: C.accent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      : Text(
                          _isLogin ? 'Se connecter' : 'Créer mon compte',
                          style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Switch login/register
              Center(
                child: GestureDetector(
                  onTap: () => setState(() { _isLogin = !_isLogin; _error = ''; }),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: _isLogin ? 'Pas encore de compte ? ' : 'Déjà un compte ? ',
                          style: GoogleFonts.nunito(fontSize: 14, color: C.muted),
                        ),
                        TextSpan(
                          text: _isLogin ? 'S\'inscrire' : 'Se connecter',
                          style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700, color: C.accent),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller, bool obscure) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700, color: C.dark)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          style: GoogleFonts.nunito(fontSize: 15, color: C.dark),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: C.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: C.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: C.accent, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}