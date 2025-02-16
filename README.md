# Zorua - Introduction
Zorua is an all in one tool to manage multiple Pokémon GO MITMs. Zorua is used to manage, set up and maintain your Pokémon GO scanning activitities. Zorua is written in SH.



⠁⠂⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠈⠛⣷⣶⣦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠨⢻⣿⣿⣿⣶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠴⠦⠴
⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣽⡆⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠈⢳⣦⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⢀⣿⣿⣷⡀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⣶⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣷⣄⠀⠀⠀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⣀⣤⣶⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣄⠀⠀⣻⣿⣿⣿⣿⣿⣿⣷⡄⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣾⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⣽⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣦⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⣿⣿⣿⣿⣿⣿⠟⠉⠛⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⡿⠟⠁⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⡿⠏⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⣤⣤⣤⣤⡄⣤⣤⣤⣤⣤⣤⣔⣯⣄⣀⡀⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⠇⠘⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠘⠛⠛⠻⠛⡛⢛⠓⠛⠟⠛⠛⠺⠛⠛⠛⠛⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⣿⠀⠀⠀⠉⠋⠁⠉⠉⠉⠋⠉⠙⠉⠩⠻⣿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠈⠃⢀⠃⠀⠀⠐⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⣈⣻⣡⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡙⠻⢿⣿⣿⣿⠇⠀⠀

# Zorua - Features

- Auto PoGoLib Updatefunctionality
- Auto Cosmog Updatefunctionality
- Restart Cosmog functionality
- Clear ATV Cache (especially for the TX9S)
- Force Restart Cosmog
- Auto Update WebViewfunctionality
- Auto Update PoGo
- Auto Setup Furtif Tools
- Auto Update Chiteromans Play Integrity Fix Magisk Module
- Auto Update Furtif Tools

# Zorua - Setup

To get Zorua to work you need to do some things. I listed the steps for it down below:

1.
```bash
cp configs/config.ini.example configs/config.ini
```
2.
```bash
cp configs/devices.txt.example configs/devices.txt
```
3. Fill out config.ini, a more in-depth config guide is listed below.
4. Fill out devices.txt, an example is listed in the file.
5. Chmod the script
```bash
sudo chmod +x zorua.sh
```
6. Convert the script to be able to run it, since I partly wrote it in VS code on Windows.
```bash
sudo apt-get install dos2unix
```
7.
```bash
dos2unix zorua.sh
```

8. You can do ./zorua.sh --function, a list of functions and their respective commands are listed below.

# Zorua - Dependicies

1. Unzip
```bash
sudo apt install unzip
```

2. ADB
```bash
wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip
```
```bash
unzip platform-tools-latest-linux.zip
```
```bash
mv platform-tools-linux ~/platform-tools
```
```bash
nano ~/.bashrc
```
Add the following
```bash
export PATH="$HOME/platform-tools:$PATH"
```
```bash
source ~/.bashrc
```
3. JQ

```bash
sudo apt install jq
```


# Zorua - ToDoList

- [ ] Add more MITMs
- [ ] Give Zorua a watchfunction with possibilities to be ran as SystemCTL service/PM2
- [ ] Restart MITM on all devices
- [ ] Device aliases
- [ ] Per device actions
- [ ] Automatically delete Android System apps that aren't significant
- [ ] A set up script (aConf?)

# Zorua - Config

```ini
[system]
webview_download_link =                                                                     # Webview downloadable link, but the 96 version
webview_download_link_130 =                                                                 # Webview downloadable link, but the 130 version

[logging]
logging_info_color = '\033[0;34m'                                                           # Logging info color, the most used one
logging_warning_color = '\033[0;33m'                                                        # Logging warning color
logging_error_color = '\033[0;31m'                                                          # Logging error color
logging_succes_color = '\033[0;32m'                                                         # Logging succes color
logging_nc_color = '\033[0m'                                                                # Logging NC color

[pogo]
version = latest                                                                            # PoGo version you want to use, in most cases this is latest
pogo_mirror_url = https://mirror.unownhash.com                                              # PoGo mirror url, the best option is to use the Unownhash.com mirror
pogo_arch = arm64-v8a                                                                       # PoGo Arch, the arch you want the PoGo APK to be this is arm64-v8a in most cases
pogo_apk_arch = arm64-v8a                                                                   # PoGo APK arch, the same as the one above

[cosmog]
package_name = com.nianticlabs.pokemongo.ares                                               # Cosmog package name
download_link =                                                                             # Cosmog download link

[pogolib]
mirror_url = https://mirror.unownhash.com                                                   # PoGo APK mirror url to get the PoGoLib from, the Unownhash.com mirror works the best
arch = arm64-v8a                                                                            # PoGoLib Arch, should in most cases be arm64-v8a
version = latest                                                                            # PoGoLib version

[furtif_tools]
mapworld_download_url = https://protomines.ddns.net/apk/MapWorld-release.zip                # Mapworld download link

[adb]
device_file = configs/devices.txt                                                           # Device file containing the device IP addresses
```

# Zorua - Webview Links
Old Webview (96): https://www.apkmirror.com/apk/google-inc/android-system-webview/android-system-webview-96-0-4664-92-release/

Newer webview (130): https://www.apkmirror.com/apk/google-inc/android-system-webview/android-system-webview-130.0.6723.40-release/

Keep in mind, that it will NOT work to put a APKMIrror link as download link. I tried that and it kept giving me unusabe files.

# Zorua - Updating

Because of dos2unix, git pull will shoot you an error that you changed a file. This is easily solvable by just removing the zorua.sh file and then git pulling. Here is how to do that:

1.
```shell
rm zorua.sh
```
2.
```shell
git pull
```

# Zorua - Contributing⠀⠀

I would love people to help make Zorua better. PRs are always appreciated! Here is a short guide on how to do that.

1. Fork this repository
2. `git clone` your fork
3. Create a new brach using `git checkout -b newfunction` you can replace newfunction with the name of your function
4. Make your new changes
5. `git add .` (this will add everything to the repo)
6. `git commit -m "Some new function wich makes running this easier."` replace Some new function wich makes running this easier. with your actual new feature
7. `git push` - this will push your new functions to your fork
8. Create a pull request using the GitHub WebUI.

Once you have submitted your PR, I will look at it and give feedback. I will also devide wheter I want to merge it or not.
