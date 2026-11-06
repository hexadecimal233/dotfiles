val mirrors =
    listOf(
        "https://maven.aliyun.com/repository/google",
        "https://maven.aliyun.com/repository/public",
        "https://maven.aliyun.com/repository/gradle-plugin",
    )

beforeSettings {
    pluginManagement {
        repositories {
            mirrors.forEach { maven(it) }
            gradlePluginPortal()
            google()
            mavenCentral()
        }
    }
}

allprojects {
    buildscript {
        repositories {
            mirrors.forEach { maven(it) }
            google()
            mavenCentral()
        }
    }
    repositories {
        mirrors.forEach { maven(it) }
        google()
        mavenCentral()
    }
}
