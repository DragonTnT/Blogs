# iOS中的安全与加密

Charles是大家所熟悉的抓包工具，如果网络请求未经过双向认证，那么我们可以通过Charles拿到请求的参数和返回，具体的操作方法请看[这里](https://juejin.im/post/5a30a52a6fb9a0451d4175ed)。它的原理简单的概括为Charles伪装为服务器与客户端通信。可以选择将传输的所有数据都进行加密，但如果数据量较大时，加解密会影响通信的时间。这里介绍两种防止抓包的方法：

- HTTPS双向认证
- 禁用代理

---

###HTTPS双向认证：

**双向认证**要做的工作就是在服务器与客户端之间**相互验证**，避免数据被Charles这类的中间人截取。

#### 一、准备工作：

#####1.服务端会向我们提供.pem证书和.key密钥

##### 2.将.pem导为.cer文件

```openss
openssl x509 -inform pem -in  youchelai.pem -outform der -out youchelai.cer
```

#####3.将.pem和.key导为p12文件(注意p12需要.pem和.key一起导出)

```
openssl pkcs12 -export -in youchelai.pem -inkey youchelai.key -out youchelai.p12
```

注意导出时需要设置密码，在代码中需要将密码带入。

#### 二、iOS客户端代码

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
      
      //将p12文件发送到服务端认证（p12由证书和公钥生成）
      private func sendClientP12() -> SessionChallenge {
          var identityAndTrust:IdentityAndTrust!
          var securityError:OSStatus = errSecSuccess
          
          let path: String = Bundle.main.path(forResource: "chejinjia", ofType: "p12") ?? ""
          let PKCS12Data = NSData(contentsOfFile:path)!
          let key : NSString = kSecImportExportPassphrase as NSString
          let options : NSDictionary = [key : "你的P12文件的密码"] //P12导出时的密码
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

#### 注意：

如果服务端的证书过期需要更换，那么app里的证书也需要更换，存在的问题就是app需要重新打包上传，如果用户没有更新app，则无法访问服务器；因此使用双向认证要提前规划，例如购买使用年限长的证书，或从服务端动态下载证书。也可以使用公钥验证，即从服务端获取的证书里取到公钥，和本地证书里的公钥对比，（当证书使用自定义的CSR文件时，公钥会保持不变）。

---

### 禁用代理：

Charles一般会使用电脑作为手机的代理和服务端进行通信，因此如果在app内检测到代理，则我们可以选禁止网络请求。

```swift
public class func isUsedProxy() -> Bool {
    guard let proxy = CFNetworkCopySystemProxySettings()?.takeUnretainedValue() else { 			return false }
    guard let dict = proxy as? [String: Any] else { return false }
    guard let HTTPProxy = dict["HTTPProxy"] as? String else { return false }
    //如果使用了代理，则HTTPProxy不为空，值为代理的ip地址
    return !HTTPProxy.isEmpty
}
```

我们可以将该方法封装在网络请求的基类里，每次请求前判断网络是否使用代理，如果使用，则禁止请求。

当然测试人员进行测试时，可能会使用代理，因此我们应该把该判断放入Release模式，仅在生产环境下判断。

```swift
#if Release
if !ProxyCheck.isUsedProxy() {
		// do network
} else {
	  HUD.flash(.labeledError(title: nil, subtitle: "代理禁止访问"), delay: 0.5)
}
#endif
```

当然这种方法也会有一些不方便的地方，例如有时候手机使用代理翻墙，那么此时访问禁用代理的app，就不能进行请求了。



###二。AES

上面的处理并不完善，因为请求的参数实际上还是明文。比较敏感的参数例如密码，我们还应该将它再次加密。

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