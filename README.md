# APIs-with-FastAPI

This is the documentation for the course Building APIs with FastAPI

Here you will find:
- The source code of the API
- The dockerfile
- The postman collection to test the API

https://www.onlinegantt.com/#/gantt Tool used
Current Gant is here "C:\Docker\Dockerfiles\andreas_kretz_apis-with-fastapi\img\GantPlan-20250525.PNG"

# Docker build command
docker build -t joelsfastapi:latest .

# Docker run command
docker run -d -p 8000:8000 --name joelsfastapi joelsfastapi:latest
joelsfastapi:latest 






# How do i docker build an image (based on a github repository contents)
To Docker build an image based on the contents of a GitHub repository, you generally have two main approaches:

1.  **Clone the repository locally and then build the image.** This is the most common and often the simplest method.
2.  **Build directly from the GitHub repository URL (using `docker build <URL>`).** This is convenient but has some limitations.

Let's break down both methods:

### Method 1: Clone Locally and Build (Recommended for most cases)

This method gives you full control and allows you to modify the `Dockerfile` or other files before building if needed.

**Steps:**

1.  **Prerequisites:**
    * Docker installed and running on your machine.
    * Git installed on your machine.

2.  **Identify the Repository and Dockerfile:**
    * Go to the GitHub repository you want to use.
    * Locate the `Dockerfile` within the repository. If there isn't one, you'll need to create one first.

3.  **Clone the Repository:**
    * Open your terminal or command prompt.
    * Navigate to the directory where you want to store the repository.
    * Clone the repository using `git clone`:

        ```bash
        git clone https://github.com/your-username/your-repository.git
        ```
        Replace `your-username/your-repository.git` with the actual URL of the GitHub repository.

4.  **Navigate into the Cloned Directory:**

    ```bash
    cd your-repository
    ```

5.  **Build the Docker Image:**
    * Once inside the repository directory (where your `Dockerfile` is located), run the `docker build` command:

        ```bash
        docker build -t your-image-name:tag .
        ```
        * `-t your-image-name:tag`: This tags your image with a name and an optional version tag (e.g., `my-app:1.0` or just `my-app`). It's good practice to always tag your images.
        * `.`: The dot at the end is crucial. It tells Docker to look for the `Dockerfile` in the current directory (the build context).

**Example Workflow:**

Let's say you want to build an image from a repository like `https://github.com/docker/getting-started`:

```bash
# Clone the repository
git clone https://github.com/docker/getting-started.git

# Change into the repository directory
cd getting-started

# Build the Docker image
docker build -t getting-started-app:latest .

# You can then run the image
docker run -p 80:80 getting-started-app:latest
```

---

### Method 2: Build Directly from GitHub Repository URL (Less Common, Some Limitations)

Docker has a feature to build directly from a Git repository URL. This is convenient if you don't want to clone the repo locally, but it assumes the `Dockerfile` is at the root of the repository or a specified subdirectory.

**Limitations:**

* You cannot easily make local changes to the `Dockerfile` or other files before building.
* The `Dockerfile` path needs to be specified correctly if it's not at the root.
* Authentication for private repositories can be more complex.

**Command:**

```bash
docker build -t your-image-name:tag https://github.com/your-username/your-repository.git#branch-name:path/to/dockerfile
```

**Explanation of the URL format:**

* `https://github.com/your-username/your-repository.git`: The URL of the Git repository.
* `#branch-name`: (Optional) Specifies the branch to use. If omitted, it defaults to the default branch (usually `main` or `master`).
* `:path/to/dockerfile`: (Optional) Specifies the path to the directory containing the `Dockerfile` *relative to the repository root*. If your `Dockerfile` is at the root, you can omit this.

**Example:**

If your `Dockerfile` is at the root of the `main` branch:

```bash
docker build -t my-github-app:latest https://github.com/your-username/your-repository.git
```

If your `Dockerfile` is in a subdirectory named `app` on the `dev` branch:

```bash
docker build -t my-github-app:dev https://github.com/your-username/your-repository.git#dev:app
```

---

### Essential Considerations:

* **Dockerfile:** The core of your Docker image. Ensure your GitHub repository contains a well-defined `Dockerfile` that specifies how your application should be built and run.
* **`.dockerignore`:** Similar to `.gitignore`, a `.dockerignore` file in your repository can prevent unnecessary files from being sent to the Docker daemon during the build process, speeding up builds and reducing image size.
* **Build Context:** The directory you specify with `.` (or the URL in the second method) is the "build context." Docker sends *everything* in this context to the Docker daemon. This is why `.dockerignore` is important.
* **Private Repositories:**
    * **Method 1 (Clone Locally):** You'll need to authenticate Git (e.g., with SSH keys or a personal access token) to clone the private repository. Once cloned, the Docker build process is the same.
    * **Method 2 (Build from URL):** This is more challenging. You might need to use `git config` to embed credentials (not recommended for security) or explore more advanced Docker build options for authentication if you absolutely must build directly from a private URL. Cloning locally is generally much simpler for private repos.

Choose the method that best suits your workflow and the specifics of the GitHub repository you're working with. For most development and production scenarios, cloning locally and then building is the preferred approach.















# What is i have a problem accessing the localhost with the build
The error "localhost didn't send any data" when trying to access your FastAPI container at `http://localhost:8000` usually means one of a few things:

1.  **Your FastAPI application isn't actually running or listening on the correct port *inside* the container.** This is the most common reason.
2.  **The port mapping (`-p`) in your `docker run` command is incorrect.**
3.  **Your FastAPI app is binding to `127.0.0.1` instead of `0.0.0.0` inside the container.**

Let's go through the debugging steps and how to fix them:

### Step 1: Verify the Docker Container is Running Correctly

First, ensure your container is actually up and not immediately exiting.

```bash
docker ps
```

**What to look for:**
* You should see your container (e.g., `my-fastapi-container`) listed.
* Its `STATUS` column should show `Up X seconds/minutes`.
* The `PORTS` column should show `0.0.0.0:8000->8000/tcp` (or similar, indicating your port mapping).

**If the container is NOT listed or shows `Exited (...)`:**
This means your application inside the container failed to start. Proceed to Step 2.

### Step 2: Check the Container Logs for Errors (CRITICAL!)

This is the most important step for debugging. It will tell you what's happening inside your container.

```bash
docker logs my-fastapi-container
```
(Replace `my-fastapi-container` with the actual name you gave your container, or its Container ID from `docker ps`).

**What to look for in the logs:**

* **Error messages:** Look for Python tracebacks, `uvicorn` errors, "Address already in use", "Permission denied", or anything indicating the application failed to start.
* **FastAPI/Uvicorn startup messages:** Ideally, you should see messages like:
    ```
    INFO:     Uvicorn running on http://0.0.0.0:8000 (Press CTRL+C to quit)
    INFO:     Started reloader process [1]
    INFO:     Started server process [8]
    INFO:     Waiting for application shutdown.
    ```
    If you see `http://127.0.0.1:8000`, this is a common issue (see Step 4).

**Common log issues and fixes:**

* **`ModuleNotFoundError: No module named 'fastapi'` or similar:** This means your `requirements.txt` wasn't installed, or the application isn't packaged correctly.
    * **Fix:** Review your `Dockerfile`. Ensure you have `RUN pip install -r requirements.txt` *after* copying `requirements.txt` and *before* copying your application code. Example:
        ```dockerfile
        COPY requirements.txt .
        RUN pip install --no-cache-dir -r requirements.txt
        COPY . .
        CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
        ```
* **`Address already in use` or similar:** This usually means something else on your host machine is already using port 8000, or a previous Docker container wasn't shut down cleanly.
    * **Fix:**
        1.  Stop any existing containers: `docker stop my-fastapi-container` (if it was running)
        2.  Remove it: `docker rm my-fastapi-container`
        3.  Check if any other process is using port 8000 on your host (less common on Windows/macOS, more on Linux):
            * **Linux/macOS:** `sudo lsof -i :8000`
            * **Windows (PowerShell):** `Get-NetTCPConnection -LocalPort 8000`
        4.  Try running your container on a different host port, e.g., `docker run -d -p 8001:8000 --name my-fastapi-container your-fastapi-app:latest` and then access `http://localhost:8001`.

### Step 3: Ensure Correct Port Mapping in `docker run`

Double-check your `docker run` command's `-p` flag.

```bash
docker run -d -p HOST_PORT:CONTAINER_PORT --name my-fastapi-container your-fastapi-app:latest
```

* `HOST_PORT`: The port on your local machine (what you type in your browser).
* `CONTAINER_PORT`: The port *inside the Docker container* that your FastAPI application is listening on.

**Common Mistake:** If your FastAPI app is listening on `8000` inside the container, but you accidentally used `-p 80:8000`, you'd need to go to `http://localhost:80`. Make sure `HOST_PORT` and `CONTAINER_PORT` match your expectations.

### Step 4: Ensure FastAPI Binds to `0.0.0.0` Inside the Container

This is a very common issue for "didn't send data". By default, Uvicorn (what FastAPI uses) often binds to `127.0.0.1` (localhost). Inside a Docker container, `127.0.0.1` refers *only* to the container itself, making it inaccessible from outside the container (even if ports are mapped). You need to bind to `0.0.0.0` to allow external connections.

**Fix:**
Ensure your `CMD` or `ENTRYPOINT` in your `Dockerfile` explicitly tells Uvicorn to bind to `0.0.0.0` (all available network interfaces) and the correct port.

**Example `Dockerfile` excerpt (using `uvicorn` directly):**

```dockerfile
# ... (your other Dockerfile instructions) ...

# Assuming your main FastAPI app is in 'main.py' and the app instance is named 'app'
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

**If you're using a custom `entrypoint.sh` script, ensure it includes `--host 0.0.0.0`:**

```bash
#!/bin/sh
uvicorn main:app --host 0.0.0.0 --port 8000
```

### Step 5: Rebuild the Image (if Dockerfile changed) and Rerun Container

After making any changes to your `Dockerfile` (e.g., fixing `CMD` or `requirements.txt` issues):

1.  **Stop and remove the old container:**
    ```bash
    docker stop my-fastapi-container
    docker rm my-fastapi-container
    ```
2.  **Rebuild your Docker image:**
    ```bash
    docker build -t your-fastapi-app:latest .
    ```
3.  **Run the new container:**
    ```bash
    docker run -d -p 8000:8000 --name my-fastapi-container your-fastapi-app:latest
    ```
4.  **Check logs again (`docker logs my-fastapi-container`)** to confirm successful startup.
5.  **Try accessing `http://localhost:8000`**.

By systematically checking these points, especially the container logs and the Uvicorn host binding, you should be able to identify and fix the issue.