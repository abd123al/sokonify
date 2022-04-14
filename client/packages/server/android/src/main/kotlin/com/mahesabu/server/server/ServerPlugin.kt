package com.mahesabu.server.server

import android.util.Log
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import lib.Lib.startServer
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.core.os.HandlerCompat
import androidx.fragment.app.Fragment
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

sealed class Resource<out R> {
    data class Success<out T>(val data: T) : Resource<T>()
    data class Error(val exception: Exception) : Resource<Nothing>()
}

/** ServerPlugin */
class ServerPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private val executorService: ExecutorService = Executors.newSingleThreadExecutor()
    private val threadHandler: Handler = HandlerCompat.createAsync(Looper.getMainLooper())

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "server")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "startServer") {
            try {
                start {
                    Log.d("FirstFragment", it.toString())
                }
                result.success("8080")
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
    }

    /**
     * Reference
     * 1. https://developer.android.com/guide/background/threading
     */
    private fun start(
        callback: (Resource<String>) -> Unit
    ) {
        executorService.execute {
            try {
                val port = startServer("")
                val result = Resource.Success(port)
                threadHandler.post { callback(result) }
            } catch (e: Exception) {
                val errorResult = Resource.Error(e)
                threadHandler.post { callback(errorResult) }
            }
        }
    }
}
