# Problem 3 - Docker Web Server

This is the solution for Problem 3 where we had to write a simple HTTP server and containerize it using Docker. 

I decided to write the server in standard Python using the built-in http.server library. This made it a lot easier because I didn't have to use Flask or set up a requirements.txt file. The server listens on port 8000. 

By default, the server stores a state of `{"status": "OK"}`. If you send a GET request to `/api/v1/status`, it returns that state with a 200 code. If you send a POST request with a new JSON body, it updates the state, returns the new state with a 201 code, and any future GET requests will show the updated status.

To build and run this, I used the python:3.9-slim image to keep the container footprint small. 

### Commands to test:
Build the image:
`docker build -t problem3-server .`

Run it:
`docker run -d -p 8000:8000 --name my-server problem3-server`

Test GET:
`curl -X GET http://localhost:8000/api/v1/status`

Test POST:
`curl -X POST -H "Content-Type: application/json" -d '{"status": "not OK"}' http://localhost:8000/api/v1/status`
