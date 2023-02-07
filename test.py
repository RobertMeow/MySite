# convert png to webp
from PIL import Image


# for i in range(58173, 58221):
#     im = Image.open(f'static/stickers/preview/sticker{i}.png')
#     im = im.resize((352, 352))
#     im.save(f'static/stickers/preview/sticker{i}.webp', 'webp')

# im = Image.open(f'static/img/vk.png')
# im = im.resize((32, 32))
# im.save(f'static/img/vk.webp', 'webp')

from PIL import Image, ImageSequence


def reduce_frame_rate(input_file, output_file, frame_rate):
    with Image.open(input_file) as im:
        frames = [frame.copy() for frame in ImageSequence.Iterator(im)]
        new_frames = []
        for frame in frames:
            frame = frame.convert("RGBA")
            frame.putalpha(frame.split()[-1].point(lambda x: 255 if x != 0 else 0))
            frame = frame.resize((32, 32))
            new_frames.append(frame)

        frame_count = len(new_frames)
        frame_interval = int(round(frame_count / frame_rate))
        reduced_frames = [new_frames[i] for i in range(0, frame_count, frame_interval)]

        reduced_frames[0].save(
            output_file,
            save_all=True,
            append_images=reduced_frames[1:],
            duration=frame_interval,
            loop=0,
            transparency=0,
            disposal=2,
            optimize=True,
            palette=im.getpalette()

        )


reduce_frame_rate('static/img/favicon.gif', 'static/img/favicon32x32RGBA.gif', 10)
