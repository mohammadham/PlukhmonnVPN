import 'package:crisp/crisp.dart';
import 'package:flutter/widgets.dart';
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

class CrispPage extends StatefulWidget {
  const CrispPage({Key? key}) : super(key: key);

  @override
  CrispPageState createState() => CrispPageState();
}

class CrispPageState extends State<CrispPage> {
  late CrispMain crispMain;

  @override
  void initState() {
    super.initState();

    crispMain = CrispMain(
      websiteId: AppStrings.crispWebsiteId,
      locale: 'zh-cn',
      //locale: 'pr-cn',
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: CrispView(
      crispMain: crispMain,
      clearCache: false,
    ));
  }
}
