@echo
chcp 65001

echo + ------------- 补充推送github仓库 ------------ +
git push github master
if %errorlevel% equ 0 (
    echo + ------------- 完成推送github仓库 ------------ +
) else (
    echo + ------------- 推送github仓库失败 ------------ +
)

pause