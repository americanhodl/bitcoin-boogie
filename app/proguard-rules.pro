# No special proguard rules needed for WebView wrapper
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
