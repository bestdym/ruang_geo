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
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

subprojects {
    val configureAndroid: Project.() -> Unit = {
        val androidExtension = extensions.findByName("android")
        if (androidExtension != null) {
            try {
                val getNamespace = androidExtension.javaClass.getMethod("getNamespace")
                val namespace = getNamespace.invoke(androidExtension)
                if (namespace == null) {
                    val setNamespace = androidExtension.javaClass.getMethod("setNamespace", String::class.java)
                    val packageName = "com.ruanggeo." + name.replace("-", "_").replace(":", "_")
                    setNamespace.invoke(androidExtension, packageName)
                    println("Automatically set namespace to $packageName for subproject $name")
                }
            } catch (e: Exception) {
                // Ignore if method does not exist (older AGP versions)
            }
        }
    }

    if (state.executed) {
        configureAndroid()
    } else {
        afterEvaluate {
            configureAndroid()
        }
    }
}
