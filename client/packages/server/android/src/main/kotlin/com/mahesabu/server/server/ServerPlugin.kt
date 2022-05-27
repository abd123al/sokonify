package com.mahesabu.server.server

import android.util.Log
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

import lib.Lib.startServer
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.core.os.HandlerCompat
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import android.content.Context
import android.app.Activity

sealed class Resource<out R> {
    data class Success<out T>(val data: T) : Resource<T>()
    data class Error(val exception: Exception) : Resource<Nothing>()
}

/** ServerPlugin */
class ServerPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private val executorService: ExecutorService = Executors.newSingleThreadExecutor()
    private val threadHandler: Handler = HandlerCompat.createAsync(Looper.getMainLooper())

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "server")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "startServer") {
            try {
                val port = (8000..9999).random().toString()
                start(port) {
                    result.success(port)
                }
            } catch (e: Exception) {
                e.printStackTrace();
                result.error("Error in starting server", "${e.message}", null);
            }
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        executorService.shutdown()
    }

    /**
     * Reference
     * 1. https://developer.android.com/guide/background/threading
     */
    private fun start(
        port: String, callback: (Resource<String>) -> Unit
    ) {
        executorService.execute {
            try {
                val dir = context.filesDir
                val path = dir.path

                val result = startServer("$path/sokonify.db", port)
                val successResult = Resource.Success(result)
                threadHandler.post { callback(successResult) }
            } catch (e: Exception) {
                val errorResult = Resource.Error(e)
                threadHandler.post { callback(errorResult) }
            }
        }
    }
}
