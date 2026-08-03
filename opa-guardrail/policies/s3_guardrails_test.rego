package terraform.guardrails

import rego.v1

test_deny_missing_costcenter_tag if {
    mock_plan := {
        "resource_changes": [
            {
                "address": "aws_s3_bucket.bad_bucket",
                "type": "aws_s3_bucket",
                "change": {"after": {"tags": {"Environment": "Dev"}}}
            },
            {
                "address": "aws_s3_bucket_server_side_encryption_configuration.bad_bucket_enc",
                "type": "aws_s3_bucket_server_side_encryption_configuration"
            }
        ]
    }
    
    violations := deny with input as mock_plan
    count(violations) == 1
}