#!/usr/bin/env python3

import argparse
import io
import random
import typing
from pathlib import Path

import numpy as np
import PIL
import pypdfium2 as pdfium
import util_functions
from PIL import Image, ImageEnhance, ImageFilter


def add_gaussian_noise(image: PIL.Image, mean=0, std_dev=0.025) -> Image:
    img = np.array(image) / 255.0  # Normalize pixel values to [0, 1]
    noise = np.random.normal(mean, std_dev, img.shape)
    noisy_img = img + noise
    noisy_img = np.clip(noisy_img, 0, 1)  # Ensure pixel values remain within [0, 1]
    noisy_img *= 255  # Scale back to [0, 255] for display
    return Image.fromarray(np.uint8(noisy_img))


def reduce_image_quality(image, quality=100, compression="JPEG") -> Image:
    img_byte_array = io.BytesIO()
    image.save(img_byte_array, quality=quality, format=compression)
    img_byte_array.seek(0)

    reduced_image = Image.open(img_byte_array)
    return reduced_image


def _change_image_to_byte_buffer(image, compression="JPEG") -> io.BytesIO:
    img_byte_array = io.BytesIO()
    image.save(img_byte_array, quality=95, format=compression)
    img_byte_array.seek(0)
    return img_byte_array


def main():
    parser = argparse.ArgumentParser(
        prog="Convert input PDF to scanned PDF",
        description="Convert input PDF to scanned PDF.",
    )

    parser.add_argument(
        "input_file",
        help="Input File.",
        type=Path,
    )

    parser.add_argument(
        "output_file",
        help="Output File.",
        type=Path,
    )

    args = parser.parse_args()

    input_file: Path = args.input_file
    output_file: Path = args.output_file

    if not input_file.exists():
        util_functions.print_error("Input File does not exist.")
        return 1

    if not input_file.suffix.lower() == ".pdf":
        util_functions.print_error("Input File is not a PDF file.")
        return 1

    images_list: typing.List[io.BytesIO] = []

    doc = pdfium.PdfDocument(input_file)

    if doc.get_formtype():
        doc.init_forms()

    for page in doc:
        bitmap = page.render(scale=2)
        image: Image = bitmap.to_pil()
        image = image.convert("RGB")

        image = reduce_image_quality(image, 95)

        enhancer = ImageEnhance.Brightness(image)
        image = enhancer.enhance(random.uniform(1.01, 1.02))

        image = add_gaussian_noise(image, mean=0, std_dev=0.03)

        image = image.filter(ImageFilter.GaussianBlur(random.uniform(0.5, 0.75)))

        image = image.rotate(
            random.uniform(-1.01, 1.01), resample=Image.Resampling.BICUBIC, expand=True, fillcolor=(255, 255, 255)
        )

        images_list.append(_change_image_to_byte_buffer(image))
        page.close()
    doc.close()

    if images_list:
        output_pdf: pdfium.PdfDocument = pdfium.PdfDocument.new()
        for image_file in images_list:
            pdf_image = pdfium.PdfImage.new(output_pdf)
            pdf_image.load_jpeg(image_file)
            width, height = pdf_image.get_size()

            width = width / 2
            height = height / 2

            matrix = pdfium.PdfMatrix().scale(width, height)
            pdf_image.set_matrix(matrix)

            page = output_pdf.new_page(width, height)
            page.insert_obj(pdf_image)
            page.gen_content()
            page.close()
            pdf_image.close()

        output_pdf.save(output_file, version=17)
        output_pdf.close()

    util_functions.print_success(f"Created successfully!\n\tResult file: {output_file.as_posix()}")


if __name__ == "__main__":
    main()
