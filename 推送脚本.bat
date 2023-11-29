@echo
chcp 65001

@echo off
set /p reason=输入commit标签：

echo + ------------- 开始推送gitee仓库 ------------- +
git add *
git commit -m "echo %date:~3,10% %time%-%reason%"
git push gitee master
if %errorlevel% equ 0 (
    echo + ------------- 推送gitee仓库成功 ------------ +
) else (
    echo + ------------- 推送gitee仓库失败 ------------ +
)

echo + ------------- 完成推送gitee仓库 ------------- +

echo ++++++++++++++++++++++++++++++++++++++++++++++++

echo + ------------- 开始推送github仓库 ------------ +
git push github master
if %errorlevel% equ 0 (
    echo + ------------- 推送github仓库成功 ------------ +
) else (
    echo + ------------- 推送github仓库失败 ------------ +
)

pause