import 'package:admin_peka/ui/widget/responsive_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../common/navigation.dart';
import '../../common/styles.dart';
import '../../services/firebase/auth/auth.dart';
import '../widget/button.dart';
import '../widget/custom_text_form_field.dart';
import '../widget/custom_toast.dart';
import 'dashboard.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login-page';

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kWhiteColor,
        body: ResponsiveWidget.isSmallScreen(context)
            ? _body(true)
            : _body(false),
      ),
    );
  }

  Widget _body(bool isSmall) {
    return LoadingOverlay(
      isLoading: _isLoading,
      color: kGreyBgColor,
      opacity: 0.7,
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            width: isSmall ? null : MediaQuery.of(context).size.width / 3,
            margin: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
            padding:
                const EdgeInsets.symmetric(vertical: 30.0, horizontal: 24.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: kWhiteBgColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24.0),
                  _buildEmail(),
                  const SizedBox(height: 10.0),
                  _buildPassword(),
                  const SizedBox(height: 40.0),
                  Button(
                    textButton: "Masuk",
                    onTap: _login,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Kata Sandi",
          style: blackTextStyle.copyWith(fontSize: 16, fontWeight: medium),
        ),
        const SizedBox(
          height: 5.0,
        ),
        CustomTextFormField(
          hintText: 'Tulis kata sandi kamu',
          errorText: 'Masukkan kata sandi kamu',
          obscureText: true,
          controller: _passwordController,
        ),
      ],
    );
  }

  Widget _buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Alamat Email",
          style: blackTextStyle.copyWith(fontSize: 16, fontWeight: medium),
        ),
        const SizedBox(
          height: 5.0,
        ),
        CustomTextFormField(
          hintText: 'Tulis alamat email kamu',
          errorText: 'Masukkan alamat email kamu',
          controller: _emailController,
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "PEKA",
          style: blackTextStyle.copyWith(fontSize: 26, fontWeight: semiBold),
        ),
        Text(
          "Selamat Datang wahai admin",
          style: greyTextStyle.copyWith(fontSize: 14, fontWeight: regular),
        ),
      ],
    );
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (_formKey.currentState!.validate() &&
          (_emailController.text == 'ridhoi@gmail.com' ||
              _emailController.text == 'nadiamrnt@gmail.com')) {
        final email = _emailController.text;
        final password = _passwordController.text;

        await Auth.signInEmail(email, password).then((result) {
          Navigation.intentReplacementWithData(Dashboard.routeName, {
            'admin':
                _emailController.text == 'ridhoi@gmail.com' ? 'ridhoi' : 'nadia'
          });
        });
      } else {
        SmartDialog.showToast(
          '',
          widget: const CustomToast(
            msg: 'Masukka email dengan benar',
            isError: true,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.message == 'The email address is badly formatted.') {
        SmartDialog.showToast(
          '',
          widget: const CustomToast(
            msg: 'Masukkan kata sandi dengan benar',
            isError: true,
          ),
        );
      } else if (e.toString() ==
          'There is no user record corresponding to this identifier. The user may have been deleted.') {
        SmartDialog.showToast(
          '',
          widget: const CustomToast(
            msg: 'Email tidak ditemukan',
            isError: true,
          ),
        );
      } else if (e.toString() ==
          'A network error (such as timeout, interrupted connection or unreachable host) has occurred.') {
        SmartDialog.showToast(
          '',
          widget: const CustomToast(
            msg: 'Tidak ada koneksi internet',
            isError: true,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
