@echo
chcp 65001

git pull gitee master
if %errorlevel% equ 0 (
    echo + ------------- 拉取gitee仓库成功 ------------ +
) else (
    echo + ------------- 拉取gitee仓库失败 ------------ +
)

pause