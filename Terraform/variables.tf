variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "64aa4541-62e0-4a34-b4fc-db2d04cc1b6d"
    env      = "Development"
  }
}

