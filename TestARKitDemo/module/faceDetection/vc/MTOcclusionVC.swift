//
//  MTOcclusionVC.swift
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/9.
//

import UIKit
import RealityKit


@available(iOS 13.0, *)
class MTOcclusionVC: MTARBaseVC,ARSessionDelegate {

    var arView:ARView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func initData() {
        super.initData()
        
        if #available(iOS 14.0, *) {
            initARView()
            config = initConfig()
        } else {
            // Fallback on earlier versions
        }
    }
    override func createView() {
//        super.createView()
        
        view.addSubview(arView)
        view.addSubview(backBtn)
    }
    
    override func actionAfterViewDidLoad() {
        addGesture()
    }
    
    @available(iOS 14.0, *)
    func initARView(){
        arView = ARView.init(frame: view.bounds)
        arView.environment.sceneUnderstanding.options = []
        arView.environment.sceneUnderstanding.options.insert(.occlusion)
        arView.environment.sceneUnderstanding.options.insert(.physics)
        arView.renderOptions = [.disablePersonOcclusion, .disableDepthOfField, .disableMotionBlur]
        arView.automaticallyConfigureSession = false
        arView.session = self.session
    }
    
    @available(iOS 14.0, *)
    func initConfig() -> ARWorldTrackingConfiguration {
        let config = ARWorldTrackingConfiguration()
        config.sceneReconstruction = .meshWithClassification
        config.environmentTexturing = .automatic
        config.planeDetection = [.horizontal]
        if type(of: config).supportsFrameSemantics(.sceneDepth) {
            config.frameSemantics = .sceneDepth
        }

        return config
    }
    
    func addGesture() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        arView.addGestureRecognizer(tapRecognizer)
    }
    
    func getZForward(transform: simd_float4x4) -> SIMD3<Float> {
        return SIMD3<Float>(transform.columns.2.x, transform.columns.2.y, transform.columns.2.z)
    }

    @objc
    func handleTap(_ sender: UITapGestureRecognizer) {
        func createBall(radius: Float, color: UIColor, linearVelocity: SIMD3<Float>) -> ModelEntity {
            let sphere = ModelEntity(mesh: .generateSphere(radius: radius), materials: [SimpleMaterial(color: color, isMetallic: true)])

            sphere.generateCollisionShapes(recursive: false)
            sphere.physicsBody = .init()
            sphere.physicsBody?.mode = .dynamic//是否静止
            sphere.physicsMotion =  PhysicsMotionComponent(linearVelocity: linearVelocity,
                                                           angularVelocity: [0, 0, 0])

            return sphere
        }
        
        
        /// 计算球的位置
        func calcBallPosition(cameraTransform: simd_float4x4) -> simd_float4x4 {
           var translation = matrix_identity_float4x4
            
           let num = arc4random() % 10
//            if num > 5 {
//                translation.columns.3.z = -0.3
//            }else{
//                translation.columns.3.z = -0.2
//            }
           
            translation.columns.3.z = -0.1
            translation.columns.3.y = 0.01
           return simd_mul(cameraTransform, translation)
        }
        
        //坠落方向
        func calcBallDirection(cameraTransform: simd_float4x4) -> SIMD3<Float> {
            var moveTrans = matrix_identity_float4x4
            moveTrans.columns.3.z = -0.1

            var rotateXTrans = matrix_identity_float4x4
            let rad = Float.pi/4
            rotateXTrans.columns.1.y = cos(rad)
            rotateXTrans.columns.1.z = sin(rad)
            rotateXTrans.columns.2.y = -sin(rad)
            rotateXTrans.columns.2.z = cos(rad)

            let transform = cameraTransform * moveTrans * rotateXTrans

            return -getZForward(transform: transform)
        }
        
        func addObjectOnTappedPoint() {
            guard let currentFrame = arView.session.currentFrame else {return}
            let cameraTransform = currentFrame.camera.transform

            let ballPosition = calcBallPosition(cameraTransform: cameraTransform)
            let ballVelocity = calcBallDirection(cameraTransform: cameraTransform)

            let resultAnchor = AnchorEntity(world: ballPosition)
            resultAnchor.name = "ball"
            let ball = createBall(radius: 0.02, color: .systemPink, linearVelocity: ballVelocity)

            resultAnchor.addChild(ball)
            arView.scene.addAnchor(resultAnchor)
            print("添加 球 成功")
        }
        addObjectOnTappedPoint()
    }
}
