# DevOps Handbook
适用于中小型团队研发运维手册。基于云端(AWS)的以GitLab社区版本为核心基础设施，并辅助代码提交评审制度实现DevOps的规范管理。

## 团队

|角色|职责|输出|      
|:-|:-|:-|    
| `产品经理` | 需求调研及现场问题收集 | 产品原型及问题记录 |
| `研发主管` | 组织研发团队持续交付可以产品| 研发规范及绩效评估 |
| `开发工程师` | 工作量估算及代码提交及交叉评审 | 估算、代码、交叉评审记录|
| `测试工程师` | 对产品做接受测试及版本验收 | 接受性测试脚本、测试报告、版本验收结论 |
| `运维工程师` | 研发及生产环境搭建及维护，版本上线 |  研发及生产环境构建手册及灾备方案，上线记录|



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

2. 本地提交代码，需遵循以下原则：

 commit消息的摘要写明完成的任务，后续的内容用Close等关键字关闭GitLab的Issue。参考下面例子:

 ```
 Add: feature A

Close GitLab issue: close #123

# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
#
# On branch master
# Your branch is up to date with 'origin/master'.
#
# Changes to be committed:
#	new file:   a.txt
#
 ```
 一个任务一个commit。如针对一个任务多次commit需要rebase成一个commit。

```bash
git:(new-task)$ git rebase -i origin/master
```

```
pick dc6a5d3 first commit
fixup b7ac686 second commit

# Rebase c5bfe95..b7ac686 onto c5bfe95 (2 commands)
#
# Commands:
# p, pick <commit> = use commit
# r, reword <commit> = use commit, but edit the commit message
# e, edit <commit> = use commit, but stop for amending
# s, squash <commit> = use commit, but meld into previous commit
# f, fixup <commit> = like "squash", but discard this commit's log message
# x, exec <command> = run command (the rest of the line) using shell
# b, break = stop here (continue rebase later with 'git rebase --continue')
# d, drop <commit> = remove commit
# l, label <label> = label current HEAD with a name
# t, reset <label> = reset HEAD to a label
# m, merge [-C <commit> | -c <commit>] <label> [# <oneline>]
# .       create a merge commit using the original merge commit's
# .       message (or the oneline, if no original merge commit was
# .       specified). Use -c <commit> to reword the commit message.
#
# These lines can be re-ordered; they are executed from top to bottom.
#
# If you remove a line here THAT COMMIT WILL BE LOST.
#
# However, if you remove everything, the rebase will be aborted.
#
# Note that empty commits are commented out
```


3. TDD/BDD开发完成，再次与主基线同步，再次本地通过测试脚本后将开发的分支提交到远程repo
```bash
git:(new-task)$ git fetch origin master
git:(new-task)$ git rebase -i origin/master
git:(new-task)$ npm test
git:(new-task)$ git push origin HEAD
```

4. 代码提交后会触发CI流程，运行测试脚本。当测试脚本通过以后，在GitLab系统中创建Merge Request指派给有主基线合并权限评审人。

5. 评审确认commit通过，合并到主基线触发主基线集成测试。

### 版本发布

- 发布版本必需在基线上打Tag，并提供ReleaseNote。
- Tag推送远程库以后，触发持续部署输出相应的安装包或直接在Stage环境中部署。