variable "stage" {
  type        = string
  description = "stage name used as part of resource names. prod, dev, qa. this is populated by the ci pipeline"
}

variable "function_s3_key" {
  type        = string
  description = "the s3 key of the function to be deployed"
}
