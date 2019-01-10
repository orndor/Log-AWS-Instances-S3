# This script takes various metadata from an instance (IP, hostname instance type, and AMI ID)
# and writes it to an index.html file. 
# It also places the SSH login string required to access the instance from the command line.
# Last, it uploads this file into an S3 bucket you define on line 20 below.
# Requirements: 
# 1) Correct IAM permissions to write to S3 buckets from EC2 instances
# 2) The same bucket setup for static website hosting.
# 3) On line 18, define the path to where your AWS key is stored.

#<---Start--->
#!/bin/bash
aws s3 cp s3://getsome.orndor.com/index.html temp.html
echo "<h2>The following EC2 Instance booted at" $(date)":</h2>" >> index.html
echo "Hostname: $(curl http://169.254.169.254/latest/meta-data/hostname) <br>" >> index.html
echo "Public IP Address: $(curl http://169.254.169.254/latest/meta-data/public-ipv4) <br>" >> index.html
echo "Instance Type: $(curl http://169.254.169.254/latest/meta-data/instance-type) <br>" >> index.html
echo "AMI ID: $(curl http://169.254.169.254/latest/meta-data/ami-id) <br>" >> index.html
echo "Login with this: ssh -l ec2-user $(curl http://169.254.169.254/latest/meta-data/public-ipv4) -i ./Keys/$(curl http://169.254.169.254/latest/meta-data/public-keys/ | cut --complement -c -1,2).pem <br>" >> index.html
cat temp.html >> index.html
aws s3 cp index.html s3://some-bucket-name/index.html
rm *.html -f
#<---End--->
