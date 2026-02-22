**Run the Project**
1. docker-compose up --build

http://localhost:3000 (open this link in browser)

<img width="1919" height="536" alt="image" src="https://github.com/user-attachments/assets/d4938b10-5b69-40cf-9804-b914656a7c8d" />

**Push Images to Docker Hub**
open cmd
  1. docker login
  2. docker tag fullstack-docker-app_frontend yourdockerhubusername/frontend-app
  3. docker tag fullstack-docker-app_backend yourdockerhubusername/backend-app
  4. docker push yourdockerhubusername/frontend-app
  5. docker push yourdockerhubusername/backend-app



<img width="1917" height="688" alt="image" src="https://github.com/user-attachments/assets/6befccdf-338d-44e0-90fe-0d1c23e6df50" />
