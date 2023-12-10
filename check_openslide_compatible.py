#%%
import openslide
import os
#%%
# Path to the image
path = "/home/jackson/research/data/HTAN/tiff/converted/01_500_10_1_15_999_70_tiled.tiff"

slide = openslide.OpenSlide(path)
slide.read_region((0,0), 0, (1000,1000))

# %%
