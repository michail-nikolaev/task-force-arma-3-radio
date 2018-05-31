#!/usr/bin/env python3

import os
import sys
import subprocess
import struct
import shutil
import platform
import string
import urllib.request
import zipfile, urllib.request
import re
from distutils.version import LooseVersion, StrictVersion

#>>> version.parse("2.3.1") < version.parse("10.1.2")

######## GLOBALS #########
MAINPREFIX = "z"
PREFIX = "tfar_"
AUTOUPDATEARMAKE = True
RELEASEPAGE = "https://github.com/KoffeinFlummi/armake/releases.html"
PATH_ARMAKE = ""
##########################

def armake_latest_version():
    page = urllib.request.urlopen(RELEASEPAGE)
    bytearray = page.read()
    page.close()
    htmlstring = bytearray.decode("utf8")
    version = re.search("<a href="".*?/releases/download/v(.*?)/.*?.zip"".*?>", htmlstring)
    return version.group(1)

def armake_current_version():
    if AUTOUPDATEARMAKE: return "0.0.0"
    try:
        command = PATH_ARMAKE + " --version "
        version = subprocess.check_output(command, stderr=subprocess.STDOUT, shell=True).decode("utf8").replace("v", "")
        return version
    except:
        return "0.0.0"

def armake_download():
    version = armake_latest_version()
    latestversion = urllib.request.urlopen("https://github.com/KoffeinFlummi/armake/releases/download/v" + version + "/armake_v" + version + ".zip")
    tempfile = os.path.dirname(os.path.realpath(__file__)) + "\\armake.zip"

    with open(tempfile, "wb") as download:
        download.write(latestversion.read())
        download.close()

    with zipfile.ZipFile(tempfile) as zip_file:
        for member in zip_file.namelist():
            filename = os.path.basename(member)
            if not filename:
                continue
            source = zip_file.open(member)
            target = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), filename), "wb")
            with source, target:
                shutil.copyfileobj(source, target)



def mod_time(path):
    if not os.path.isdir(path):
        return os.path.getmtime(path)
    maxi = os.path.getmtime(path)
    for p in os.listdir(path):
        maxi = max(mod_time(os.path.join(path, p)), maxi)
    return maxi


def check_for_changes(addonspath, module):
    if not os.path.exists(os.path.join(addonspath, "{}{}.pbo".format(PREFIX, module))):
        return True
    return mod_time(os.path.join(addonspath, module)) > mod_time(os.path.join(addonspath, \
        "{}{}.pbo".format(PREFIX, module)))

def check_for_obsolete_pbos(addonspath, file):
    module = file[len(PREFIX):-4]
    if not os.path.exists(os.path.join(addonspath, module)):
        return True
    return False

def main():
    print("""
  ####################
  # TFAR Debug Build #
  ####################
""")

    scriptpath = os.path.realpath(__file__)
    projectpath = os.path.dirname(os.path.dirname(scriptpath))
    addonspath = os.path.join(projectpath, "addons")

    global PATH_ARMAKE
    if platform.system() == "Windows":
        PATH_ARMAKE = os.path.normpath(projectpath + "/tools/armake_w64.exe")
    else:
        PATH_ARMAKE = "armake"

    if (LooseVersion(armake_current_version()) < LooseVersion(armake_latest_version())):
        print("Updating armake")
        armake_download()

    os.chdir(addonspath)

    made = 0
    failed = 0
    skipped = 0
    removed = 0

    for file in os.listdir(addonspath):
        if os.path.isfile(file):
            if check_for_obsolete_pbos(addonspath, file):
                removed += 1
                print("  Removing obsolete file => " + file)
                os.remove(file)


    print("")

    for p in os.listdir(addonspath):
        path = os.path.join(addonspath, p)
        if not os.path.isdir(path):
            continue
        if p[0] == ".":
            continue
        if not check_for_changes(addonspath, p):
            skipped += 1
            print("  Skipping {}.".format(p))
            continue

        print("# Making {} ...".format(p))

        try:
            command = path_armake + " build -i " + os.path.normpath(projectpath + "/include") + \
                " -w unquoted-string -w redefinition-wo-undef -f " + \
                os.path.normpath(addonspath + "/" + p) + " " + \
                os.path.normpath(addonspath + "/" + PREFIX + p + ".pbo")
            subprocess.check_output(command, stderr=subprocess.STDOUT, shell=True)
        except:
            failed += 1
            print("  Failed to make {}.".format(p))
        else:
            made += 1
            print("  Successfully made {}.".format(p))

    print("\n# Done.")
    print("  Made {}, skipped {}, removed {}, failed to make {}.".format(made, \
        skipped, removed, failed))

    return failed

if __name__ == "__main__":
    sys.exit(main())
