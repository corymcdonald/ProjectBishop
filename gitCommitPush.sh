echo "Commit Message: "
read message
echo "staging files"
git config --global push.default simple
git add --all :/
git commit -m "$message"
git push origin