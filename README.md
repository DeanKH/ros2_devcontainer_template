# ROS2 + CUDA Development Container Template

This template provides a comprehensive development environment for ROS2 projects with CUDA support, suitable for both C++ and Python development.

## Features

- **Base**: NVIDIA CUDA 12.4.1 with cuDNN on Ubuntu 22.04
- **ROS2**: Humble desktop installation with CycloneDDS middleware
- **Languages**: Full C++ and Python development support
- **GPU**: NVIDIA GPU access with proper drivers and capabilities
- **GUI**: X11 forwarding for running GUI applications
- **Tools**: Development tools including CMake, Ninja, clangd, and more

## Quick Start

1. Copy this template to your project directory
2. Customize the `compose.yaml` and `devcontainer.json` files as needed
3. Open the project in VS Code
4. Use "Dev Containers: Reopen in Container" command

## File Structure

```
devcontainer_template/
├── Dockerfile              # Multi-stage build with CUDA + ROS2
├── compose.yaml            # Docker Compose configuration
├── .devcontainer/
│   └── devcontainer.json   # VS Code devcontainer configuration
├── cyclonedx.xml          # CycloneDX DDS configuration
├── bash_history           # Persistent bash history
└── README.md              # This file
```

## Customization

### Environment Variables

Set these in your host environment or modify `compose.yaml`:

- `UID`: Your user ID (default: 1000)
- `GID`: Your group ID (default: 1000)
- `DISPLAY`: For X11 forwarding
- `ROS_DOMAIN_ID`: ROS2 domain ID (default: 0)

### Python Packages

Add your Python dependencies to the Dockerfile:

```dockerfile
RUN pip3 install --no-cache-dir \
  your-package-name \
  another-package
```

### VS Code Extensions

Modify the extensions list in `.devcontainer/devcontainer.json` to add or remove extensions.

### ROS2 Workspace Setup

After the container starts, initialize your ROS2 workspace:

```bash
cd /home/developer/workspace
colcon build
source install/setup.bash
```

## GPU Support

This template includes full NVIDIA GPU support:

- CUDA 12.4.1 with cuDNN
- Proper device mapping in Docker Compose
- Environment variables for GPU access

Test GPU access:

```bash
nvidia-smi
nvcc --version
```

## Networking

- Uses host networking for easy ROS2 communication
- X11 forwarding for GUI applications
- Jupyter notebook port (8888) forwarded

## Volumes

Persistent volumes for:

- Source code
- VS Code extensions
- Pip cache
- Colcon build cache
- Bash history

## Troubleshooting

### X11 Issues

If GUI applications don't work, ensure X11 forwarding is properly configured:

```bash
xhost +local:docker
```

### GPU Issues

Verify NVIDIA Docker runtime is installed on your host:

```bash
docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
```

### Permission Issues

Ensure UID/GID are properly set in compose.yaml to match your host user.

## License

This template is provided as-is for development purposes.
