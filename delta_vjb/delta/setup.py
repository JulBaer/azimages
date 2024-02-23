import pathlib
import os
import subprocess
from setuptools import setup, find_packages

HERE = pathlib.Path(__file__).parent

VERSION = (
    subprocess.run(["git", "describe"], capture_output=True)
    .stdout.decode("utf-8")
    .strip()
)

PACKAGE_NAME = "delta2"
AUTHOR = "Jean-Baptiste Lugagne, Owen OConnor"
AUTHOR_EMAIL = "jblugagne@bu.edu, ooconnor@bu.edu"
URL = "https://gitlab.com/dunloplab/delta"

LICENSE = "MIT License"
DESCRIPTION = "Segments and tracks bacteria"
LONG_DESCRIPTION = (HERE / "README.md").read_text()
LONG_DESC_TYPE = "text/markdown"
URL = "https://gitlab.com/dunloplab/delta"

INSTALL_REQUIRES = [
    "scikit-image>=0.18",
    "tifffile>=2020",
    "opencv-python>=4.1",
    "tensorflow>=2.0",
    "ffmpeg-python",
    "requests",
]

setup(
    name=PACKAGE_NAME,
    version=VERSION,
    description=DESCRIPTION,
    long_description=LONG_DESCRIPTION,
    long_description_content_type=LONG_DESC_TYPE,
    author=AUTHOR,
    license=LICENSE,
    author_email=AUTHOR_EMAIL,
    url=URL,
    install_requires=INSTALL_REQUIRES,
    packages=find_packages(include=["delta", "delta.*"]),
    python_requires=">=3.7",
    setup_requires=["pytest-order", "pytest-runner", "flake8"],
    tests_require=["pytest"],
    package_data={
        "tests": [
            "data/movie_2D_tif/*.tif",
            "data/movie_mothermachine_tif/*.tif",
            "data/images/*.tif",
        ]
    },
)
