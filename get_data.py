import requests
import zipfile
import os
import pandas as pd

url = "https://www.kaggle.com/api/v1/datasets/download/jvanelteren/boardgamegeek-reviews"
zip_path = "boardgame_data.zip"

# write compressed data to zip path
print("getting zip file")
response = requests.get(url, allow_redirects=True)
print("writing zip file")
with open(zip_path, "wb") as f:
    f.write(response.content)

# unzip file
print("unzipping file")
with zipfile.ZipFile(zip_path, "r") as zip_ref:
    zip_ref.extractall()

# files to delete
files_to_delete = [
    "2020-08-19.csv",
    "2022-01-08.csv",
    "bgg-19m-reviews.csv",
    "boardgame_data.zip",
    "games_detailed_info.csv",
    "bgg-26m-reviews.csv",
]

print("deleting files")
for filename in files_to_delete:
    if os.path.exists(filename):
        os.remove(filename)
        print(f"Removed {filename}")

# list remaining files
print("remaining files:")
for f in os.listdir():
    print(f)
    
# filtering down csvs
print("selecting relevant columns from csvs")
descriptions_df = pd.read_csv("games_detailed_info2025.csv")
descriptions_df = descriptions_df[["id", "description", "usersrated", "average", "name"]]

reviews_df = pd.read_csv("bgg-15m-reviews.csv")
reviews_df = reviews_df[["ID","comment", "rating"]]

print("writing out new csvs")
descriptions_df.to_csv("bg_descriptions.csv", index=False)
reviews_df.to_csv("bg_reviews.csv", index=False)

# list remaining files
print("all the files:")
for f in os.listdir():
    print(f)
