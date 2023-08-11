package br.ideploy.pos.integration.flutter_plugin_pos_integration

import android.app.Activity
import android.content.Context
import android.util.Log
import com.zoop.pos.Zoop
import com.zoop.pos.collection.UserSelection
import com.zoop.pos.plugin.DashboardConfirmationResponse
import com.zoop.pos.plugin.DashboardThemeResponse
import com.zoop.pos.plugin.DashboardTokenResponse
import com.zoop.pos.plugin.ZoopFoundationPlugin
import com.zoop.pos.requestfield.MessageCallbackRequestField
import com.zoop.pos.type.Callback
import com.zoop.pos.type.Environment
import com.zoop.pos.type.LogLevel
import com.zoop.pos.type.Option
import com.zoop.sdk.plugin.mpos.MPOSPlugin
import com.zoop.sdk.plugin.mpos.bluetooth.platform.BluetoothDevice
import com.zoop.sdk.plugin.mpos.bluetooth.platform.BluetoothFamily
import com.zoop.sdk.plugin.mpos.request.PairingStatus
import com.zoop.sdk.plugin.mpos.request.mPOSDiscoveryResponse
import com.zoop.sdk.plugin.mpos.request.mPOSPaymentResponse
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject
import java.util.concurrent.TimeUnit

/** FlutterPluginPosIntegrationPlugin */
class FlutterPluginPosIntegrationPlugin : FlutterPlugin, ActivityAware {
    private val nameSpace = "br.ideploy.pos.integration.flutter_plugin_pos_integration"
    val tag = "IDeploy: "

    private lateinit var channel: MethodChannel
    private var context: Context? = null
    private var mEventSink: EventSink? = null
    private var eventChannel: EventChannel? = null
    private var activity: Activity? = null
    private var binaryMessenger: BinaryMessenger? = null
    private lateinit var bluetoothDevice: UserSelection<BluetoothDevice>


    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        binaryMessenger = flutterPluginBinding.binaryMessenger
        context = flutterPluginBinding.applicationContext
    }

    private fun makeSuccessResponse(type: String, data: JSONObject?): JSONObject {
        val response = JSONObject()
        response.put("type", type)
        response.put("data", data)
        response.put("success", true)
        return response
    }

    private fun makeErrorResponse(type: String, error: String?): JSONObject {
        val response = JSONObject()
        response.put("type", type)
        response.put("error", error)
        response.put("success", false)
        return response
    }

    private fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "initialize" -> {
                try {
                    val args = call.arguments() as String?
                    val response = makeSuccessResponse("initialize", JSONObject().apply {
                        put("withCredentials", args != null)
                    })
                    initializeZoop(args)
                    result.success(response.toString())

                } catch (e: Exception) {
                    result.error("initialize", e.message, null)
                }
            }
            "login" -> {
                login()
                val response = makeSuccessResponse("login", null)
                result.success(response.toString())
            }
            "startScan" -> {
                scan()
                val response = makeSuccessResponse("startScan", null)
                result.success(response.toString())
            }
            "requestConnection" -> {
                try {
                    requestConnection(call.arguments()!!)
                    val response = makeSuccessResponse("pair", JSONObject().apply {
                        put("start", true)
                    })
                    result.success(response.toString())
                } catch (e: Exception) {
                    result.error("requestConnection", e.message, null)
                }
            }
            "charge" -> {
                try {
                    charge(call.arguments()!!)
                    val response = makeSuccessResponse("requestConnection", null)
                    result.success(response.toString())
                } catch (e: Exception) {
                    result.error("charge", e.message, null)
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(activityPluginBinding: ActivityPluginBinding) {
        activity = activityPluginBinding.activity

        channel = MethodChannel(binaryMessenger!!, "$nameSpace/methods")
        channel.setMethodCallHandler { call, result ->
            onMethodCall(call, result)
        }

        eventChannel =
            EventChannel(binaryMessenger!!, "$nameSpace/events")
        eventChannel!!.setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, eventSink: EventSink) {
                    mEventSink = eventSink
                }

                override fun onCancel(p0: Any?) {
                    eventChannel!!.setStreamHandler(null)
                    mEventSink = null
                }
            }
        )
    }


    override fun onDetachedFromActivityForConfigChanges() {
        Log.d(tag, "onDetachedFromActivityForConfigChanges")
    }

    override fun onReattachedToActivityForConfigChanges(p0: ActivityPluginBinding) {
        Log.d(tag, "onDetachedFromActivityForConfigChanges")
    }

    override fun onDetachedFromActivity() {
        Log.d(tag, "onDetachedFromActivityForConfigChanges")
    }

    private fun invokeMethodUIThread(response: JSONObject) {
        activity!!.runOnUiThread {
            mEventSink!!.success(response.toString())
        }
    }

    private fun initializeZoop(data: String?) {
        var marketplaceId: String? = null
        var sellerId: String? = null
        var key: String? = null

        if (data != null) {
            val jsonObject = JSONObject(data)
            marketplaceId = (jsonObject["marketplaceId"] as String)
            sellerId = (jsonObject["sellerId"] as String)
            key = (jsonObject["accessKey"] as String)
        }

        context?.let {
            Zoop.initialize(it) {
                if (marketplaceId != null) {
                    credentials {
                        marketplace = marketplaceId
                        seller = sellerId!!
                        accessKey = key!!
                    }
                }
            }

            Zoop.setEnvironment(Environment.Production)
            Zoop.setLogLevel(LogLevel.Trace)
            Zoop.setStrict(false)
            Zoop.setTimeout(30 * 1000L)
            Zoop.findPlugin<MPOSPlugin>() ?: Zoop.make<MPOSPlugin>().run(Zoop::plug)
        }
    }

    private fun requestConnection(data: String) {
        val jsonObject = JSONObject(data)
        val device = BluetoothDevice(
            address = jsonObject["address"] as String,
            name = jsonObject["name"] as String,
            family = BluetoothFamily.valueOf(jsonObject["family"] as String)
        )
        bluetoothDevice.select(device)
    }



    private fun scan() {
        MPOSPlugin.createDiscoveryRequestBuilder()
            .time(6L, TimeUnit.SECONDS)
            .callback(object : Callback<mPOSDiscoveryResponse>() {
                override fun onStart() {
                    Log.d(tag, "start discovery")
                    val response = makeSuccessResponse("scan", JSONObject().apply {
                        put("start", true)
                    })
                    invokeMethodUIThread(response)
                }

                override fun onFail(error: Throwable) {
                    Log.d(tag, "Falha ao buscar dispositivos ${error.stackTraceToString()}")
                    val response = makeErrorResponse("scan", error.message)
                    invokeMethodUIThread(response)
                }

                override fun onSuccess(response: mPOSDiscoveryResponse) {
                    Log.d(tag, "Dispositivos encontrados: ${response.available.items}")

                    bluetoothDevice = response.available

                    val keywords = arrayOf("MP15", "MP5", "D180", "D175")
                    val devices = JSONArray()
                    for (item in response.available.items) {
                        val match = keywords.filter { item.name.contains(it, ignoreCase = true) }
                        if (match.isNotEmpty()) {
                            devices.apply {
                                put(JSONObject().apply {
                                    put("name", item.name)
                                    put("address", item.address)
                                    put("family", item.family.toString())
                                })
                            }
                        }
                    }

                    val devicesResponse = makeSuccessResponse("scan", JSONObject().apply {
                        put("devices", devices.toString())
                    })
                    invokeMethodUIThread(devicesResponse)
                }

            })
            .pairingCallback(
                object : Callback<PairingStatus>() {
                    override fun onFail(error: Throwable) {
                        Log.d(tag, "Falha ao parear dispositivo")
                        val response = makeErrorResponse("pair", error.message)
                        invokeMethodUIThread(response)
                    }

                    override fun onSuccess(response: PairingStatus) {
                        Log.d(tag, "Pareado com sucesso")
                        Log.d(tag, response.status.toString())

                        if (response.status) {
                            invokeMethodUIThread(makeSuccessResponse("pair", null))
                        } else {
                            invokeMethodUIThread(makeErrorResponse("pair", null))
                        }
                    }

                }).build().run(Zoop::post)
    }

    private fun charge(data: String) {
        val jsonObject = JSONObject(data)

        val paymentRequest = MPOSPlugin.createPaymentRequestBuilder()
            .amount((jsonObject["value"] as Int).toLong())
            .option(Option.valueOf(jsonObject["paymentOption"] as String))
            .installments(jsonObject["installments"] as Int)
            .callback(object : Callback<mPOSPaymentResponse>() {
                override fun onStart() {
                    val response = makeSuccessResponse("payment", JSONObject().apply {
                        put("status", "start")
                    })
                    invokeMethodUIThread(response)
                }

                override fun onSuccess(response: mPOSPaymentResponse) {
                    val responseSuccess = makeSuccessResponse("payment", JSONObject().apply {
                        put("status", "success")
                        put("detail", JSONObject().apply {
                            put("transaction", response.transaction)
                            put("value", response.transactionData.value)
                            put("status", response.transactionData.status)
                            put("paymentType", response.transactionData.paymentType)
                            put("installments", response.transactionData.installments)
                            put("brand", response.transactionData.brand)
                            put("acquiring", response.transactionData.acquiring)
                            put("sellerName", response.transactionData.sellerName)
                            put("autoCode", response.transactionData.autoCode)
                            put("documentType", response.transactionData.documentType)
                            put("document", response.transactionData.document)
                            put("date", response.transactionData.date)
                            put("hour", response.transactionData.hour)
                            put("sellerReceipt", response.transactionData.sellerReceipt)
                            put("customerReceipt", response.transactionData.customerReceipt)
                            put("approvalMessage", response.transactionData.approvalMessage)
                            put("transactionId", response.transactionData.transactionId)
                            put("address", response.transactionData.address)
                            put("pan", response.transactionData.pan)
                            put("nsu", response.transactionData.nsu)
                            put("cv", response.transactionData.cv)
                            put("arqc", response.transactionData.arqc)
                            put("aid", response.transactionData.aid)
                            put("aidLabel", response.transactionData.aidLabel)
                        })
                    })

                    invokeMethodUIThread(responseSuccess)
                }

                override fun onFail(error: Throwable) {
                    val response = makeErrorResponse("payment", error.message)
                    invokeMethodUIThread(response)
                }

            })
            .messageCallback(object : Callback<MessageCallbackRequestField.MessageData>() {
                override fun onSuccess(response: MessageCallbackRequestField.MessageData) {
                    Log.d(tag, "messageCallback ${response.message}")
                    val responseMessage =
                        makeSuccessResponse("terminalMessage", JSONObject().apply {
                            put("message", response.message)
                            put("terminalMessageType", response.type.toString())
                        })
                    invokeMethodUIThread(responseMessage)
                }

                override fun onFail(error: Throwable) {
                    Log.d(tag, "messageCallback fail")
                    val response = makeErrorResponse("terminalMessage", error.message)
                    invokeMethodUIThread(response)
                }
            })
            .build()

        Zoop.post(paymentRequest)
    }

    private fun login() {
        val loginRequest = ZoopFoundationPlugin.createDashboardActivationRequestBuilder()
            .tokenCallback(object : Callback<DashboardTokenResponse>() {
                override fun onStart() {
                    val response = makeSuccessResponse("login", JSONObject().apply {
                        put("status", "requestToken")
                    })
                    invokeMethodUIThread(response)
                }

                override fun onFail(error: Throwable) {
                    Log.d(tag, "Falha ao requisitar token")
                    val response = makeErrorResponse("login", error.message)
                    invokeMethodUIThread(response)
                }

                override fun onSuccess(response: DashboardTokenResponse) {
                    Log.d(tag, "Apresentar token ao usuário: ${response.token}")
                    val responseToken = makeSuccessResponse("login", JSONObject().apply {
                        put("status", "waitingValidateToken")
                        put("token", response.token)
                    })
                    invokeMethodUIThread(responseToken)
                }
            })
            .confirmCallback(object : Callback<DashboardConfirmationResponse>() {
                override fun onFail(error: Throwable) {
                    Log.d(tag, "Apresentar erro na confirmação do token: ${error.message}")
                    val response = makeSuccessResponse("login", JSONObject().apply {
                        put("error", error.message.toString())
                    })
                    invokeMethodUIThread(response)
                }

                override fun onSuccess(response: DashboardConfirmationResponse) {
                    Log.d(tag, "Aqui, você recebe as credenciais do estabelecimento")
                    Log.d(tag, "MarketplaceId: ${response.credentials.marketplace}")
                    Log.d(tag, "SellerId: ${response.credentials.seller}")
                    Log.d(tag, "Terminal: ${response.credentials.terminal}")
                    Log.d(tag, "AccessKey: ${response.credentials.accessKey}")
                    Log.d(tag, "SellerName: ${response.owner.name}")

                    val responseCredentials = makeSuccessResponse("login", JSONObject().apply {
                        put("status", "logged")
                        put("marketplaceId", response.credentials.marketplace)
                        put("sellerId", response.credentials.seller)
                        put("sellerName", response.owner.name)
                        put("terminal", response.credentials.terminal)
                        put("accessKey", response.credentials.accessKey)
                    })
                    invokeMethodUIThread(responseCredentials)
                }

            })
            .themeCallback(object : Callback<DashboardThemeResponse>() {
                override fun onStart() {}

                override fun onFail(error: Throwable) {}

                override fun onSuccess(response: DashboardThemeResponse) {}

            }).build()

        Zoop.post(loginRequest)
    }
}
