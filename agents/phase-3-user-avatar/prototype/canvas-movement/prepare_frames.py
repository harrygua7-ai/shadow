from pathlib import Path
from PIL import Image


ROOT = Path(__file__).parent
SOURCE = ROOT / "assets" / "stage0-transparent.png"
OUTPUT = ROOT / "assets" / "frames"

DIRECTIONS = ("down", "up", "left", "right")
COLUMNS = 6
ROWS = 4
FRAME_SIZE = (256, 256)
HEAD_ANCHOR_X = 128
GROUND_Y = 232
ALPHA_THRESHOLD = 64


def find_runs(values: list[int], minimum: int, gap: int) -> list[tuple[int, int]]:
    active = [index for index, value in enumerate(values) if value >= minimum]
    runs: list[list[int]] = []
    for index in active:
        if not runs or index - runs[-1][1] > gap:
            runs.append([index, index])
        else:
            runs[-1][1] = index
    return [(start, end + 1) for start, end in runs]


def alpha_counts(alpha: Image.Image, axis: str) -> list[int]:
    width, height = alpha.size
    if axis == "y":
        return [sum(alpha.getpixel((x, y)) > ALPHA_THRESHOLD for x in range(width)) for y in range(height)]
    return [sum(alpha.getpixel((x, y)) > ALPHA_THRESHOLD for y in range(height)) for x in range(width)]


def normalize_frame(character: Image.Image) -> Image.Image:
    alpha = character.getchannel("A")
    content_box = alpha.point(lambda value: 255 if value > ALPHA_THRESHOLD else 0).getbbox()
    if content_box is None:
        raise ValueError("Could not find character pixels")
    character = character.crop(content_box)
    alpha = character.getchannel("A")
    width, height = character.size
    head_height = max(1, round(height * 0.38))
    head_alpha = alpha.crop((0, 0, width, head_height))
    head_box = head_alpha.point(lambda value: 255 if value > ALPHA_THRESHOLD else 0).getbbox()
    if head_box is None:
        raise ValueError("Could not find a stable head anchor")

    head_center_x = (head_box[0] + head_box[2]) / 2
    paste_x = round(HEAD_ANCHOR_X - head_center_x)
    paste_y = GROUND_Y - height
    normalized = Image.new("RGBA", FRAME_SIZE, (0, 0, 0, 0))
    normalized.alpha_composite(character, (paste_x, paste_y))
    return normalized


def main() -> None:
    sheet = Image.open(SOURCE).convert("RGBA")
    alpha = sheet.getchannel("A")
    row_runs = find_runs(alpha_counts(alpha, "y"), minimum=3, gap=4)
    if len(row_runs) != ROWS:
        raise ValueError(f"Expected {ROWS} animation rows, found {row_runs}")

    OUTPUT.mkdir(parents=True, exist_ok=True)

    for direction, (row_start, row_end) in zip(DIRECTIONS, row_runs):
        row_alpha = alpha.crop((0, row_start, sheet.width, row_end))
        column_runs = find_runs(alpha_counts(row_alpha, "x"), minimum=2, gap=3)
        if len(column_runs) != COLUMNS:
            raise ValueError(f"Expected {COLUMNS} frames for {direction}, found {column_runs}")

        for column, (column_start, column_end) in enumerate(column_runs, start=1):
            character = sheet.crop((column_start, row_start, column_end, row_end))
            frame = normalize_frame(character)
            frame.save(OUTPUT / f"walk_{direction}_{column:02d}.png")

    print(f"Created {len(DIRECTIONS) * COLUMNS} aligned frames at {FRAME_SIZE[0]}x{FRAME_SIZE[1]}")


if __name__ == "__main__":
    main()
