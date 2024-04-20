Read this in other languages: [English](README.md), [简体中文](README_zh.md).

# Docker Image Comparator

The Docker Image Comparator is a tool designed to help users compare two Docker images to find differences between them.
This script automates the process of pulling images, exporting their contents, and using diff tools to highlight
changes.

## Features

- **Automatic Image Pulling**: Pull images directly from a Docker registry to ensure you are comparing the latest
  versions.
- **Detailed Comparison**: Export the contents of Docker images and compare directories and files to identify changes.
- **Output Results**: Generate a log file and organized directories reflecting changes such as additions, deletions, and
  modifications.

## Prerequisites

Before you start using the Docker Image Comparator, make sure you have the following installed on your system:

- Docker
- Bash environment
- Basic utilities: grep, awk, tar, diff

## Installation

Clone the repository to your local machine:

```bash
git clone https://github.com/yourusername/docker-image-comparator.git
cd docker-image-comparator
```

Make the script executable:

```bash
chmod +x compare_images.sh
```

## Usage

To start comparing two Docker images, run the script with the names of the images you want to compare:

```bash
./compare_images.sh <new_image_name> <old_image_name> [pull]
```

The optional `pull` argument tells the script to pull the latest images from the Docker registry before comparing.

## Example

```bash
./compare_images.sh myrepo/new-image:tag myrepo/old-image:tag pull
```

This command will pull the `new-image` and `old-image` from `myrepo`, export their contents, and perform a detailed
comparison.

## Contributing

Contributions to the Docker Image Comparator are welcome! Please feel free to submit pull requests, create issues for
bugs you've noticed, or suggest improvements through the GitHub issue tracker.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE) file for details.

## Acknowledgements

- Thanks to all the contributors who have helped to improve this tool.

