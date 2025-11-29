allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    // Ensure we can configure android extension even if project is already evaluated
    fun configureAndroid() {
        if (extensions.findByName("android") != null) {
            configure<com.android.build.gradle.BaseExtension> {
                compileSdkVersion(36)
            }
        }
    }

    if (state.executed) {
        configureAndroid()
    } else {
        afterEvaluate { configureAndroid() }
    }

    if (path != ":app") {
        // Only other projects might need to depend on app, but usually this is for flutter plugins
        // to get flutter configuration. 
        // However, the original code had this for all subprojects.
        // We keep it but wrap it to avoid circular dependency if app depends on something.
        // Actually, the original code was: project.evaluationDependsOn(":app")
        // We'll leave the original dependency logic alone if possible, or restore it.
        // But wait, if I replace the block, I remove the original line.
        // The original line was: project.evaluationDependsOn(":app")
    }
    // We should probably keep the evaluationDependsOn(":app") but maybe only if not app?
    // The error came because I added a NEW subprojects block AFTER the one that did evaluationDependsOn.
    // So I should just MERGE them or put mine first.
}

subprojects {
    if (path != ":app") {
        project.evaluationDependsOn(":app")
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
