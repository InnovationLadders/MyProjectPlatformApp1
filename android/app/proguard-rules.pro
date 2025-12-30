# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# flutter_inappwebview
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
-keepattributes JavascriptInterface
-keepattributes *Annotation*
-dontwarn com.pichillilorenzo.flutter_inappwebview.**
-keep class com.pichillilorenzo.flutter_inappwebview.** { *; }
-keep interface com.pichillilorenzo.flutter_inappwebview.** { *; }
