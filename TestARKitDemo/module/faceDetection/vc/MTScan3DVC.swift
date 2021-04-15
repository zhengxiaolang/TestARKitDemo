//
//  MTScan3DVC.swift
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/13.
//

import UIKit
import RealityKit

@available(iOS 14.0, *)
class MTScan3DVC: MTARBaseVC , ARSessionDelegate{

    var arView:ARView!
    
    var exportBtn:UIButton{
        let btn = UIButton.init(frame: CGRect.init(x: 80, y: 44, width: 60, height: 40))
        btn.setTitle("导出", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.addTarget(self, action: #selector(exportAction), for: .touchUpInside)
        return btn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func createView() {
        view.addSubview(arView)
        view.addSubview(backBtn)
        view.addSubview(exportBtn)
    }
    
    
    override func initData() {
        initView()
        initConfig()
    }
    
    override func actionAfterViewDidLoad() {
        #if targetEnvironment(simulator)
        #else
        arView.session.run(config)
        #endif
    }
    
    func initView(){
        arView = ARView.init(frame: view.bounds)
        #if targetEnvironment(simulator)
        #else
        arView.environment.sceneUnderstanding.options = []
        arView.environment.sceneUnderstanding.options.insert(.occlusion)
        arView.environment.sceneUnderstanding.options.insert(.physics)
        arView.renderOptions = [.disablePersonOcclusion, .disableDepthOfField, .disableMotionBlur]
        arView.automaticallyConfigureSession = false
        
        arView.debugOptions.insert(.showSceneUnderstanding)
        
        arView.session = session
        #endif
    }
    
    func initConfig() {
        let configuation = ARWorldTrackingConfiguration()
        configuation.environmentTexturing = .automatic
        configuation.sceneReconstruction = .mesh
        
        if type(of: configuation).supportsFrameSemantics(.sceneDepth) {
            configuation.frameSemantics = .sceneDepth
        }
        
        config = configuation
    }
    
// Mark -  导出按钮事件
    @objc
    func exportAction() {
        #if targetEnvironment(simulator)
        #else
        guard let camera = arView.session.currentFrame?.camera else {return}

        func convertToAsset(meshAnchors: [ARMeshAnchor]) -> MDLAsset? {
            guard let device = MTLCreateSystemDefaultDevice() else {return nil}

            let asset = MDLAsset()

            for anchor in meshAnchors {
                let mdlMesh = anchor.geometry.toMDLMesh(device: device, camera: camera, modelMatrix: anchor.transform)
                asset.add(mdlMesh)
            }
            
            return asset
        }
        
        func export(asset: MDLAsset) throws -> URL {
            let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let url = directory.appendingPathComponent("test_scaned.obj")

            try asset.export(to: url)

            return url
        }
        
        //通过 ariDrop 或者 第三方软件 进行分享
        func share(url: URL) {
            let vc = UIActivityViewController(activityItems: [url],applicationActivities: nil)
//            vc.popoverPresentationController?.sourceView = sender
            self.present(vc, animated: true, completion: nil)
        }
        if let meshAnchors = arView.session.currentFrame?.anchors.compactMap({ $0 as? ARMeshAnchor }),
           let asset = convertToAsset(meshAnchors: meshAnchors) {
            do {
                let url = try export(asset: asset)
                share(url: url)
            } catch {
                print("导出报错")
            }
        }
        #endif
    }
}
