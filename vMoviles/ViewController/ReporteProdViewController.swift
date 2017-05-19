//
//  ReporteProdViewController.swift
//  vMoviles
//
//  Created by David Galvan on 3/23/17.
//  Copyright © 2017 sysba. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class ReporteProdViewController: UIViewController, UIWebViewDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var webView: UIWebView!
    var _folio:String!
    var _email:String!
    var _productosDetalle: [ProductoDetalle] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.generarHTML()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.generarHTML()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func generarHTML () {
        var htmlNew : String = ""
        var index :Int = 0
        
        do{
            guard let filePath = Bundle.main.path(forResource: "rptProductos", ofType: "html")
                else {
                    // File Error
                    print ("Error al cargar la plantilla del Reporte")
                    return
            }
            
            var contents =  try String(contentsOfFile: filePath, encoding: .utf8)
            
            
            for item in self._productosDetalle {
                index = index + 1
                htmlNew = htmlNew + self.crearRenglon(item: item, index: index)
            }
            
            if( (index % 3) != 0) {
                htmlNew = htmlNew + " </div> \r\n"
            }
            
            contents =  contents.replacingOccurrences(of: "$tagRows$", with: htmlNew)
            let baseUrl = URL.init(fileURLWithPath: filePath)
            self.webView.loadHTMLString(contents as String, baseURL: baseUrl)
        }
        catch
        {
            print ("Error en el archivo HTML")
        }
        
    }
    
    func crearRenglon( item: ProductoDetalle, index: Int) -> String {
        var row: String = ""
        
        // Se convierta la imagen a NSData
        let imageData : NSData = NSData(data: UIImagePNGRepresentation(item.imagen)!)
        let base64String = imageData.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
        
        if(index == 1) {
            row = "<div class='row'>"
        }
        
        row = row + " <div class='col-xs-4'>"
        row = row + "  <div class='box'>"
        row = row + "    <div class='row imagenst'>"
        row = row + "     <div class='col-xs-12 centertext'>"
        row = row + "      <img alt='Zapato' style='width:210px; height:195px;' src='data:image/png;base64,\(base64String)' /> "
        row = row + "     </div> "
        row = row + "    </div>"
        row = row + "    <div class='row'>"
        row = row + "     <div class='col-xs-4'>Estilo:</div>"
        row = row + "     <div class='col-xs-8'>\(item.estilo)</div>"
        row = row + "    </div>"
        row = row + "    <div class='row'>"
        row = row + "      <div class='col-xs-4'>Opcion:</div>"
        row = row + "      <div class='col-xs-8'>\(item.opcion)</div>"
        row = row + "    </div>"
        row = row + "    <div class='row'>"
        row = row + "      <div class='col-xs-4'>Descripcion:</div>"
        
        if(item.pielcolor.characters.count > 22) {
            row = row + "      <div class='col-xs-8 smallDes'>\(item.pielcolor)</div>"
        } else {
            row = row + "      <div class='col-xs-8'>\(item.pielcolor)</div>"
        }
        row = row + "    </div>"
        row = row + "    <div class='row'> "
        row = row + "      <div class='col-xs-12'>\(item.linea)</div>"
        row = row + "    </div>"
        row = row + "    <div class='row'>"
        row = row + "      <div class='col-xs-12 centertext'>Precio: <label class='precio'> $ \(item.precio)</label></div>"
        row = row + "    </div> </div> </div> \r\n"

        
        if( (index % 3)  == 0 ) {
            row = row + " </div> \r\n"
            row = row + " <div class='row'>"
        }
        
        return row
    }
    
    func cargarPDF(folio: String) {
        //Se guarda el pdf en un archivo
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath  = "\(documentsPath)/rptProcuctos-\(folio).pdf"
        print(filePath)
        let url = NSURL(fileURLWithPath: filePath)
        let urlRequest = NSURLRequest(url: url as URL)
        
        webView.loadRequest(urlRequest as URLRequest)
        
    }
    
    func crearPDF(folio: String) {
        //let html = "<b> Hola Productos</b>"
        //let fmt = UIMarkupTextPrintFormatter(markupText: html)
        
        let fmt = self.webView.viewPrintFormatter()
        
        //Se asigna el formato de impresora
        let render = UIPrintPageRenderer()
        render.addPrintFormatter(fmt, startingAtPageAt: 0)
        
        let page = CGRect(x:0, y:0,width:595.2,height: 841.8) //A4, 72 dpi
        let printable = page.insetBy(dx: 0,dy: 0)
        
        render.setValue(NSValue(cgRect: page), forKey: "paperRect")
        render.setValue(NSValue(cgRect: printable), forKey: "printableRect")
        
        //Se crea el contexto del PDF
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, CGRect.zero, nil)
        
        for i in 1...render.numberOfPages {
            UIGraphicsBeginPDFPage()
            let bounds = UIGraphicsGetPDFContextBounds()
            render.drawPage(at: i-1, in: bounds)
        }
        
        UIGraphicsEndPDFContext()
        
        //Se guarda el pdf en un archivo
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        pdfData.write(toFile: "\(documentsPath)/rptProcuctos-\(folio).pdf", atomically: true)
        
        self.cargarPDF(folio: folio)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if !webView.isLoading{
            print("termino de cargar")
        }
    }
    
    func configuredMailComposeViewController(folio: String, email: String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([email])
        mailComposerVC.setSubject("Productos pedido con folio \(folio)")
        mailComposerVC.setMessageBody("Se agrega el pdf con el detalle del pedido.", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        Ui.showMessageDialog(onController: self,
                             withTitle: "No se puede enviar el Correo",
                             withMessage: "Tu dispositivo no puede enviar correos. Favor de checar la configuracion de correos y volver a intentar.",
                             withError: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func enviaCorreo(folio: String) {
        let mailComposeViewController = configuredMailComposeViewController(folio: folio,email: self._email)
        if MFMailComposeViewController.canSendMail() {
            
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let filePath  = "\(documentsPath)/rptProcuctos-\(folio).pdf"
            
            if let fileData = NSData(contentsOfFile: filePath) {
                mailComposeViewController.addAttachmentData(fileData as Data, mimeType: "application/pdf", fileName: filePath)
                self.present(mailComposeViewController, animated: true, completion: nil)
            }
        } else {
            self.showSendMailErrorAlert()
        }
    }

    
    @IBAction func onCerrar(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
    }

    @IBAction func onCrearPDF(_ sender: Any) {
        self.crearPDF(folio:self._folio)
        self.enviaCorreo(folio: self._folio)
    }
    
}




