variable "name" {
  description = "Name of the policy set"
  type        = string
}

variable "description" {
  description = "Description of the policy set's purpose"
  type        = string
  default     = null
}

variable "organization" {
  description = "Name of the HCP Terraform organization"
  type        = string
}

variable "policy_kind" {
  description = "The policy-as-code framework to use (sentinel or opa)"
  type        = string
  default     = "sentinel"
  validation {
    condition     = contains(["sentinel", "opa"], var.policy_kind)
    error_message = "Policy kind must be either 'sentinel' or 'opa'."
  }
}

variable "agent_enabled" {
  description = "Whether or not the policy set is run as a policy evaluation within the agent. Always true for OPA policies regardless of this setting."
  type        = bool
  default     = true
}

variable "policy_tool_version" {
  description = "The policy tool version to run the evaluation against"
  type        = string
  default     = "latest"
}

variable "overridable" {
  description = "Whether or not users can override this policy when it fails during a run. Only valid for OPA policies; ignored for Sentinel policies."
  type        = bool
  default     = false
}

variable "global" {
  description = "Whether policies in this set will apply to all workspaces"
  type        = bool
  default     = true
}

variable "workspace_ids" {
  description = "List of workspace IDs to which the policy set should be attached (cannot be used with global = true)"
  type        = list(string)
  default     = []
}

variable "policy_source" {
  description = "Source of the policies: 'local' for local files or 'git' for public git repository"
  type        = string
  validation {
    condition     = contains(["local", "git"], var.policy_source)
    error_message = "Policy source must be one of: 'local' or 'git'."
  }
}

variable "local_policies_path" {
  description = "Path to the directory containing local policy files (required when policy_source = 'local')"
  type        = string
  default     = null
}

variable "git_url" {
  description = "URL of the public Git repository containing policies (required when policy_source = 'git')"
  type        = string
  default     = null
}

variable "git_branch" {
  description = "Branch of the Git repository to use (when policy_source = 'git')"
  type        = string
  default     = "main"
}

variable "git_policies_path" {
  description = "Path within the Git repository where policies are located (when policy_source = 'git')"
  type        = string
  default     = ""
}
