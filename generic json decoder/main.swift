import Foundation

var data = [String: AnyObject]()
let fileURL = URL(fileURLWithPath: "/Users/user/Documents/ios/generics task/generic json decoder/data.json")
do {
    let d = try Data(contentsOf: fileURL)
    let jsonResult = try JSONSerialization.jsonObject(with: d, options: .mutableLeaves)

    if let jsonDict = jsonResult as? [String: AnyObject] {
        data = jsonDict
    }
} catch {
    print("Error: \(error)")
}
//print(data["payload"]!)


if let meta = data["meta"] as? [String: Any],
   let requestId = meta["requestId"] as? String {
    print("Request ID: \(requestId)")
}

if let payload = data["payload"] as? [String: Any?]{
    if let d = payload["data"] {
        print("data: ")
        print(d!)
    }
    else{
        print("error: ")
        print(payload["error"]! ?? "no result")
    }
}

