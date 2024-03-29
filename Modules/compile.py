import os
import sys

def prRed(skk): print("\033[91m {}\033[00m" .format(skk))
 
 
def prGreen(skk): print("\033[92m {}\033[00m" .format(skk))
 
 
def prYellow(skk): print("\033[93m {}\033[00m" .format(skk))
 
 
def prLightPurple(skk): print("\033[94m {}\033[00m" .format(skk))
 
 
def prPurple(skk): print("\033[95m {}\033[00m" .format(skk))
 
 
def prCyan(skk): print("\033[96m {}\033[00m" .format(skk))
 
 
def prLightGray(skk): print("\033[97m {}\033[00m" .format(skk))
 
 
def prBlack(skk): print("\033[98m {}\033[00m" .format(skk))

COMPILED_FOLDER = "."
MODULE_FOLDER = "."

if __name__ == "__main__":
    module_name = sys.argv[1]
    file_argvs = []
    for argv_index in range(2, len(sys.argv)):
        file_argvs.append(sys.argv[argv_index])

    compiled_file_path = f"{COMPILED_FOLDER}/{module_name}"
    iverilog_cmd = f"iverilog -o {compiled_file_path}"
    for file_argv in file_argvs:
        iverilog_cmd += f" {MODULE_FOLDER}/{file_argv}"

    # vvp to generate simulate file
    vvp_cmd = f"vvp {compiled_file_path}"
    try:
        os.system(iverilog_cmd)
        os.system(vvp_cmd)
        # clean compiled file
        os.remove(compiled_file_path)
        prGreen("COMPILED SUCCESSFULLY!")
    except Exception as e:
        prRed(f"FAILED TO COMPILE!!!")
