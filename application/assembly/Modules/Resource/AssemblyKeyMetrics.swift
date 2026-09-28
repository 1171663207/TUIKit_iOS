//
//  AssemblyKeyMetrics.swift
//  AppAssembly
//

import Foundation
import ImSDK_Plus

// MARK: - KeyMetrics

enum KeyMetrics {
    static func reportAtomicMetrics(platform: Int) {
        let param: [String: Any] = ["UIComponentType": platform]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: param),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return
        }
        V2TIMManager.sharedInstance().callExperimentalAPI(
            api: "reportTUIFeatureUsage",
            param: jsonString as NSObject
        ) { _ in
        } fail: { code, desc in
            debugPrint("[AppAssembly] reportAtomicMetrics failed: \(code) \(desc ?? "")")
        }
    }
}

// MARK: - Constants

enum Constants {
    enum DataReport {
        static let kDataReportDemoLoginSuccess = 1_302
        static let kDataReportDemoClickCall = 1_303
        static let kDataReportDemoClickLive = 1_119
        static let kDataReportDemoClickRoom = 1_205
    }
}
