from PIL import Image, ImageDraw, ImageFont
import glob
import os
from pathlib import Path

# ----------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# Roy van der Veen <roy@ijsco-media.nl> wrote this file. As long as you retain
# this notice you can do whatever you want with this stuff. If we meet some day,
# and you think this stuff is worth it, you can buy me a beer in return.
# ----------------------------------------------------------------------------

print(sorted(glob.glob("arts/result-*.png"), key=os.path.normpath))
art_file = sorted(glob.glob("arts/result-*.png"), key=os.path.normpath)[-1]
timestamp = art_file.split("-")[-1].split(".")[0]
print(timestamp)
prompt_file = sorted(glob.glob("arts/result-{}.txt".format(timestamp)), key=os.path.normpath)[-1]

prompt_f = open(prompt_file)
prompt = prompt_f.readline().rstrip().encode("ascii", "ignore").decode()
im1 = Image.open(art_file)

print(prompt)

# create an image
out = Image.new("RGB", (480, 800), (0, 0, 0))

# get a font
font_path = "Oswald-Light.ttf"
# get a drawing context
d = ImageDraw.Draw(out)

text_width = 460
text_max_height = 800-512-10-10

size = 36
while size > 9:
    font = ImageFont.truetype(font_path, size)
    lines = []
    line = ""
    for word in prompt.split():
        proposed_line = line
        if line:
            proposed_line += " "
        proposed_line += word
        if font.getlength(proposed_line) <= text_width:
            line = proposed_line
        else:
            # If this word was added, the line would be too long
            # Start a new line instead
            lines.append(line)
            line = word
    if line:
        lines.append(line)
    prompt = "\n".join(lines)

    x1, y1, x2, y2 = d.multiline_textbbox((10,522), prompt, font, stroke_width=2)
    w, h = x2 - x1, y2 - y1
    if h <= text_max_height:
        break
    else:
        # The text did not fit comfortably into the image
        # Try again at a smaller font size
        size -= 1

d.multiline_text((10,522), prompt, font=font, align="center", stroke_width=2, stroke_fill="#000")

# Draw the generated image (512x512) into the 580x800 destination image, chopping 16 pixels off each side
out.paste(im1, (-16,0))

out.save("arts/output-{}.png".format(timestamp))
out.save("arts/output-latest.png")
