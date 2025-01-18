#!/usr/bin/env python
import numpy as np

# importing the csv with data
import pandas as pd
df = pd.read_csv("data.csv")
Vx = dict(zip(zip(df["x"], df["y"]), df["Vx"]))
Vy = dict(zip(zip(df["x"], df["y"]), df["Vy"]))

# calculating Ex and Ey
def getEx(x, y):
    assert x > 0, "x must be positive"
    dx = 3 - (3 - x)%3 # previous multiple of 3
    return (Vx[(x-dx, y)] - Vx[(x,y)]) / (.01 * dx)

def getEy(x, y):
    assert y > 0, "y must be positive"
    dy = 3 - (3 - y)%3 # previous multiple of 3
    return (Vy[(x, y-dy)] - Vy[(x,y)]) / (.01 * dy)

def norm(x, y):
    return np.sqrt(getEx(x, y)**2 + getEy(x, y)**2)

# plotting the electric field
import matplotlib.pyplot as plt
# insert photo of setup in the background, cropped and semi-transparent
from PIL import Image
image = Image.open("Lab3/figures/viscrop.png")
# image = image.crop((12, 11, image.width - 6, image.height - 6))
im_array = np.array(image)

# Creating figure
fig, ax = plt.subplots()
ax.imshow(im_array, extent=[-1.8, 21, -1.1, 27], aspect='auto', alpha=0.2)

x = df["x"][df["x"] > 0]
y = df["y"][(df["y"] > 0) & (df["y"] < 25)]

X, Y = np.meshgrid(x, y)
Ex = np.array([[-getEx(x, y)/norm(x,y) for x, y in zip(X_row, Y_row)] for X_row, Y_row in
               zip(X, Y)]) # wrong data sign flipped, I'll correct it here
Ey = np.array([[getEy(x, y)/norm(x,y) for x, y in zip(X_row, Y_row)] for X_row, Y_row in
                zip(X, Y)])

# Defining color
color = np.array([[min(np.log(18), np.log(norm(x, y))) for x, y in zip(X_row, Y_row)] for X_row, Y_row in
                  zip(X, Y)])

# Creating plot
ax.quiver(X, Y, Ex, Ey, color, scale=18, cmap="winter")
ax.xaxis.set_ticks([])
ax.yaxis.set_ticks([])
ax.axis("off")
ax.set_xlim([-2, 22])
ax.set_ylim([-2, 27])
ax.set_aspect("equal")


# plt.show()
plt.savefig("Lab3/figures/field.png", dpi=300)

