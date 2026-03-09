// import 'dart:developer';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import '../../../constants/asset_path.dart';
// import '../../../constants/colors.dart';
// import '../../../constants/spacing.dart';
// import '../../../services/auth_service.dart';

// class GoogleSignInButton extends StatelessWidget {
//   const GoogleSignInButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () async {
//         final User? user =
//             await AuthenticationService.signInWithGoogle(context: context);
//         log('---------$user');
//         final token = await user?.getIdToken();
//         log('---------$token--------');
//       },
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(sp12),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(sp12),
//           border: Border.all(color: borderColor_2, width: 1),
//         ),
//         child: SizedBox(
//           height: sp20,
//           width: sp20,
//           child: Image.asset(
//             '${AssetsPath.image}/login/img_google.png',
//             fit: BoxFit.contain,
//           ),
//         ),
//       ),
//     );
//   }
// }
