group "default" {
    targets = ["lambda"]
}

variable "IMAGE_URI" {}
variable "IMAGE_TAG" {}
variable "PYTHON_VERSION" {}
variable "PLATFORM" {}


target "lambda" {
    context    = "."
    dockerfile = "Dockerfile"

    args = {
        PYTHON_VERSION = PYTHON_VERSION
    }

    tags = [
        "${IMAGE_URI}:${IMAGE_TAG}",
        "${IMAGE_URI}:latest"
    ]

    platforms = [
        PLATFORM
    ]

    provenance = false
}