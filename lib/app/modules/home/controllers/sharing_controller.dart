// // import 'dart:io';
// // import 'package:receive_sharing_intent/receive_sharing_intent.dart';
// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
// import 'package:flutter_sharing_intent/model/sharing_file.dart';
// import 'package:video_spliter/app/modules/home/controllers/home_controller.dart';

// class SharingController extends HomeController {
//   late StreamSubscription _intentDataStreamSubscription;

//   @override
//   void dispose() {
//     _intentDataStreamSubscription.cancel();
//     super.dispose();
//   }

//   @override
//   void initSharingListener() {
//     log("listening");
//     // Cas 1 : App déjà en mémoire
//     _intentDataStreamSubscription = FlutterSharingIntent.instance
//         .getMediaStream()
//         .listen(
//           (List<SharedFile> files) {
//             if (files.isNotEmpty) {
//               handleSharedVideo(files.first);
//             }
//           },
//           onError: (err) {
//             print("Erreur de partage (stream) : $err");
//           },
//         );

//     // Cas 2 : App lancée via partage
//     FlutterSharingIntent.instance.getInitialSharing().then((
//       List<SharedFile> files,
//     ) {
//       if (files.isNotEmpty) {
//         handleSharedVideo(files.first);
//       }
//     });
//   }

//   @override
//   void handleSharedVideo(SharedFile file) {
//     print("📥 Vidéo reçue : ${file.value}");
//     // Tu peux maintenant rediriger vers une page ou lancer le découpage automatiquement
//   }
// }
