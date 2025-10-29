
# Chat-app



A full-stack real-time chat application built with:

-  **Backend**: Spring Boot + WebSocket  
-  **Frontend**: React  
-  **Database**: MySQL  
-  **Containerized** with Docker Compose  

---

##  Features

- Real-time messaging using WebSocket (STOMP over SockJS)
- Persistent chat storage in MySQL
- Dockerized backend, frontend, and database
- Easy deployment on EC2 or any Docker-compatible host

##  Project Structure

chatapp/ 

         ├── backend/ # Spring Boot backend 
         ├── frontend/ # React frontend 
         ├── docker-compose.yml

---

##  Prerequisites

- Docker & Docker Compose installed
- Git (to clone the repo)
- (Optional) EC2 instance with ports **80** and **5000** open

---

## ⚙️ How to Run Locally

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/chatapp.git
   cd chatapp
2. **Update frontend WebSocket URL****
In frontend/src/App.js (or wherever SockJS is initialized), 

replace:

const socket = new SockJS("http://chat-backend:5000/ws-chat");

with:

const socket = new SockJS("http://<your-ec2-ip>:5000/ws-chat");

3. **Start the app****
 
docker-compose up --build -d

4. **Access the app****
Frontend: http://<your-ec2-ip> (port 80)

Backend: http://<your-ec2-ip>:5000

WebSocket: ws://<your-ec2-ip>:5000/ws-chat




