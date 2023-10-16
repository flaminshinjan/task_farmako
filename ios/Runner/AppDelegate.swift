import UIKit
import Flutter
import SwiftUI

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        guard let controller = window?.rootViewController as? FlutterViewController else {
            fatalError("RootViewController is not type FlutterViewController")
        }
        
        let batteryChannel = FlutterMethodChannel(name: "battery", binaryMessenger: controller.binaryMessenger)
        batteryChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "getBatteryLevel" {
                let batteryManager = BatteryPlugin()
                let level = batteryManager.getBatteryLevel()
                result(level * 100)
            } else {
                result(FlutterMethodNotImplemented)
            }
        })
        
        let registrar = self.registrar(forPlugin: "BatteryView")
        let batteryViewFactory = BatteryViewFactory(registrar: registrar!)
        registrar?.register(batteryViewFactory, withId: "BatteryView")
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

class BatteryViewFactory: NSObject, FlutterPlatformViewFactory {
    let registrar: FlutterPluginRegistrar

    init(registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
        super.init()
    }

    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return BatteryPlatformView(frame: frame, viewId: viewId, args: args, registrar: registrar)
    }
}

class BatteryPlatformView: NSObject, FlutterPlatformView {
    let frame: CGRect
    let viewId: Int64
    let args: Any?
    let registrar: FlutterPluginRegistrar

    init(frame: CGRect, viewId: Int64, args: Any?, registrar: FlutterPluginRegistrar) {
        self.frame = frame
        self.viewId = viewId
        self.args = args
        self.registrar = registrar
        super.init()
    }

    func view() -> UIView {
        let controller = UIHostingController(rootView: BatteryView())
        return controller.view
    }
}

struct BatteryView: View {
    @State private var batteryLevel: Float = 0.0
    
    var body: some View {
        ZStack{
            Image("horse_image")
                .resizable()
                .scaledToFit()
            VStack {
                Button(action: {
                    let batteryManager = BatteryPlugin()
                    self.batteryLevel = batteryManager.getBatteryLevel() * 100 
                    let channel = FlutterMethodChannel(name: "battery", binaryMessenger: AppDelegate.shared.controller!.binaryMessenger)
                    channel.invokeMethod("batteryPercentage", arguments: self.batteryLevel)
                }) {
                    Text("Fetch Battery")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue.opacity(0.7))
                        .cornerRadius(10)
                }
                .padding()
            }
        }
    }
}

extension AppDelegate {
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    var controller: FlutterViewController? {
        return window?.rootViewController as? FlutterViewController
    }
}
