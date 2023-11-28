@echo
chcp 65001

@echo off
set /p reason=输入commit标签：

echo + ------------- 开始推送github仓库 ------------- +
git add *
git commit -m "%date% %time%-%reason%"
git push gitee master
echo + ------------- 完成推送github仓库 ------------- +

pause