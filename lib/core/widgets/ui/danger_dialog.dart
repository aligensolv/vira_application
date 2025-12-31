// import 'package:flutter/material.dart';
// import 'package:vira/core/config/app_colors.dart';
// import 'package:vira/core/widgets/ui/base_dialog.dart';
// import 'package:vira/core/widgets/ui/app_button.dart';

// /// A specific dialog for confirming dangerous or irreversible actions.
// /// Built on top of [BaseDialog].
// class DangerDialog extends StatelessWidget {
//   final String title;
//   final Widget child;
//   final String confirmText;
//   final VoidCallback onConfirm;
  
//   const DangerDialog({
//     super.key,
//     required this.title,
//     required this.child,
//     this.confirmText = 'Delete',
//     required this.onConfirm,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BaseDialog(
//       variant: DialogVariant.primary, // Danger dialogs are usually dark
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header
//           Row(
//             children: [
//               const Icon(Icons.warning_amber_rounded, color: AppColors.destructive, size: 28),
//               const SizedBox(width: 12),
//               Text(
//                 title.toUpperCase(),
//                 style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),

//           // Content
//           Flexible(
//             child: SingleChildScrollView(
//               child: DefaultTextStyle(
//                 style: TextStyle(color: Colors.black.withOpacity(0.8), height: 1.5, fontSize: 20),
//                 child: child,
//               ),
//             ),
//           ),
//           const SizedBox(height: 24),

//           // Actions
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               AppButton(
//                 text: 'Cancel',
//                 onPressed: () => Navigator.of(context).pop(),
//                 variant: AppButtonVariant.secondary, type: null,
//               ),
//               const SizedBox(width: 12),
//               AppButton(
//                 text: confirmText,
//                 onPressed: () {
//                   onConfirm();
//                   Navigator.of(context).pop(true);
//                 },
//                 variant: AppButtonVariant.danger, type: null, // Use the danger variant
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }