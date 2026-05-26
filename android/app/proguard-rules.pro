# AdMob
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.android.gms.internal.ads.** { *; }
-dontwarn com.google.android.gms.ads.**
-dontwarn com.google.android.gms.internal.ads.**

# FFmpegKit
-keep class com.arthenica.ffmpegkit.** { *; }
-dontwarn com.arthenica.ffmpegkit.**
-keep class com.antonkarpenko.ffmpegkit.** { *; }
-dontwarn com.antonkarpenko.ffmpegkit.**
-keepclasseswithmembernames class * {
    native <methods>;
}
-keep class com.antonkarpenko.ffmpegkit.FFmpegKitConfig {
    native <methods>;
    void log(long, int, byte[]);
    void statistics(long, int, float, float, long, double, double, double);
    int safOpen(int);
    int safClose(int);
}
-keep class com.antonkarpenko.ffmpegkit.AbiDetect {
    native <methods>;
}

# Flutter
-keep class io.flutter.** { *; }
-dontwarn io.flutter.embedding.**

# General
-keep class * extends java.lang.Exception

# Firebase
-keep class com.google.firebase.** { *; }
-keep enum com.google.firebase.** { *; }
-keep interface com.google.firebase.** { *; }
-keep class com.google.android.gms.tasks.** { *; }
-dontwarn com.google.firebase.**

# Pigeon (Firebase Communication)
-keep class dev.flutter.pigeon.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugins.firebase.core.** { *; }
-keep class com.google.firebase.firestore.FirestoreHostApi { *; }
-keep class com.google.firebase.auth.FirebaseAuthHostApi { *; }
-keep class com.google.firebase.storage.FirebaseStorageHostApi { *; }
-keep class com.google.firebase.functions.FirebaseFunctionsHostApi { *; }