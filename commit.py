# from distutils.dir_util import copy_tree
import shutil

from datetime import datetime
import os
# rmtree("./test")
def theTime():
    return str(datetime.now().strftime("%d-%m-%Y %Hh%Mm%Ss"))

game_folder = "E:\SteamLibrary\steamapps\common\dota 2 beta\game\dota_addons\level25"
panorama_folder = "E:\SteamLibrary\steamapps\common\dota 2 beta\content\dota_addons\level25"

backup_folder_name = theTime()
shutil.copytree("./game", f"./old/{backup_folder_name}/game")  
shutil.copytree("./panorama", f"./old/{backup_folder_name}/panorama")   
os.system('rmdir /Q /S game')
os.system('rmdir /Q /S panorama')

shutil.copytree(game_folder, "./game")  
shutil.copytree(panorama_folder, "./panorama")  
print('commited.')


