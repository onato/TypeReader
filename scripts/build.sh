PROJECT=TypeReader
agvtool bump
VERSION_NUMBER=`sed -n '/MARKETING_VERSION/{s/MARKETING_VERSION = //;s/;//;s/^[[:space:]]*//;p;q;}' ./$PROJECT.xcodeproj/project.pbxproj`
BUILD_NUMBER=`sed -n '/CURRENT_PROJECT_VERSION/{s/CURRENT_PROJECT_VERSION = //;s/;//;s/^[[:space:]]*//;p;q;}' ./$PROJECT.xcodeproj/project.pbxproj`
BUILD_DIR=build
ARCHIVE_PATH=$PROJECT-Simulator-$VERSION_NUMBER-$BUILD_NUMBER.xcarchive

xcodebuild archive -scheme TypeReader -configuration Debug -sdk iphonesimulator -arch arm64 -archivePath $BUILD_DIR/$ARCHIVE_PATH
cd $BUILD_DIR
zip $ARCHIVE_PATH.zip -r $ARCHIVE_PATH
cd -
gh release upload $VERSION_NUMBER $BUILD_DIR/$ARCHIVE_PATH.zip --clobber

