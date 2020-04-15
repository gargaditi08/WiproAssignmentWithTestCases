//
//  Reachability.swift
//  TelstraAssignment
//
//  Created by Aditi Garg on 15/04/20.
//  Copyright © 2020 Aditi Garg. All rights reserved.
//

import Foundation
import SystemConfiguration

let ReachabilityDidChangeNotification = "ReachabilityDidChangeNotification"
enum ReachabilityStatusEnum {
case notReachable
case reachableViaWifi
case reachableViaWWAN
}
private var networkReachability : SCNetworkReachability?
private var notifying : Bool = false

class Reachability: NSObject {
    
init?(hostName : String) {
    networkReachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, (hostName as NSString).utf8String!)
       super.init()
    if networkReachability == nil {
       return nil
    }
   }
    
    init?(hostAddress : sockaddr_in) {
        var address = hostAddress
        
        guard  let defaultRouteReachablity = withUnsafePointer(to: &address,  {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, $0)
            }
        }) else {
            return nil
        }
        
        networkReachability = defaultRouteReachablity
        
        super.init()
        if networkReachability == nil {
            return nil
        }
    }


static func networkReachabilityForInternetConnection() -> Reachability? {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    return Reachability(hostAddress: zeroAddress)
}
    
    static func networkReachabilityForLocalWiFi() -> Reachability? {
        var localWifiAddress = sockaddr_in()
        localWifiAddress.sin_len = UInt8(MemoryLayout.size(ofValue: localWifiAddress))
        localWifiAddress.sin_family = sa_family_t(AF_INET)
        localWifiAddress.sin_addr.s_addr = 0xA9FE0000
        
        return Reachability(hostAddress: localWifiAddress)
    }
    
    
    func  startNotifier() -> Bool {
        
        guard notifying == false else {
            return false
    }
        var context = SCNetworkReachabilityContext()
        context.info = UnsafeMutableRawPointer (Unmanaged.passUnretained(self).toOpaque())
        
        guard let reachability = networkReachability, SCNetworkReachabilitySetCallback(reachability, { (target: SCNetworkReachability, flags : SCNetworkReachabilityFlags, info: UnsafeMutableRawPointer?) in
            if let currentInfo = info {
                let infoObject = Unmanaged<AnyObject>.fromOpaque(currentInfo).takeUnretainedValue()
                if infoObject is Reachability {
                    let networkReachability = infoObject as! Reachability
                    NotificationCenter.default.post(name: Notification.Name(rawValue: ReachabilityDidChangeNotification), object: networkReachability)
                    
                }
            }
            
            
        }, &context) == true else { return false }
        
        guard SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue) == true else { return false }
        
        notifying = true
        return notifying
    }
    
//    func  stopNotifier() {
//        if let reachability = networkReachability,notifying == true {
//            SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode as! CFString)
//            notifying = false
//        }
//    }
//
//    deinit {
//        stopNotifier()
//    }
    
    private var flags : SCNetworkReachabilityFlags {
        var flags = SCNetworkReachabilityFlags (rawValue: 0)
        if let reachability = networkReachability, withUnsafeMutablePointer(to: &flags, {SCNetworkReachabilityGetFlags(reachability, UnsafeMutablePointer($0))  }) == true  {
            return flags
        }
        else{
            return []
        }
    }
    
    var currentReachabilityStatus : ReachabilityStatusEnum {
        
        if flags.contains(.reachable) == false {
            //The host target is not reachable
            return.notReachable
        }
        else if flags.contains(.isWWAN) == true {
           //WWAN connection are OK if the calling application is using the CFNetwork APIs.
                  return.reachableViaWWAN
              }
        
       else if flags.contains(.connectionRequired) == false {
                  //If the target host is reachable and no connection is required then will assume that you are on Wifi
                  return.reachableViaWifi
              }
        
        else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
                  //The connection is on demand (or on - Traffic)if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
                  return.reachableViaWifi
              }
        else {
            return .notReachable
        }
    }
    
    var isReachable : Bool {
    switch currentReachabilityStatus {
    case .notReachable:
    return false
    case .reachableViaWifi, .reachableViaWWAN:
        return true
    }
    }
    
    
}
