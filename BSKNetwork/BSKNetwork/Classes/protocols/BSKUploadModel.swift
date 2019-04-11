//
//  LGUploadModel.swift
//  LinkGame
//
//  Created by xingcheng on 2018/7/24.
//  Copyright © 2018年 ChaungMiKeJi. All rights reserved.
//

import UIKit

public struct BSKUploadModel: Codable {
   public var region:String
   public var app_id:String
   public var folder:String
   public var bucket_name:String
   public var secret_id:String
   public var sign:String
   public var file_name:[String]
}
