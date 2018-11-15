//
//  Constant.swift
//  subway
//
//  Created by Jim Chuang on 2018/10/8.
//  Copyright © 2018年 nhr. All rights reserved.
//

import Foundation

class MyHttp{
    static let share = MyHttp()

    private let PREF_KEY_SAVE_URL = "pref_key_save_url"
    var urlSelectStr = ""

    func getURL() -> String?{
        let dic = UserDefaults.standard.dictionary(forKey: PREF_KEY_SAVE_URL) as! [String:String]
        if let url = dic[urlSelectStr]{
            return url
        }else{
            return nil
        }
    }

    func addUrl(name:String,url:String){
        if name == "" || url == ""{
            return
        }
        var dic = Dictionary<String,String>()
        if var saveDic = UserDefaults.standard.dictionary(forKey: PREF_KEY_SAVE_URL) as? [String : String]{
            saveDic[name] = url
            dic = saveDic
        }else{
            dic[name] = url
        }
        UserDefaults.standard.set(dic, forKey: PREF_KEY_SAVE_URL)
    }

    func getUrlListKey() -> Array<String>{
        var result = Array<String>()
        if var urlDic = UserDefaults.standard.dictionary(forKey: PREF_KEY_SAVE_URL) as? [String : String]{
            urlDic = urlDic.filter{$0.key != ""}
            urlDic = urlDic.filter{$0.value != ""}
            for key in urlDic{
                result.append(key.key)
            }
        }
        return result
    }

    func delDicKey(key:String){
        if var urlDic = UserDefaults.standard.dictionary(forKey: PREF_KEY_SAVE_URL) as? [String : String]{
            urlDic = urlDic.filter{$0.key != key}
            UserDefaults.standard.set(urlDic, forKey: PREF_KEY_SAVE_URL)
        }
    }
}



