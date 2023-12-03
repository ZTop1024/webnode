@echo
chcp 65001

echo + ------------- 开始从gitee仓库拉取最新代码 ------------- +
git pull gitee master
if %errorlevel% equ 0 (
    echo + ------------- 拉取gitee仓库最新代码成功 ------------ +
) else (
    echo + ------------- 拉取gitee仓库最新代码失败 ------------ +
)

pause