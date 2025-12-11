plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.nutri_track"

    // Use Flutter's compileSdk version (usually 34)
    compileSdk = flutter.compileSdkVersion

    // REQUIRED: shared_preferences_android plugin demands NDK 27+
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.nutri_track"

        // These MUST be explicitly set for compatibility
        minSdk = 21       // Supports all modern phones including Redmi Note 13 Plus 5G
        targetSdk = 34    // Recommended modern target

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Using debug signing for now
            signingConfig = signingConfigs.getByName("debug")
            // Remove minify/proguard unless needed
        }
    }
}

flutter {
    source = "../.."
}
