import 'package:flutter/material.dart';
import 'package:sail/constant/app_images.dart';
<<<<<<< HEAD
<<<<<<< Updated upstream
import 'package:sail/constant/app_strings.dart';
=======
import 'package:sail/resources/app_strings.dart';
>>>>>>> Stashed changes
=======
<<<<<<< HEAD
import 'package:sail/resources/app_strings.dart';
=======
import 'package:sail/constant/app_strings.dart';
>>>>>>> 9f01e9fe824b24f769f882f918aba04fcc7d0f67
>>>>>>> 83d405314eccec8c8367743283de6e02dc21ae55


class NotFindPage extends StatelessWidget {
  const NotFindPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(AppStrings.appName),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Image.asset(
            AppImages.notFoundPicture,
            width: 200,
            height: 100,
            color: const Color(0xFFff5722),
          ),
        ));
  }
}
