# most of this is from https://gist.github.com/tomfa/6fc429af5d598a85e723b3f56f681237

# the role and profile for the EC2

resource "aws_iam_instance_profile" "beanstalk_ec2" {
  name = "${var.application_name}-beanstalk-ec2-user"
  role = aws_iam_role.beanstalk_ec2.name
}


resource "aws_iam_role" "beanstalk_ec2" {
  name               = "${var.application_name}-beanstalk-ec2-role"
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "beanstalk_ec2_worker" {
  name       = "${var.application_name}-elastic-beanstalk-ec2-worker"
  roles      = ["${aws_iam_role.beanstalk_ec2.id}"]
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}

resource "aws_iam_policy_attachment" "beanstalk_ec2_web" {
  name       = "${var.application_name}-elastic-beanstalk-ec2-web"
  roles      = ["${aws_iam_role.beanstalk_ec2.id}"]
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_policy_attachment" "beanstalk_ec2_container" {
  name       = "${var.application_name}-elastic-beanstalk-ec2-container"
  roles      = ["${aws_iam_role.beanstalk_ec2.id}"]
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}

resource "aws_iam_policy_attachment" "beanstalk_ec2_ecr" {
  name       = "${var.application_name}-elastic-beanstalk-ec2-ecr"
  roles      = ["${aws_iam_role.beanstalk_ec2.id}"]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}


# the service role for the beanstalk

# it might already exist, but then it might not, in which case creating the environment fails
# it is created by AWS automatically when you create an environment in the AWS console
# but not when you create it via terraform, so just in case it doesn't exist, we create it here

# resource "aws_iam_service_linked_role" "elasticbeanstalk" {
#   aws_service_name = "elasticbeanstalk.amazonaws.com"
#   custom_suffix    = var.application_name
# }

# resource "aws_iam_role" "beanstalk_service" {
#   name               = "${var.application_name}-beanstalk-service-role"
#   assume_role_policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Principal": {
#                 "Service": "elasticbeanstalk.amazonaws.com"
#             },
#             "Action": "sts:AssumeRole"
#         }
#     ]
# }
# EOF
# }

# resource "aws_iam_instance_profile" "beanstalk_service" {
#   name = "${var.application_name}-beanstalk-service-user"
#   role = aws_iam_role.beanstalk_service.name
# }

# resource "aws_iam_policy_attachment" "beanstalk_service_role" {
#   name       = "elastic-beanstalk-service-role"
#   roles      = ["${aws_iam_role.beanstalk_service.id}"]
#   policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AWSElasticBeanstalkServiceRolePolicy"
# }

# resource "aws_iam_policy_attachment" "beanstalk_service" {
#   name       = "elastic-beanstalk-service"
#   roles      = ["${aws_iam_role.beanstalk_service.id}"]
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
# }

# resource "aws_iam_policy_attachment" "beanstalk_service_health" {
#   name       = "elastic-beanstalk-service-health"
#   roles      = ["${aws_iam_role.beanstalk_service.id}"]
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
# }
