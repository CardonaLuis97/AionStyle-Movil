allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

subprojects {
    project.evaluationDependsOn(":app")
    configurations.all {
        resolutionStrategy {
            // Exclude the private TapAndPay SDK which is not available publicly.
            // This is safe if Push Provisioning features are not used.
            exclude(group = "com.google.android.gms", module = "play-services-tapandpay")
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
