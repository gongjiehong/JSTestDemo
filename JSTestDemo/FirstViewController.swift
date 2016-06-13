//
//  FirstViewController.swift
//  JSTestDemo
//
//  Created by 龚杰洪 on 16/6/13.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

import UIKit

func println(object: Any) {
    #if DEBUG
        Swift.print(object, terminator: "\n")
    #endif
}

class FirstViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet var testWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "UIWebView"
        
        let fileManager = NSFileManager.defaultManager()
        
        let documentsPath = NSString(string: fileManager.documentsPath)
        
        let webDirDocumentsPath = documentsPath.stringByAppendingPathComponent("HTML")
        
        let htmlFilePath = webDirDocumentsPath.stringByAppendingString("/Index.html")
        
        testWebView.loadRequest(NSURLRequest(URL: NSURL(fileURLWithPath: htmlFilePath)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UIWebViewDelegate
    
    func webViewDidStartLoad(webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {

    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let urlString = request.URL?.absoluteString {
            if urlString.rangeOfString("forclient/") != nil {
                if let textParamRange = urlString.rangeOfString("?textParam=") {
                    handleTextParam(urlString.substringFromIndex(textParamRange.endIndex))
                }
                else if let jsonParamRange = urlString.rangeOfString("?jsonParam=") {
                    handleJsonStringParam(urlString.substringFromIndex(jsonParamRange.endIndex))
                }
                else {
                    // 其他操作方式穷举
                }
                return false
            }
            return true
        }
        return false
    }

    // MARK: 处理参数
    
    func handleTextParam(param: String) {
        println(param)
    }
    
    func handleJsonStringParam(param: String) {
        if let urlDecodeString = param.stringByRemovingPercentEncoding {
            do {
                let dicParam = try NSJSONSerialization.JSONObjectWithData(urlDecodeString.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.AllowFragments) as! [String: AnyObject]
                println(dicParam)
                
                guard let action = dicParam["action"] as? String else {
                    return
                }
                switch action {
                case "show_info":
                    showInfoWithParam(dicParam)
                    break
                case "get_token":
                    sendTokenToHtml(dicParam)
                    break
                default:
                    break
                }
            }
            catch {
                
            }
        }
    }
    
    func showInfoWithParam(param: [String: AnyObject]) {
        var tempParam = param
        tempParam.removeValueForKey("action")
        
        var messageString = ""
        
        for (key, value) in tempParam {
            messageString += "\(key) : "
            messageString += "\(value) \n"
        }
        
        let alert = UIAlertController(title: "ShowInfo", message: messageString, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) in
            
        }
        
        alert.addAction(okAction)
        
        self.presentViewController(alert, animated: true) { 
            
        }
    }
    
    func sendTokenToHtml(param: [String: AnyObject]) {
        var tempParam = param
        tempParam.removeValueForKey("action")
        do {
            let paramData = try NSJSONSerialization.dataWithJSONObject(param, options: NSJSONWritingOptions.PrettyPrinted)
            let paramString = String(data: paramData, encoding: NSUTF8StringEncoding)
            let md5FromJs = testWebView.stringByEvaluatingJavaScriptFromString("md5(\(paramString!))")
            if let result = testWebView.stringByEvaluatingJavaScriptFromString("sendToken('\(md5FromJs!)')") {
                print(result.uppercaseString)
            }
            
        }
        catch {
            
        }
        
    }
}

