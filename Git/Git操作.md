![git流程](/Users/fengbufang/Desktop/Blogs/Git/git流程.png)

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

Xcode 使用stash时，会添加stash信息，用终端操作时，建议使用`git stash save "message..."`,这样会保留信息。同时恢复的时候，使用`git stash apply`,不会清空已有的stash列表。若不需要这个stash暂存，则手动清除就可以了。

### 三、回退

git reset --hard    忽略掉当前所有本地修改，回到HEAD

git revert commit-hash  撤销某次提交的操作。此操作不会修改原本的提交记录，而是会新增一条提交记录来抵消某次操作。



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



### 九、pull和fetch、merge

pull是将远端代码直接合入工作区。

fetch是先将远端代码拉入本地仓库，但并不影响工作区，自己可通过git diff查看区别，再决定是否通过git merge合并到工作区。但是git fetch之后，不方便查看拉下来的变动。因此建议使用 git merge --no-ff，这样无论如何都会产生一个新的 merge commit。然后git show <merge-commit-sha1> 就可以看到这次 merge 的所有改动。最后可以考虑使用git rebase合并commit。



### 十、撤销修改

1.工作区撤销：git checkout filename  ,如果多个文件，则文件之间使用空格隔开

2.暂存区修改：git reset filename, git reset会撤回所有存在暂存区的文件



### 十一、HEAD

git 中的分支，其实本质上仅仅是个指向 commit 对象的可变指针。git 是如何知道你当前在哪个分支上工作的呢？
 其实答案也很简单，它保存着一个名为 HEAD 的特别指针。在 git 中，它是一个指向你正在工作中的本地分支的指针，可以将 HEAD 想象为当前分支的别名。



### 十二、rebase

使用git pull在本地已有commit,且本地仓库落后于远端仓库的情况下生成

`[Merge remote-tracking branch 'refs/remotes/origin/develops' into develops]`

这种记录，表明将远端的仓库合并到本地。

想避免这种记录的产生。可以使用

```
git pull --rebase  //重塑本地的提交记录。
```

如果本地和远程的合并没有冲突，则合并完成。

如果有冲突，则rebase会进入一个临时分支，需要在里面解决冲突，解决完后git add 添加这些改变，再调用

``` 
git rebase --continue  //继续重塑。 
```

此时，又可能会遇到：

`No changes - did you forget to use 'git add'?`,

明明已经git add 添加过修改了，出现这种特殊情况下就使用

```
git rebase --skip
```

来跳过， 就可以了



#### 十三：将工作区直接提交到本地仓库

```
git commit -a -m"xxx" 或者 git commit -am""
```



#### 十四：

commit内容较长时，不宜直接commit -m""，而是应该先git commit，进入vim界面，再写commit描述

#### 十五：设置git token

```shell
1.git clone 以后提示输入账户和密码，其中密码直接输入token
2.在clone下来的项目输入以下指令，以后就可以直接Push，不需要再输入token
git remote set-url origin https://<your token>@github.com/<USERNAME>/<REPO>.git
```

