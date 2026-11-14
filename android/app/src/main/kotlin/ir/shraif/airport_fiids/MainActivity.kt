package ir.shraif.airport_fiids

import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "ir.shraif.airport_fiids/nav_apps"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "isAppInstalled" -> {
                    val packages = call.argument<List<String>>("packages") ?: emptyList()
                    var installed = false
                    for (pkg in packages) {
                        if (isPackageInstalled(pkg)) {
                            installed = true
                            break
                        }
                    }
                    result.success(installed)
                }
                "launchNav" -> {
                    val packages = call.argument<List<String>>("packages") ?: emptyList()
                    val navUriString = call.argument<String>("navUri")
                    val fallbackWebUrl = call.argument<String>("fallbackWebUrl")

                    var launched = false
                    val installedPkg = packages.firstOrNull { isPackageInstalled(it) }

                    if (navUriString != null && installedPkg != null) {
                        try {
                            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(navUriString))
                            intent.setPackage(installedPkg)
                            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            startActivity(intent)
                            launched = true
                        } catch (e: Exception) {
                            launched = false
                        }
                    }

                    if (!launched && navUriString != null) {
                        try {
                            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(navUriString))
                            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            startActivity(intent)
                            launched = true
                        } catch (e: Exception) {
                            launched = false
                        }
                    }

                    if (!launched && installedPkg != null) {
                        try {
                            val launchIntent = packageManager.getLaunchIntentForPackage(installedPkg)
                            if (launchIntent != null) {
                                launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                                startActivity(launchIntent)
                                launched = true
                            }
                        } catch (e: Exception) {
                            launched = false
                        }
                    }

                    if (!launched && fallbackWebUrl != null) {
                        try {
                            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(fallbackWebUrl))
                            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            startActivity(intent)
                            launched = true
                        } catch (e: Exception) {
                            launched = false
                        }
                    }

                    result.success(launched)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun isPackageInstalled(packageName: String): Boolean {
        return try {
            packageManager.getPackageInfo(packageName, 0)
            true
        } catch (e: PackageManager.NameNotFoundException) {
            false
        }
    }
}

