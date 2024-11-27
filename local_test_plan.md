
# **Test Plan for React and Spring Data REST Application**

## **1. Understand the Application**

The application architecture, which includes:

- A React.js frontend.
- A Spring Boot REST API backend.
- Both components packaged together using Maven into a single deployable JAR file.

## **2. Set Up Environment**

Ensure all dependencies are installed and up-to-date on local system:

- **Required Tools:** Maven, Node.js, npm, Docker.
- **Verify Installation:** Run the following commands:
  - `mvn -v` to check Maven installation.
  - `node -v` and `npm -v` to verify Node.js and npm versions.
  - `docker -v` to ensure Docker is installed.

## **3. Update Node.js and npm Versions**

Address compatibility issues in the `pom.xml` file:

- Update Node.js version to `v16.20.0` (replace `v12.14.0`).
  - Reason: Node.js `v12.14.0` for the `darwin-arm64` architecture is unavailable, causing a 404 error.
- Updated npm version to `8.19.4` to match the Node.js version.

## **4. Build and Package the Application**

1. Make Maven wrapper scripts executable:

   ```bash
   chmod +x ./mvnw ./mvnw.cmd
   ```

2. Build the application using:

   ```bash
   ./mvnw clean package
   ```

3. Verified that the `target` directory contains the generated JAR file:
   - `target/react-and-spring-data-rest-0.0.1-SNAPSHOT.jar`.

## **5. Build Docker Image**

1. Use the Dockerfile to build the Docker image:

   ```bash
   docker build -t springboot-react-app .
   ```

2. Verify the image was built successfully:

   ```bash
   docker images
   ```

## **6. Run the Application Using Docker**

1. Start the container:

   ```bash
   docker run -d -p 8080:8080 --name springboot-react-container springboot-react-app
   ```

   - The `-p` flag maps port `8080` on the host to port `8080` inside the container.
   - The `-d` flag runs the container in detached mode.

2. Verify the container is running:

   ```bash
   docker ps
   ```

## **7. Test the Application**

### **Backend API**

Use the `curl` command to test the API:

```bash
curl -v -u greg:turnquist http://localhost:8080/api/employees/3
```

- **Expected Output (example):**

  ```json
  {
    "firstName" : "Frodo",
    "lastName" : "Baggins",
    "description" : "ring bearer",
    "manager" : { 
      "name" : "greg", 
      "roles" : [ "ROLE_MANAGER" ] 
    },
    "_links" : {
      "self" : {
        "href" : "http://localhost:8080/api/employees/1"
      }
    }
  }
  ```

### **Frontend**

1. Open a browser and navigate to:

   ```
   http://localhost:8080
   ```

2. Log in using the provided credentials:
   - **Username:** `greg`
   - **Password:** `turnquist`
3. Verify that the frontend loads correctly and that it integrates with the backend API.

## **8. Troubleshooting**

- Check container logs if issues arise:

  ```bash
  docker logs springboot-react-container
  ```

- Verify port availability using:

  ```bash
  lsof -i :8080
  ```

- Rebuild the Docker image if changes are made to the application:

  ```bash
  docker build -t springboot-react-app .
  ```
