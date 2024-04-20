# Docker 镜像比较工具

Docker 镜像比较工具旨在帮助用户比较两个 Docker 镜像之间的差异。该脚本自动化了拉取镜像、导出其内容并使用差异比较工具突出显示变化的过程。

## 功能特点

- **自动拉取镜像**：直接从 Docker 注册中心拉取镜像，确保比较的是最新版本。
- **详细比较**：导出 Docker 镜像的内容，并比较目录和文件以识别变更。
- **结果输出**：生成记录文件和组织好的目录，反映添加、删除和修改的更改。

## 系统要求

在开始使用 Docker 镜像比较工具之前，请确保您的系统中已安装以下软件：

- Docker
- Bash 环境
- 基本工具：grep、awk、tar、diff

## 安装

克隆仓库到您的本地机器：

```bash
git clone https://github.com/yourusername/docker-image-comparator.git
cd docker-image-comparator
```

使脚本具有可执行权限：

```bash
chmod +x compare_images.sh
```

## 使用说明

要开始比较两个 Docker 镜像，请使用您想要比较的镜像的名称运行脚本：

```bash
./compare_images.sh <新镜像名称> <旧镜像名称> [pull]
```

可选的 `pull` 参数告诉脚本在比较前从 Docker 注册中心拉取最新的镜像。

## 示例

```bash
./compare_images.sh myrepo/new-image:tag myrepo/old-image:tag pull
```

此命令将从 `myrepo` 拉取 `new-image` 和 `old-image`，导出它们的内容，并进行详细比较。

## 贡献

欢迎对 Docker 镜像比较工具进行贡献！请随时提交拉取请求，为您注意到的错误创建问题，或通过 GitHub 问题跟踪器提出改进建议。

## 许可证

此项目根据 MIT 许可证授权 - 详见 [LICENSE.md](LICENSE) 文件。

## 致谢

- 感谢所有帮助改进此工具的贡献者。
