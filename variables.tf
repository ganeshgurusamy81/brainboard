variable "location" {
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "b41b40a4-9e3a-4373-819f-58128890ff97"
    env      = "Development"
  }
}

