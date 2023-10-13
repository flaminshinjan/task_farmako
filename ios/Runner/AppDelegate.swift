import UIKit
import Flutter
import SwiftUI

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let batteryChannel = FlutterMethodChannel(name: "battery", binaryMessenger: controller.binaryMessenger)
        
        batteryChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            // Handle battery messages later if needed
        })
        
        let registrar = self.registrar(forPlugin: "BatteryView")
        let batteryViewFactory = BatteryViewFactory(registrar: registrar!)
        registrar?.register(batteryViewFactory, withId: "BatteryView")
        
        GeneratedPluginRegistrant.register(with: self)
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
        ZStack {
            Image("horse_image")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Button("Fetch Battery") {
                    batteryLevel = getBatteryPercentage()
                }
                .padding()
                
                Text("Battery Level: \(batteryLevel, specifier: "%.2f")%")
                    .padding()
            }
        }
    }
    
    func getBatteryPercentage() -> Float {
        UIDevice.current.isBatteryMonitoringEnabled = true
        return UIDevice.current.batteryLevel * 100
    }
}
