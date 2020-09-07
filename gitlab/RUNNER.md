# Gitlab Runner

## Install

[Offical Install Guide](https://docs.gitlab.com/runner/install/linux-repository.html)

#### Add GitLab’s official repository:
```shell
 # For Debian/Ubuntu/Mint
 curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash

 # For RHEL/CentOS/Fedora
 curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh | sudo bash
```
#### Install the latest version of GitLab Runne
```shell
 # For Debian/Ubuntu/Mint
 sudo apt-get install gitlab-runner

 # For RHEL/CentOS/Fedora
 sudo yum install gitlab-runner
```

#### Add gitlab-runner user docker privilege

```sh
sudo usermod -aG docker gitlab-runner
```

## Register

```sh
sudo gitlab-runner register -n \
  --url https://gitlab.exmaple.com \
  --tag-list "ec2-shell,be" \
  --registration-token abc1234567890dc \
  --executor shell \
  --description "backend runner"
```

`tag-list` must match `tags` in `.gitlab-ci.yml`