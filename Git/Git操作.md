###一、合并分支

1.在a分支合并b分支时，a分支会保留a和b上的共同的改变，b分支只会获得b上的改变

2.克隆指定分支：git clone -b 分支名 远端地址

3.在已有项目上拉去远端分支有两种方法：

（1）git checkout -b 本地分支名 origin/远程分支名     会直接切换到本地分支

（2）git fetch origin 本地分支名:远程分支名(推荐使用)

4.切换分支之前，删除当前分支工作区里未add的修改。git checkout .      

### 二、Git stash

进行当前代码的临时保存

例如当你目前的工作进行到一半，但同事有些改动需要你拉取。这时，你并不想提交一次commit操作，因为这会在Push后，在远端多出一次commit。此时，可以使用git stash将当前内容放入临时保存区。然后拉取同事的改动，再使用git stash apply，将自己的改动和同事的改动合并。这样之后，再进行git push的时候，就只有一次commit了。(需要注意：合并分支和恢复stash的两个操作，合并分支应该在前， 然后再恢复stash)

### 三、回退

git reset --hard    忽略掉当前所有本地修改，回到HEAD



###四、分支合并

合并分支所有改动使用,git merge

合并分支某一个commit 的改动   git cherry-pick xsd7834yduf    

git cherry-pick xsd7834yduf    当前分支合并commit"xsd7834yduf"



### 五、如何推到线上主分支

先在本地分支，使用git pull origin master拉去master分支并合并到本分支。

如果有冲突，解决冲突后，推到本地分支对应的远程分支。

再将该分支合并到master分支上。



###六、将多个commit 合为一个
(https://www.cnblogs.com/zhaoyingjie/p/10259715.html)

1.git rebase -i HEAD~n     ,  对最近的n个进行合并

2.会出现两个pick hash，需要将后一个的pick改为squash或s,表明将后一个commit 合并到前一个; :wq保存退出

3.接下来是commit message的编辑界面，会有两个commit 的信息，只留下合并后的commit 的信息就可以了



### 七、修改gitignore

1.先Pull远端文件，防止本地分支内容重新提交后冲突

2.`git rm -r --cached .`删除掉所有本地git缓存，再git add . 重新添加所有文件，最后再commit.



### 八、删除远端分支

远端分支删除后，使用git branch -a 依然能看到远端分支。这是引用没有更新。

使用`git remote show origin`能看到哪些远端分支已经过期，使用`git remote prune origin `能清掉远端origin下已过期的分支