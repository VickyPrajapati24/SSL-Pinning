import Foundation
import Security

class NSURLSessionPinningDelegate: NSObject, URLSessionDelegate/*, URLSessionTaskDelegate*/ {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let serverTrust = challenge.protectionSpace.serverTrust
        let certificate =  SecTrustGetCertificateAtIndex(serverTrust!, 0)

        //set ssl polocies for domain name check
        let policies = NSMutableArray()
        policies.add(SecPolicyCreateSSL(true, challenge.protectionSpace.host as CFString))
        SecTrustSetPolicies(serverTrust!, policies)

        //evaluate server certifiacte
        var result:SecTrustResultType =  SecTrustResultType(rawValue: 0)!
        SecTrustEvaluate(serverTrust!, &result)
        let isServerTRusted:Bool =  (result == SecTrustResultType.unspecified || result == SecTrustResultType.proceed)

        //get Local and Remote certificate Data

        let remoteCertificateData:NSData =  SecCertificateCopyData(certificate!)
        let pathToCertificate = Bundle.main.path(forResource: "sni.cloudflaressl.com", ofType: "cer")
        let localCertificateData:NSData = NSData(contentsOfFile: pathToCertificate!)!

        //Compare certificates
        if(isServerTRusted && remoteCertificateData.isEqual(to: localCertificateData as Data)){
            let credential:URLCredential =  URLCredential(trust:serverTrust!)
            completionHandler(.useCredential,credential)
        }
        else{
            completionHandler(.cancelAuthenticationChallenge,nil)
        }
    }
    
//    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        let serverTrust = challenge.protectionSpace.serverTrust
//        let certificate =  SecTrustGetCertificateAtIndex(serverTrust!, 0)
//
//        //set ssl polocies for domain name check
//        let policies = NSMutableArray()
//        policies.add(SecPolicyCreateSSL(true, challenge.protectionSpace.host as CFString))
//        SecTrustSetPolicies(serverTrust!, policies)
//
//        //evaluate server certifiacte
//        var result:SecTrustResultType =  SecTrustResultType(rawValue: 0)!
//        SecTrustEvaluate(serverTrust!, &result)
//        let isServerTRusted:Bool =  (result == SecTrustResultType.unspecified || result == SecTrustResultType.proceed)
//
//        //get Local and Remote certificate Data
//
//        let remoteCertificateData:NSData =  SecCertificateCopyData(certificate!)
//        let pathToCertificate = Bundle.main.path(forResource: "sni.cloudflaressl.com", ofType: "cer")
//        let localCertificateData:NSData = NSData(contentsOfFile: pathToCertificate!)!
//
//        //Compare certificates
//        if(isServerTRusted && remoteCertificateData.isEqual(to: localCertificateData as Data)){
//            let credential:URLCredential =  URLCredential(trust:serverTrust!)
//            completionHandler(.useCredential,credential)
//        }
//        else{
//            completionHandler(.cancelAuthenticationChallenge,nil)
//        }
//    }
}
