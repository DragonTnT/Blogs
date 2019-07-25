# iOS中的安全与加密

---

###一。HTTPS双向认证

Charles是大家所熟悉的抓包工具，如果网络请求未经过双向认证，那么我们可以通过Charles拿到请求的参数和返回，具体的操作方法请看[这里](https://juejin.im/post/5a30a52a6fb9a0451d4175ed)。它的原理简单的概括为Charles伪装为服务器与客户端通信。那么**双向认证**要做的工作就是在服务器与客户端之间**相互验证**，避免数据被Charles这类的中间人截取。



#### 准备工作

#####1.服务端会向我们提供.pem证书和.key密钥

##### 2.将.pem导为.cer文件

```openss
openssl x509 -inform der -in certificate.cer -out certificate.pem
```

#####3.将.pem和.key导为p12文件

```
openssl pkcs12 -export -in certificate.pem -inkey chejinjia.key -out certificate.p12
```

##### 4.这里的设置是以swift语言，并且Alamofire请求为基础的，注意将代码里的.cer和p12换成真实的名字



```swift
import Alamofire

class UtimesNetWorkConfig {
    static let shared = UtimesNetWorkConfig()
    
    //https认证
    func HTTPSAuthentication() {
        SessionManager.default.delegate.sessionDidReceiveChallenge = { session, challenge in
 						//验证服务端                                                                      
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                return self.verifyServer(challenge: challenge)
            }
            //验证客户端
            else if challenge.protectionSpace.authenticationMethod ==   NSURLAuthenticationMethodClientCertificate {
                return self.sendClientP12()
            }
            return (.cancelAuthenticationChallenge, nil)
        }
    }
}

```

- `sessionDidReceiveChallenge`是对`urlSession(_:didReceive:completionHandler:)`的重写，也就是发生网络请求时的回调，我们在这里面设置双向认证

  ```swift
  extension UtimesNetWorkConfig {
  		//验证服务端发来的证书
      private func verifyServer(challenge: URLAuthenticationChallenge) -> SessionChallenge{
          let serverTrust:SecTrust = challenge.protectionSpace.serverTrust!
          let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0)!
          let remoteCertificateData = CFBridgingRetain(SecCertificateCopyData(certificate))!
          let cerPath = Bundle.main.path(forResource: "你的证书文件名", ofType: "cer")!
          let cerUrl = URL(fileURLWithPath:cerPath)
          if let localCertificateData = try? Data(contentsOf: cerUrl), remoteCertificateData.isEqual(localCertificateData) {
              let credential = URLCredential(trust: serverTrust)
              challenge.sender?.use(credential, for: challenge)
              return (URLSession.AuthChallengeDisposition.useCredential,
                      URLCredential(trust: challenge.protectionSpace.serverTrust!))
          } else {
              return (.cancelAuthenticationChallenge, nil)
          }
      }
      
      //将本地证书发送到服务端认证
      private func sendClientP12() -> SessionChallenge {
          var identityAndTrust:IdentityAndTrust!
          var securityError:OSStatus = errSecSuccess
          
          let path: String = Bundle.main.path(forResource: "chejinjia", ofType: "p12") ?? ""
          let PKCS12Data = NSData(contentsOfFile:path)!
          let key : NSString = kSecImportExportPassphrase as NSString
          let options : NSDictionary = [key : "你的P12文件的密码"] //客户端证书密码
          var items : CFArray?
          
          securityError = SecPKCS12Import(PKCS12Data, options, &items)
          
          if securityError == errSecSuccess {
              //            let certItems:CFArray = items as! CFArray;
              let certItemsArray:Array = items! as Array
              let dict:AnyObject? = certItemsArray.first;
              if let certEntry:Dictionary = dict as? Dictionary<String, AnyObject> {
                  // grab the identity
                  let identityPointer:AnyObject? = certEntry["identity"];
                  let secIdentityRef:SecIdentity = identityPointer as! SecIdentity
                  // grab the trust
                  let trustPointer:AnyObject? = certEntry["trust"]
                  let trustRef:SecTrust = trustPointer as! SecTrust
                  // grab the cert
                  let chainPointer:AnyObject? = certEntry["chain"]
                  identityAndTrust = IdentityAndTrust(identityRef: secIdentityRef,
                                                      trust: trustRef, certArray:  chainPointer!)
              }
          }
          
          let urlCredential:URLCredential = URLCredential(
              identity: identityAndTrust.identityRef,
              certificates: identityAndTrust.certArray as? [AnyObject],
              persistence: URLCredential.Persistence.forSession);
          
          return (.useCredential, urlCredential);
      }
  }
  ```

  

以上两个方法可以看出，双向认证无非是将服务端的证书和客户端的证书对比，看是否是同一本证书。是，则网络请求成功，不是的话，网络请求就会被取消。

由此，Charles一类的抓包工具已经无法再抓取到网络请求了。

---

###二。AES

虽然用了HTTPS双向认证，可我们的安全系数还是不够高。因为请求的参数实际上还是明文。比较敏感的参数例如密码，我们还应该将它再次加密。

这里介绍一下如果使用第三方库`CryptoSwift`进行AES加密

#### 准备工作：

##### 1.安装[CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift)

##### 2.和服务器约定好AES的加密模式及参数(这里使用CBC模式)

```swift
let key = Array("ed3f91d05bbd77a5aea5c82c07f11a7b".utf8)
let iv = Array("ed3f91d05bbd77a5".utf8)
let input = Array("wodemima".utf8)
do {
    let encrypt: Array<UInt8> = try AES(key: key, blockMode: CBC(iv: iv),
padding: .pkcs5).encrypt(input)
    let decrypt = try AES(key: key, blockMode: CBC(iv: iv),
padding: .pkcs5).decrypt(encrypt)
    if let string = String(bytes: decrypt, encoding: .utf8) {
        print(string)
    }
} catch let error {
    print(error)
}
```

- **key**是和服务端约定好的密钥
- **iv**是偏移量，这里取Key的前16位，必须和服务器统一
- **input**是用来测试的输入
- 代码里**encrypt**和**decrypt**是加密和解密操作

#####3.CryptoSwift还包含了md5,sha等很多的加解密方法，功能很完善，可根据实际需要选取使用。

---

###三。MD5

```swift
import CommonCrypto
extension String {
    func MD5() -> String {
        let messageData = self.data(using:.utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        
        return digestData.hexString()
    }
}
extension Data {
    func hexString() -> String {
        return self.reduce("") { string, byte in
            string + String(format: "%02X", byte)
        }
    }
}
```

系统库`CommonCrypto`为我们实现了MD5加密,这里我们通过extension为string添加一个加密的调用。

值的一提的是，直接对敏感文本MD5的操作已经不是那么安全了，因为可以通过反解来暴力解密。那么比较通用的方式是对MD5加盐。

加盐的意思就是对敏感文本添加一段文本，再进行MD5。添加的这段文本越复杂越好。

例如:

```swift
let input = "password"
let inputSalty = "password" + "asdfghjklpoiuytrewqzxcvbnm"
print(inputSalty.MD5())
```

当然盐的值如果是固定的，也有一定风险，如果盐被泄漏，那么MD5的安全系数就会降低，因此可以使用时间戳或随机数作为盐。或者是MD5后截取部分再进行MD5。

这里注意一点的是。由于MD5是不可逆的，所以当传给服务器的参数需要解密时，不应该用MD5，而应该使用AES这一类的可逆加密方式。