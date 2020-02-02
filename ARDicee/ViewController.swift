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
        sceneView.showsStatistics = true
        
        // Create a new scene
        // Pega o modelo 3D do aviao que o XCode nos deu de brinde e cria um elemento AR, que e chamado de scene.
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // SInsereo scene na ARView.
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        // ARWorldTrackingConfiguration permite ao iPhone criar uma correspondencia entre o ambiente virtual e o ambiente real, permitindo assim inserir objetos 3D nesse ambiente e controlar seus posicionamentos e tamanhos relativos a posicao do iPhone, de modo a se ter realmente experiencia em AR. Em outras palavras, a pessoa pode percorrer e rodear o elemento 3D como se ele realmente estivesse presente no ambiente.
        let configuration = ARWorldTrackingConfiguration()

        //A flag abaixo e util para saber se o aparelho tem suporte a tecnologia
        print(ARWorldTrackingConfiguration.isSupported)

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

}
