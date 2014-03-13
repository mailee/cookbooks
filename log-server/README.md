# log-server cookbook

# EBS

    {
      "elasticsearch": {
        // ...
        "data" : {
          "devices" : {
            "/dev/sda2" : {
              "file_system"      : "ext3",
              "mount_options"    : "rw,user",
              "mount_path"       : "/usr/local/var/data/elasticsearch/disk1",
              "format_command"   : "mkfs.ext3",
              "fs_check_command" : "dumpe2fs",
              "ebs"            : {
                "size"                  : 250,         // In GB
                "delete_on_termination" : true,
                "type"                  : "io1",
                "iops"                  : 2000
              }
            }
          }
        }
      }
    }

# Requirements

# Usage

# Attributes

# Recipes

# Author

Author:: YOUR_NAME (<YOUR_EMAIL>)

