# WCDB与Realm对比

###WCDB:

1.微信团队开发，基于sqilte，以微信app为使用案例，经过大量的需求案例验证，有相当丰富的使用场景，稳定可靠。

2.支持class,struct直接转表。添加枚举类型，和模型字段一一对应；每一个需要存储的字段，都需要添加到枚举中。

3.支持类型丰富。除int,string等基本类型外，也支持data,Array,Dictionary,json等常用类型。对于字段是class或struct的情况，只需要让该class或struct实现`ColumnJSONCodable`即可，该类型会转为json存储在字段中。

注意：字段为struct或class，一定要使用`ColumnJSONCodable`，否则程序会崩溃。

4.使用案例：

（1）字段映射案例

```swift

class User: TableCodable {
    var token:String = ""
    var shopInfo = Shop()    
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = User
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case token
        case shopInfo
    }
    
    struct Shop: ColumnJSONCodable {
        var shopName = ""
    }
}
```

（2）存储案例

```swift
class UserManager {
		static let main = UserManager()
		var user:User?
		
		// 存储用户信息到硬盘
    public func saveUserToDisk() {
        guard let user = user else { return }
        do {
            let dataBase = Database(withPath: dataBasePath)
            try dataBase.create(table: tablePath, of: User.self)
            try dataBase.insertOrReplace(objects: user, intoTable: tablePath)            
        } catch {
            print(error)
        }        
    }
    
    //从硬盘获取用户信息
    func getUserFromDisk() {
        do {
            let dataBase = Database(withPath: dataBasePath)
            let user: User? = try dataBase.getObject(fromTable: tablePath)
            self.user = user
        } catch {
            print(error)
        }
    }
  
  	//将内存和硬盘的用户信息清除
    func clear() {
        user = nil        
        do {
            let dataBase = Database(withPath: dataBasePath)
            try dataBase.delete(fromTable: tablePath)
        } catch (let error) {
            print(error)
        }
    }
}
```

5.常见问题：

（1）版本更新：app版本迭代会出现字段增减等一系列容易出现Bug的地方，wcdb处理如下：

- 对于数据库中没有的新增字段，直接调用getObject会抛出错误。需要在getObject之前，调用database.createTable将数据库的字段和模型重新绑定，新增的值会为NULL。如果需要为新增值设默认值，则需要在为该字段添加约束绑定

```swift
static var columnConstraintBindings: [User.CodingKeys : ColumnConstraintBinding]? {
    return [
    		// 主键绑定
        uid: ColumnConstraintBinding(isPrimary: true),
        // 默认值绑定
        isInstalled: ColumnConstraintBinding(defaultTo: "false")
    ]
}
```

- 对于新增字段是数组或者字典类型等非基础类型，应该将字段设为可选值

```swift
var shops: [Shop]? = nil
var names: [String]? = nil
```

- 对于模型中减少的字段，会被忽略，但依然会在保留在数据库中
- 对于需要重命名的字段，可以通过别名的方式重新映射。
- 当主键相同时，使用insert新增row会抛出错误；使用insertOrReplace则会替换掉原来的row

（2）对于模型嵌套，只需让子类型遵循`ColumnJSONCodable` 。

（3）注意数据库的存储位置，建议放在Documents里

（4）create(table:of:)的重要性：纵观上述字段映射、字段约束、索引和表约束等四个部分，都是通过调用` create(table:of:)` 接口使其生效的。 实际上，该接口会将 模型绑定的定义 与 表本身的结构 联系起来，并进行更新