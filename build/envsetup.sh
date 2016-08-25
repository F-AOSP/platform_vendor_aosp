function __print_aosp_functions_help() {
cat <<EOF
Additional CyanogenMod functions:
- cmremote:        Add git remote for CM Gerrit Review.
- aospremote:      Add git remote for matching AOSP repository.
- cafremote:       Add git remote for matching CodeAurora repository.
EOF
}

function cmremote()
{
    if ! git rev-parse --git-dir &> /dev/null
    then
        echo ".git directory not found. Please run this from the root directory of the Android repository you wish to set up."
        return 1
    fi
    git remote rm cmremote 2> /dev/null
    GERRIT_REMOTE=$(git config --get remote.github.projectname)
    CMUSER=$(git config --get review.review.cyanogenmod.org.username)
    if [ -z "$CMUSER" ]
    then
        git remote add cmremote ssh://review.cyanogenmod.org:29418/$GERRIT_REMOTE
    else
        git remote add cmremote ssh://$CMUSER@review.cyanogenmod.org:29418/$GERRIT_REMOTE
    fi
    echo "Remote 'cmremote' created"
}

function aospremote()
{
    if ! git rev-parse --git-dir &> /dev/null
    then
        echo ".git directory not found. Please run this from the root directory of the Android repository you wish to set up."
        return 1
    fi
    git remote rm aosp 2> /dev/null
    PROJECT=$(pwd -P | sed "s#$ANDROID_BUILD_TOP\/##")
    if (echo $PROJECT | grep -qv "^device")
    then
        PFX="platform/"
    fi
    git remote add aosp https://android.googlesource.com/$PFX$PROJECT
    echo "Remote 'aosp' created"
}

function cafremote()
{
    if ! git rev-parse --git-dir &> /dev/null
    then
        echo ".git directory not found. Please run this from the root directory of the Android repository you wish to set up."
        return 1
    fi
    git remote rm caf 2> /dev/null
    PROJECT=$(pwd -P | sed "s#$ANDROID_BUILD_TOP\/##")
    if (echo $PROJECT | grep -qv "^device")
    then
        PFX="platform/"
    fi
    git remote add caf git://codeaurora.org/$PFX$PROJECT
    echo "Remote 'caf' created"
}
