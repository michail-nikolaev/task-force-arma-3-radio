#!/usr/bin/env python3

import os
import sys
import subprocess
import struct
import shutil
import platform

######## GLOBALS #########
MAINPREFIX = "z"
PREFIX = "tfar_"
USEARMAKE = True
##########################

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

def check_workdrive(path, addonspath):
    workdrivepath = os.path.normpath("{}/{}/{}/".format(path, MAINPREFIX, PREFIX.rstrip("_")))
    if not os.path.exists(workdrivepath):
        os.makedirs(workdrivepath)
    workdrivepath = os.path.normpath(workdrivepath + "/addons")
    if not os.path.exists(os.path.normpath(workdrivepath + "/core")):
        os.symlink(addonspath, workdrivepath)
    return True

def main():
    print("""
  ####################
  # TFAR Debug Build #
  ####################
""")

    scriptpath = os.path.realpath(__file__)
    projectpath = os.path.dirname(os.path.dirname(scriptpath))
    addonspath = os.path.join(projectpath, "addons")
    try:
        check_workdrive(os.path.normpath(projectpath + "/include"), addonspath)
    except:
        print("The virtual workdrive could not be checked.")
        print("Please link '/addons' to 'include/{}/{}/addons'".\
            format(MAINPREFIX, PREFIX.rstrip("_")))
        print("or run this script as administrator")

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

    if platform.system() == "Windows":
        path_armake = os.path.normpath(projectpath + "/tools/armake_w64.exe")
    else:
        path_armake = "armake"

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
