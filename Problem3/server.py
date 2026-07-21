import json
from http.server import BaseHTTPRequestHandler, HTTPServer

current_status = {"status": "OK"}

class RequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/api/v1/status':
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            self.wfile.write(json.dumps(current_status).encode('utf-8'))
        else:
            self.send_response(404)
            self.end_headers()

    def do_POST(self):
        global current_status
        if self.path == '/api/v1/status':
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            current_status = json.loads(post_data.decode('utf-8'))
            self.send_response(201)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            self.wfile.write(json.dumps(current_status).encode('utf-8'))
        else:
            self.send_response(404)
            self.end_headers()

def run():
    server_address = ('0.0.0.0', 8000)
    httpd = HTTPServer(server_address, RequestHandler)
    httpd.serve_forever()

if __name__ == '__main__':
    run()
