git clone https://github.com/flutter/flutter.git
sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev
echo 'export PATH="$PATH:`pwd`/flutter/bin"' >> $HOME/.bashrc
# use the following command, and then line 8 if the previous command fails
# export PATH="$PATH:`pwd`/flutter/bin"
which flutter dart
# Install Dart and Flutter extensions
flutter doctor && flutter pub get && flutter run -d web-server --web-hostname 127.0.0.1 --web-port 8084