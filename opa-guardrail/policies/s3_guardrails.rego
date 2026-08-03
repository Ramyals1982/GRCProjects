package terraform.guardrails

import rego.v1

# Rule 1: Block any bucket missing mandatory Enterprise Tags
deny contains msg if {
    some resource in input.resource_changes
    resource.type == "aws_s3_bucket"
    not resource.change.after.tags.CostCenter
    msg := sprintf("COMPLIANCE VIOLATION: Resource '%s' is missing required tag 'CostCenter'.", [resource.address])
}

# Rule 2: Require Server-Side Encryption across all storage buckets
deny contains msg if {
    some resource in input.resource_changes
    resource.type == "aws_s3_bucket"
    
    # Check if a matching encryption configuration resource exists in the plan
    enc_configs := [r | 
        r := input.resource_changes[_]
        r.type == "aws_s3_bucket_server_side_encryption_configuration"
    ]
    count(enc_configs) == 0
    
    msg := sprintf("SECURITY VIOLATION: S3 bucket '%s' must have server-side encryption configured.", [resource.address])
}