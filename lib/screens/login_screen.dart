import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../services/auth_service.dart';
import '../constants/legal_text.dart';
import 'legal_document_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _isLoginMode = true; // true = login, false = registro
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailPasswordAuth() async {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você precisa aceitar os Termos de Uso e a Política de Privacidade para continuar.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isLoginMode) {
        await _authService.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login realizado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pushReplacementNamed('/patient_list');
        }
      } else {
        await _authService.signUpWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Conta criada com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pushReplacementNamed('/patient_list');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você precisa aceitar os Termos de Uso e a Política de Privacidade para continuar.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _authService.signInWithGoogle();
      if (result != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login com Google realizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pushReplacementNamed('/patient_list');
      } else if (mounted) {
        // Usuário cancelou o login
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleAppleSignIn() async {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você precisa aceitar os Termos de Uso e a Política de Privacidade para continuar.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _authService.signInWithApple();
      if (result != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login com Apple realizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pushReplacementNamed('/patient_list');
      } else if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleResetPassword() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite seu email primeiro'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      await _authService.resetPassword(_emailController.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email de recuperação enviado! Verifique sua caixa de entrada.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Branding Section
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                         BoxShadow(
                          color: Colors.blue.withOpacity(0.2),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ]
                    ),
                    child: Image.asset(
                      'assets/images/app_icon.png',
                      height: 100,
                      width: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Neurologicas',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0D47A1), // Deep Blue
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD), // Light Blue
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Calculadora Neurológica',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1976D2),
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  Text(
                    _isLoginMode ? 'Bem-vindo de volta' : 'Crie sua conta',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  
                  // Campo de email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[50],
                      labelText: 'Email',
                      hintText: 'seu@email.com',
                      prefixIcon: const Icon(Icons.email_outlined, color: Colors.blueGrey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey[200]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite seu email';
                      }
                      // Formato estrito de email
                      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,6}$');
                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Digite um email válido (ex: nome@dominio.com)';
                      }
                      
                      // Lista de erros de digitação comuns em domínios populares
                      final emailLower = value.trim().toLowerCase();
                      final domainTypos = {
                        'gmaill': 'gmail.com',
                        'gmail.co': 'gmail.com',
                        'gmail.com.b': 'gmail.com.br',
                        'hotmaill': 'hotmail.com',
                        'hotmai': 'hotmail.com',
                        'yaho': 'yahoo.com',
                        'outlok': 'outlook.com',
                        'outloock': 'outlook.com',
                      };
                      
                      final parts = emailLower.split('@');
                      if (parts.length == 2) {
                        final domain = parts[1];
                        // Verifica se o domínio corresponde a algum erro ou se falta a extensão (ex: só @gmail ou @yahoo)
                        for (final typo in domainTypos.keys) {
                          if (domain == typo || domain.startsWith('$typo.') || domain == '$typo.com') {
                            if (domain != domainTypos[typo]) {
                              return 'Erro de digitação detectado. Quis dizer @${domainTypos[typo]}?';
                            }
                          }
                        }
                        
                        // Bloquear domínios sem extensão
                        final popularDomainsWithoutTld = ['gmail', 'yahoo', 'hotmail', 'outlook', 'live', 'msn', 'icloud'];
                        if (popularDomainsWithoutTld.contains(domain)) {
                          return 'Insira o domínio completo (ex: @$domain.com)';
                        }
                      }
                      
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Campo de senha
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[50],
                      labelText: 'Senha',
                      hintText: 'Digite sua senha',
                      prefixIcon: const Icon(Icons.lock_outline, color: Colors.blueGrey),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: Colors.blueGrey,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                       enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey[200]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite sua senha';
                      }
                      if (!_isLoginMode) {
                        if (value.length < 8) {
                          return 'A senha deve ter pelo menos 8 caracteres';
                        }
                        if (!value.contains(RegExp(r'[A-Z]'))) {
                          return 'A senha deve conter pelo menos uma letra maiúscula';
                        }
                        if (!value.contains(RegExp(r'[a-z]'))) {
                          return 'A senha deve conter pelo menos uma letra minúscula';
                        }
                        if (!value.contains(RegExp(r'[0-9]'))) {
                          return 'A senha deve conter pelo menos um número';
                        }
                        if (!value.contains(RegExp(r'[!@#\$&*~]'))) {
                          return 'A senha deve conter pelo menos um caractere especial (!@#\$&*~)';
                        }
                      }
                      return null;
                    },
                  ),
                  
                  // Link de recuperação de senha (apenas no modo login)
                  if (_isLoginMode)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _handleResetPassword,
                        child: Text(
                          'Esqueceu a senha?',
                          style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 16),

                  const SizedBox(height: 16),
                  
                  // Terms of Use Checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: _agreedToTerms,
                        activeColor: const Color(0xFF0D47A1),
                        onChanged: (value) {
                          setState(() {
                            _agreedToTerms = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: Wrap(
                          children: [
                            const Text('Li e concordo com os ', style: TextStyle(fontSize: 12)),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LegalDocumentScreen(
                                      title: 'Termos de Uso',
                                      content: LegalText.termsOfUse,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Termos de Uso',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0D47A1),
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            const Text(' e ', style: TextStyle(fontSize: 12)),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LegalDocumentScreen(
                                      title: 'Política de Privacidade',
                                      content: LegalText.privacyPolicy,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Política de Privacidade',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0D47A1),
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Botão de login/registro
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleEmailPasswordAuth,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D47A1), // Deep Blue
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: Colors.blue.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              _isLoginMode ? 'Entrar' : 'Criar Conta',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),

                  const SizedBox(height: 32),
                  
                  // Divisor
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[300])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OU CONTINUAR COM',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey[300])),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Botão de login com Google
                  SizedBox(
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: _isLoading ? null : _handleGoogleSignIn,
                      icon: const Icon(Icons.g_mobiledata, color: Colors.blue, size: 32), 
                      label: const Text(
                        'Entrar com Google',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.grey[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Botão de login com Apple
                  SignInWithAppleButton(
                    onPressed: _isLoading ? () {} : _handleAppleSignIn,
                    text: 'Entrar com Apple',
                    style: SignInWithAppleButtonStyle.black,
                    height: 56,
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                  ),
                  const SizedBox(height: 32),
                  
                  // Alternar entre login e registro
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isLoginMode
                            ? 'Não tem uma conta? '
                            : 'Já tem uma conta? ',
                        style: TextStyle(color: Colors.grey[600], fontSize: 15),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isLoginMode = !_isLoginMode;
                            _passwordController.clear();
                          });
                        },
                        child: Text(
                          _isLoginMode ? 'Registre-se' : 'Faça login',
                          style: const TextStyle(
                            color: Color(0xFF0D47A1), 
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
