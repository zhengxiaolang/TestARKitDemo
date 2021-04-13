//
//  MTOcclusionAdapter.swift
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/12.
//

import UIKit

class MTOcclusionAdapter: ARBaseAdapter {
    override func buildConfig() {
        
    }
    
    override func initData() {
        self.scnView?.delegate = self;
    }
    
    
}

extension MTOcclusionAdapter:ARSCNViewDelegate,ARSessionDelegate{
    
}
