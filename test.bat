@echo
chcp 65001

echo 测试
variable=%date% %time%

git add *
git commit -m "variable-验证"
git push origin master

pause