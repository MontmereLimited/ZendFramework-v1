#http://framework.zend.com/svn/framework/standard/branches/release-1.11/library/Zend

# current directory path
DIR="$( cd "$( dirname "$0" )" && pwd )"
TODAY="$( date +"%Y-%m-%d %H:%M:%S" )"

# update zend
svn update "${DIR}/../Zend"

# copy to staging location without .svn directories
rsync -avC "${DIR}/../Zend" "${DIR}"

# strip require_once since we always use an autoloader
find "${DIR}/Zend" -name '*.php' -not -wholename '*/Loader/Autoloader.php' \
	-not -wholename '*/Application.php' -print0 | \
	xargs -0 sed --regexp-extended --in-place 's/(require_once)/\/\/ \1/g'

# push to git
git add .
git commit -m "update for ${TODAY}"
git push origin master
