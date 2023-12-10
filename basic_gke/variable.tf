variable "accounts" {
  type = object({
    project = string
    region = string
    zone = string
  })
  default = {
    project = "gcp-playground-406209"
    region = "asia-northeast1"
    zone = "asia-northeast1-a"
  }
}
