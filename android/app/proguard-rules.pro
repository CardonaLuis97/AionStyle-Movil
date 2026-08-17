# Stripe rules
-dontwarn com.stripe.android.pushProvisioning.**
-keep class com.stripe.android.** { *; }

# Google Play Services TapAndPay rules
-dontwarn com.google.android.gms.tapandpay.**

# Google Play Core rules (Flutter deferred components)
-dontwarn com.google.android.play.core.**

# Flutter and other dependencies
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
