#!/bin/bash
set -e #  Exit immediately if a command exits with a non-zero status.
#_LIVE_DIR=${LIVE_DIR:=live}
LIVE_DIR=${LIVEDIR}
echo var LIVE_DIR is passed through and has value $LIVE_DIR
_BACKEND_TPL=${BACKEND_TPL:=backend.tf.tpl}
BRANCH_NAME=${BRANCH_NAME}

echo  TF_VAR_app_name = ${TF_VAR_app_name}
echo  BRANCH_NAME =  ${BRANCH_NAME}
echo  TF_VAR_region =  ${TF_VAR_region}
echo  LIVEDIR = ${LIVEDIR}
echo
# echo show git branch but test ADO predefined variable
# echo 1 THis gives an error $(Build.SourceBranchName)
echo 2 Predefined variable BUILD_SOURCEBRANCHNAME has value  $BUILD_SOURCEBRANCHNAME
echo 3 Pass-through variable BRANCH_NAME has value $BRANCH_NAME
echo "..........................."


if [[ -z "$BRANCH_NAME" ]]; then
    echo "[ERROR] Must set BRANCH_NAME environment variable"
    exit 1
fi
if [[ -z "$TF_VAR_app_name" ]]; then
    echo "[ERROR] Must set TF_VAR_app_name environment variable"
    exit 1
fi

if [[ -z "$AWS_REGION" ]]; then
    echo "[ERROR] Must set AWS_REGION environment variable"
    exit 1
fi

# if [[ $LIVE_DIR = "live" ]]
# then
#     DIRSOURCE=$LIVE_DIR
#     DIRTOCREATE=$_BRANCH_NAME
# else
#     DIRSOURCE=$LIVE_DIR
#     DIRTOCREATE=${_BRANCH_NAME}/${TF_VAR_app_name}
# fi 
# echo dir source = $DIRSOURCE
# echo dir to create = $DIRTOCREATE

DIRSOURCE=$LIVE_DIR
DIRTOCREATE=${BRANCH_NAME}/${TF_VAR_app_name}
echo DIRTOCREATE dir = ${DIRTOCREATE}
mkdir -p "${DIRTOCREATE}"/

echo "Copying ${DIRSOURCE} to ${DIRTOCREATE}"
cp "${DIRSOURCE}"/* "${DIRTOCREATE}"/
echo "Copying tflint configuration file for aws provider"
cp  "${DIRSOURCE}"/.tflint.hcl "${DIRTOCREATE}"/
sed -i.bak 's~AWS_REGION~'"$AWS_REGION"'~' "${DIRTOCREATE}/${_BACKEND_TPL}"
sed -i.bak 's~APP_NAME~'"$TF_VAR_app_name"'~' "${DIRTOCREATE}/${_BACKEND_TPL}"
sed -i.bak 's~ENVIRONMENT~'"$_BRANCH_NAME"'~' "${DIRTOCREATE}/${_BACKEND_TPL}"
mv "${DIRTOCREATE}/${_BACKEND_TPL}" "${DIRTOCREATE}"/backend.tf
echo "[LOG] Prepared files and folders for the environment - $DIRTOCREATE"
ls -lah "$DIRTOCREATE"
cat "${DIRTOCREATE}"/backend.tf
echo "SHow PWD $PWD"
ls -l
cd ${DIRTOCREATE}
echo "Now changed the branch subdir $PWD"  #/home/vsts/work/1/s/preps/dev