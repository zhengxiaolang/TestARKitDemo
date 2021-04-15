//
//  MTOcclusionVC.swift
//  TestARKitDemo
//
//  Created by zhengxiaolang on 2021/4/9.
//

import UIKit
import RealityKit
import SpriteKit

@available(iOS 14.0, *)
class MTOcclusionVC: MTARBaseVC,ARSessionDelegate {

    var arView:ARView!
    
    var changeModeBtn:UIButton{
        let btn = UIButton.init(frame: CGRect.init(x: 80, y: 44, width: 120, height: 40))
        btn.setTitle("静止中", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.addTarget(self, action: #selector(changePhysic(_:)), for: .touchUpInside)
        return btn
    }
    
    var isBallStatic = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func initData() {
        super.initData()
        
        initView()
        initConfig()
    }
    
    override func createView() {
        
        view.addSubview(arView)
        view.addSubview(backBtn)
        view.addSubview(changeModeBtn)
    }
    
    override func actionAfterViewDidLoad() {
        addGesture()
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
        arView.session = self.session
        
        #endif
    }
    
    func initConfig() {
        let config = ARWorldTrackingConfiguration()
        config.sceneReconstruction = .meshWithClassification
        config.environmentTexturing = .automatic
        config.planeDetection = [.horizontal]
        if type(of: config).supportsFrameSemantics(.sceneDepth) {
            config.frameSemantics = .sceneDepth
        }

        self.config = config
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
            
            var obj = MeshResource.generateBox(size: radius)
            
            if getRamdomValue() {
                obj = MeshResource.generateBox(size: radius)
            }else{
                obj = MeshResource.generateSphere(radius: radius)
            }
            
            let sphere = ModelEntity(mesh: obj, materials: [SimpleMaterial(color: color, isMetallic: true)])

            sphere.generateCollisionShapes(recursive: false)
            sphere.physicsBody = .init()
            
            if isBallStatic {
                sphere.physicsBody?.mode = .static//是否静止
            }else{
                sphere.physicsBody?.mode = .dynamic//是否静止
            }
            
            sphere.physicsMotion =  PhysicsMotionComponent(linearVelocity: linearVelocity,
                                                           angularVelocity: [0, 0, 0])

            return sphere
        }
        
        
        func createObjWithRandom(radius:Float) -> MeshResource{
            let num = arc4random() % 3
            var resource = MeshResource.generateBox(size: radius)
            
            switch num {
            case 0:
                resource = MeshResource.generatePlane(width: radius, depth: radius, cornerRadius: radius)
                break
            case 1:
                resource = MeshResource.generateSphere(radius: 3)
                break
            case 2:
                resource = MeshResource.generateText("飞机")
                break
            case 3:
                resource = MeshResource.generatePlane(width: radius, depth: radius, cornerRadius: radius)
                break
            default:
                break
            }
            return resource
        }
        
        /// 计算球的位置
        func calcBallPosition(cameraTransform: simd_float4x4) -> simd_float4x4 {
           var translation = matrix_identity_float4x4
            
            translation.columns.3.z = -0.1
//            translation.columns.3.y = 0.01s
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
            #if targetEnvironment(simulator)
            #else
            
            guard let currentFrame = arView.session.currentFrame else {return}
            let cameraTransform = currentFrame.camera.transform

            let ballPosition = calcBallPosition(cameraTransform: cameraTransform)
            let ballVelocity = calcBallDirection(cameraTransform: cameraTransform)

            let resultAnchor = AnchorEntity(world: ballPosition)
            resultAnchor.name = "ball"
            
            var objColor = UIColor.systemPink
            if getRamdomValue() {
                objColor = UIColor.systemBlue
            }
            
            
            let objRadius:Float = Float(arc4random() % 2)/100 + 0.01
            print("球大小：\(objRadius)")
            let ball = createBall(radius: objRadius, color: objColor, linearVelocity: ballVelocity)

            resultAnchor.addChild(ball)
            arView.scene.addAnchor(resultAnchor)
            #endif
            print("添加 球 成功")
        }
        addObjectOnTappedPoint()
    }
    
    @objc
    func changePhysic(_ btn:UIButton) {
        
        isBallStatic = !isBallStatic
        
        if isBallStatic {
            btn.setTitle("静止中", for: .normal)
        }else{
            btn.setTitle("运动中", for: .normal)
        }
    }
    
    func getRamdomValue() -> Bool {
        let num = arc4random() % 10
        
        return num > 5
    }
}
