//
//  ViewController.swift
//  ARDicee
//
//  Created by user161182 on 2/1/20.
//  Copyright © 2020 user161182. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        
        // Create a new scene
        // Pega o modelo 3D do aviao que o XCode nos deu de brinde e cria um elemento AR, que e chamado de scene.
        //let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Insere o scene na ARView.
        //sceneView.scene = scene
   
//MARK: - Criando um cubo vermelho
//        // Aqui estamos criando um prisma solido, um cubo. No caso ele vai ter 0.1 metro em cada dimensao e bordas arredondadas de 0.01. Esse metodo vem do SceneKit
//        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
//
//        //Para estilizar um SceneBox, temos que criar "materials". Vamos criar um agora
//        let material = SCNMaterial()
//        material.diffuse.contents = UIColor.red
//        // Depois de criar o material, inserimos no SceneBox. Um SceneBox pode possuir varios materials, cada um atribuindo a ele diferentes estilos. Por isso passamos um array.
//        cube.materials = [material]
//
//        //Agora vamos definir em qual local do espaco virtual o SCNBox vai ser inserido.
//        //Cada SCNBox deve ter um node no espaco virutal
//        let node = SCNNode()
//        // Vamos definir a posicao do node nos eixos x, y e z (em metros)
//        node.position = SCNVector3(0, 0.1, -0.5)
//        // Vamos inserir o objeto geometrico que vai ser posicionado no node
//        node.geometry = cube
//
//        sceneView.scene.rootNode.addChildNode(node)
//         // Na linha abaixo estamos colocando contraste de iluminacao para o objeto parecer vivido
//        sceneView.autoenablesDefaultLighting = true
        
//MARK: - Criando a Lua
//        let moon = SCNSphere(radius: 0.2)
//        let materialMoon = SCNMaterial()
//        //A textura que estamos usando para colocar na esfera foi baixada do site:
//        // https://www.solarsystemscope.com/textures/
//        materialMoon.diffuse.contents = UIImage(named: "art.scnassets/8k_moon.jpg")
//        moon.materials = [materialMoon]
//
//        let nodeMoon = SCNNode()
//        nodeMoon.position = SCNVector3(0, 0.1, -0.5)
//        nodeMoon.geometry = moon
//
//        sceneView.scene.rootNode.addChildNode(nodeMoon)
//        sceneView.autoenablesDefaultLighting = true
        
//MARK: - Baixando um modelo 3D de um dado na internet
        // Voce pode encontrar modelos gratuitos e pagos nesse site
        // https://www.turbosquid.com/
        // acesse algum elemento e baixe a versao no formato Collada.dae
        // Pegue o arquivo e arraste para a pasta art.scnassets
        // Selecione o arquivo e va em Editor > Convert to SceneKit file format
        
//        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn" )
//
//        // Um objeto 3D pode ter child nodes. Entao, ao se carregar um objeto 3D e interessante fazer o processo recursivamente, para que toda a sua arvore de node seja tambem carregada.
//        if let diceNode = diceScene?.rootNode.childNode(withName: "Dice", recursively: true) {
//            diceNode.position = SCNVector3(0, 0, -0.1)
//            sceneView.scene.rootNode.addChildNode(diceNode)
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        // ARWorldTrackingConfiguration permite ao iPhone criar uma correspondencia entre o ambiente virtual e o ambiente real, permitindo assim inserir objetos 3D nesse ambiente e controlar seus posicionamentos e tamanhos relativos a posicao do iPhone, de modo a se ter realmente experiencia em AR. Em outras palavras, a pessoa pode percorrer e rodear o elemento 3D como se ele realmente estivesse presente no ambiente.
        let configuration = ARWorldTrackingConfiguration()

        //A flag abaixo e util para saber se o aparelho tem suporte a tecnologia
        print(ARWorldTrackingConfiguration.isSupported)
        
        // Aqui configuramos a deteccao de superficies horizontais. (Vertical ainda nao esta disponivel)
        // Quando a superficie e detectada, uma das delegate functions e chamada. Veja mais abaixo
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // didAdd e a delegate function chamada assim que um um objeto e adicionado ao espaco virtual, seja um plano, um objeto 3D ou uma imagem.
    // Quando voce configura a deteccao de planos horizontais, a framework, assim que detectar, automaticamente atribui um widh e um height para essa superficie, na forma de um objeto do tipo ARPlaneAnchor.
    // Assim, teremos no espaco virtual uma superficie com coordenadas onde voce podera posicionar objetos.
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // Vamos verificar se o objeto adicionado e um ARPlaneAnchor
        if anchor is ARPlaneAnchor {
            
            let planeAnchor = anchor as! ARPlaneAnchor
            
            // Para trabalhar com o plano no ambiente virtual, temos que criar um ScenePlane com as extensoes do plano que foi detectado
            let plane =  SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            // vamos criar um no para o plano e posiciona-lo no centro do plano.
            let planeNode = SCNNode()
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0.0, z: planeAnchor.center.z)
            
            // ATENCAO. O SCNPlane, depois de criado, fica com representacao vertical. Temos que rotaciona-lo parar ficar horizontal.
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2.0, 1, 0, 0)
            
            // Vamos adicionar uma textura de grid ao plano, para que possamos ver ele no ambiente virtual
            let gridMaterial = SCNMaterial()
            // Nosso grid e uma imagem png, isso significa que poderemos ver atravez do grid.
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            
            // Adicionamos o grid ao plano
            plane.materials = [gridMaterial]
            
            // Adicionamos o plano ao no (que vai transforma-lo, rotacionando-o)
            planeNode.geometry = plane
            
            //node e um dos argumentos da funcao. Ele referencia sceneView.scene.rootNode
            node.addChildNode(planeNode)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        <#code#>
    }

}
