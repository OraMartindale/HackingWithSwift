import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: [String: String]!
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard detailItem != nil else { return }
        
        if let body = detailItem["body"] {
            var html = [String]()
            html.append("<html>")
            html.append("<head>")
            html.append("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">")
            html.append("<style> body { font-size: 150%; } </style>")
            html.append("</head>")
            html.append("<body>")
            html.append(body)
            html.append("</body>")
            html.append("</html>")
            webView.loadHTMLString(html.joined(), baseURL: nil)
        }
    }
}
