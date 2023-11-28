@echo
chcp 65001

@echo off
set /p reason=输入commit标签：

echo + ------------- 开始推送gitee仓库 ------------- +
git add *
git commit -m "echo %date:~3,10% %time%-%reason%"
git push gitee master
echo + ------------- 完成推送gitee仓库 ------------- +

echo ++++++++++++++++++++++++++++++++++++++++++++++++

echo + ------------- 开始推送github仓库 ------------ +
git push github master
if %errorlevel% equ 0 (
    echo + ------------- 完成推送github仓库 ------------ +
) else (
    echo + ------------- 推送github仓库失败 ------------ +
)

pause