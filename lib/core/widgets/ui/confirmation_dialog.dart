// import 'package:flutter/material.dart';
// import 'package:vira/core/widgets/ui/base_dialog.dart';
// import 'package:vira/core/widgets/ui/app_button.dart';

// /// A specific dialog for showing information and getting user confirmation.
// /// Built on top of [BaseDialog].
// class ConfirmationDialog extends StatelessWidget {
//   final String title;
//   final Widget? child;
//   final String? confirmText;
//   final String? cancelText;
//   final VoidCallback? onConfirm;
//   final VoidCallback? onCancel;
//   final DialogVariant variant;

//   const ConfirmationDialog({
//     super.key,
//     required this.title,
//     this.child,
//     this.confirmText = 'OK',
//     this.cancelText = 'Cancel',
//     this.onConfirm,
//     this.onCancel,
//     this.variant = DialogVariant.primary,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final bool isPrimary = variant == DialogVariant.primary;
//     final Color textColor = isPrimary ? Colors.white : Colors.black;

//     return BaseDialog(
//       variant: variant,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
//               ),
//               IconButton(
//                 icon: Icon(Icons.close, color: textColor.withOpacity(0.7)),
//                 onPressed: () => Navigator.of(context).pop(),
//               )
//             ],
//           ),
//           const SizedBox(height: 16),

//           // Content
//           if (child != null)
//             Flexible( // Flexible allows the content to scroll if it's too long
//               child: SingleChildScrollView(
//                 child: DefaultTextStyle(
//                   style: TextStyle(color: textColor.withOpacity(0.8), height: 1.5),
//                   child: child!,
//                 ),
//               ),
//             ),
//           const SizedBox(height: 24),

//           // Actions
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               if (cancelText != null)
//                 AppButton(
//                   text: cancelText!,
//                   onPressed: onCancel ?? () => Navigator.of(context).pop(),
//                   variant: AppButtonVariant.secondary,
//                   isCompact: true, type: null,
//                 ),
//               if (cancelText != null && confirmText != null)
//                 const SizedBox(width: 12),
//               if (confirmText != null)
//                 AppButton(
//                   text: confirmText!,
//                   onPressed: () {
//                     onConfirm?.call();
//                     Navigator.of(context).pop(true); // Pop with a `true` result
//                   },
//                   variant: AppButtonVariant.primary,
//                   isCompact: true, type: null,
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }