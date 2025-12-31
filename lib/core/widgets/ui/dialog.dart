// import 'package:flutter/material.dart';
// import 'package:vira/core/config/app_theme.dart';
// import 'package:vira/core/widgets/ui/button.dart';

// class AppDialog extends StatelessWidget {
//   final String title;
//   final String content;
//   final String primaryActionText;
//   final VoidCallback onPrimaryAction;
//   final String? secondaryActionText;
//   final VoidCallback? onSecondaryAction;
//   final bool isDanger;

//   const AppDialog({
//     super.key,
//     required this.title,
//     required this.content,
//     required this.primaryActionText,
//     required this.onPrimaryAction,
//     this.secondaryActionText,
//     this.onSecondaryAction,
//     this.isDanger = false,
//   });

//   // Static helper to show the dialog easily
//   static Future<void> show(
//     BuildContext context, {
//     required String title,
//     required String content,
//     required String primaryActionText,
//     required VoidCallback onPrimaryAction,
//     String? secondaryActionText,
//     VoidCallback? onSecondaryAction,
//     bool isDanger = false,
//   }) {
//     return showDialog(
//       context: context,
//       builder: (context) => AppDialog(
//         title: title,
//         content: content,
//         primaryActionText: primaryActionText,
//         onPrimaryAction: onPrimaryAction,
//         secondaryActionText: secondaryActionText,
//         onSecondaryAction: onSecondaryAction,
//         isDanger: isDanger,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 0,
//       backgroundColor: Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: isDanger ? AppTheme.errorColor : AppTheme.primaryColor,
//                   ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               content,
//               style: const TextStyle(color: Colors.black54, fontSize: 15),
//             ),
//             const SizedBox(height: 24),
//             Column(
//               children: [
//                 AppButton(
//                   text: primaryActionText,
//                   onPressed: () {
//                     Navigator.pop(context); // Close dialog
//                     onPrimaryAction();
//                   },
//                   type: isDanger ? AppButtonType.danger : AppButtonType.primary,
//                 ),
//                 if (secondaryActionText != null) ...[
//                   const SizedBox(height: 8),
//                   AppButton(
//                     text: secondaryActionText!,
//                     onPressed: () {
//                       Navigator.pop(context);
//                       if (onSecondaryAction != null) onSecondaryAction!();
//                     },
//                     type: AppButtonType.outline,
//                   ),
//                 ],
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }