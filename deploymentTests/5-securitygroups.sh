#!/bin/bash
go get -u github.com/jvehent/pineapple
$GOPATH/bin/pineapple <<EOF
aws:
    region: ap-southeast-1
    accountnumber: 775525714357

components:
    # - name: load-balancer
    #   type: elb
    #   tag:
    #       key: elasticbeanstalk:environment-name
    #       value: moorthy-sec-201811160621-invoicer-api

    - name: application
      type: ec2
      tag:
          key: elasticbeanstalk:environment-name
          value: moorthy-sec-201811160621-invoicer-api
#
#     - name: database
#       type: rds
#       tag:
#           key: environment-name
#           value: moorthy-sec-201811160621

#    - name: bastion
#      type: ec2
#      tag:
#          key: environment-name
#          value: invoicer-bastion

rules:
    - src: 0.0.0.0/0
      dst: load-balancer
      dport: 80

    - src: load-balancer
      dst: application
      dport: 80

    - src: application
      dst: database
      dport: 5432

#    - src: bastion
#      dst: application
#      dport: 22
#
#    - src: bastion
#      dst: database
#      dport: 5432
EOF
