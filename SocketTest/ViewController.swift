//
//  ViewController.swift
//  SocketTest
//
//  Created by JOEYCO-0072PK on 20/12/2021.
//

import UIKit

class ViewController: UIViewController , URLSessionWebSocketDelegate{

    @IBOutlet weak var label: UITextField!
    private var webSocket:URLSessionWebSocketTask?
    override func viewDidLoad() {
        super.viewDidLoad()
     
        view.backgroundColor = .purple
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let url = URL(string:  "wss://demo.piesocket.com/v3/channel_1?api_key=oCdCMcMPQpbvNjUIzqtvF1d2X2okWpDQj4AwARJuAgtjhzKxVEjQU6IdCjwm&notify_self")
        let  webSocket = session.webSocketTask(with: url!)
        webSocket.resume()
        
    }


    func ping(){
        webSocket?.sendPing(pongReceiveHandler: {
            error in if let error = error{
                print("Print Error: \(error)")
            }
        })
    }

    func close(){
        webSocket?.cancel(with: .goingAway, reason: "Demo Ended".data(using: .utf8))
    }
    @IBAction func tap(_ sender: Any) {
        print("Connected")
        ping()
        receive()
        send(self.label.text!)
    }
    func send(_ msg: String){
        DispatchQueue.global().asyncAfter(deadline: .now()+1){
            self.send(msg)
            self.webSocket?.send(.string(""), completionHandler: {
                error in if let error = error{
                    print("Print Error: \(error)")
                }
                
        })
            
        }
        print("\(msg) \(Int.random(in: 0...100))")
                        }
    func receive(){
        webSocket?.receive(completionHandler: {
            result in
            switch result{
            case .success(let message):
                switch message{
                case .data(let data):
                    print("Got Data: \(data)")
                case .string(let message):
                    print("Got String: \(message)")
                @unknown default:
                    print("Error")
                }
            case .failure(let error):
                print("Receive error: \(error)")
            
            }
            
        })
        print("new message recieved")
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
       
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Disconnected")
    }
}
