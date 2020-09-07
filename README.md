# DevOps Handbook
适用于中小型团队研发运维手册。基于云端(AWS)的以GitLab社区版本为核心基础设施，并辅助代码提交评审制度实现DevOps的规范管理。


## 基建

- 搭建研发流水线基础设施（必需）
  - 版本管理[GitLab](gitlab/README.md)
  - 持续集成和部署[CI/CD](gitlab/RUNNER.md)
  - 开发团队账号创建（仅限首次启用）
- 搭建需求和缺陷管理系统（可选）
  - 协作系统[Redmine](redmine/README.md)
  - 产品、开发、测试账号创建（仅限首次启用）
  - 与GitLab的[协同](redmine/README.md#Gitlab%20Commit%20Messages)

## 研发

### GitLab入门
- [基本使用向导](https://docs.gitlab.com/ce/gitlab-basics/README.html)
- [工作流程简介](https://about.gitlab.com/blog/2016/10/25/gitlab-workflow-an-overview/)
- [持续基础配置](https://docs.gitlab.com/ce/ci/quick_start/README.html)

### 多人协同代码提交

1. 同步主基线最新代码后，为新任务创建信息分支。并在分支上进行开发。
```bash
git:(master)$ git pull --rebase
git:(master)$ git checkout -b new-task
git:(new-task)$ code .
```

2. TDD/BDD开发完成，再次与主基线同步，再次本地通过测试脚本后将开发的分支提交到远程repo
```bash
git:(new-task)$ git commit -am 'Add: new feature'
git:(new-task)$ git fetch origin master
git:(new-task)$ git rebase -i origin/master
git:(new-task)$ npm test
git:(new-task)$ git push origin HEAD
```

3. 代码提交后会触发CI流程，运行测试脚本。当测试脚本通过以后，在GitLab系统中创建Merge Request指派给有主基线合并权限评审人。

4. 评审确认commit通过，合并到主基线触发主基线集成测试。

### 版本发布

- 发布版本必需在基线上打Tag，并提供ReleaseNote。
- Tag推送远程库以后，触发持续部署输出相应的安装包或直接在Stage环境中部署。