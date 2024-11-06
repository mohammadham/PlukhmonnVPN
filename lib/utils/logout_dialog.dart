//
// import 'package:flutter/material.dart';
// import 'package:sail/utils/l10n.dart';
// import 'package:sail/service/auth_provider.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:sail/utils/l10n.dart';
// class LogoutDialog extends StatelessWidget {
//   const LogoutDialog({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Consumer(
//         builder: (context, ref, child) {
//           final t = ref.watch(BuildContext context);
//           return Text(t.logout.confirmationMessage);
//         },
//       ),
//       actions: [
//         Consumer(
//           builder: (context, ref, child) {
//             final t = ref.watch(translationsProvider);
//             return TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text(t.logout.cancelButton),
//             );
//           },
//         ),
//         Consumer(
//           builder: (context, ref, child) {
//             final t = ref.watch(translationsProvider);
//             return TextButton(
//               onPressed: () async {
//                 // 调用登出逻辑
//                 await logout(context, ref);
//                 Navigator.of(context).pop();
//               },
//               child: Text(t.logout.confirmButton),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
