import sys

from PIL import Image

from inky.auto import auto
from inky import Inky_Impressions_7 as Inky

# ----------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# Roy van der Veen <roy@ijsco-media.nl> wrote this file. As long as you retain
# this notice you can do whatever you want with this stuff. If we meet some day,
# and you think this stuff is worth it, you can buy me a beer in return.
# ----------------------------------------------------------------------------

#inky = auto(ask_user=True, verbose=True)
inky = Inky()
saturation = 0.5

if len(sys.argv) == 1:
    print("""
Usage: {file} image-file
""".format(file=sys.argv[0]))
    sys.exit(1)

image = Image.open(sys.argv[1])
image = image.rotate(90, Image.NEAREST, expand = 1)
resizedimage = image.resize(inky.resolution)

if len(sys.argv) > 2:
    saturation = float(sys.argv[2])

inky.set_image(resizedimage, saturation=saturation)
inky.show()
