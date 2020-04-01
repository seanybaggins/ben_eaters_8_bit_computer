from vunit import VUnit
from pathlib import Path

SRC_PATH = Path(__file__).parent / "src"
TEST_PATH = Path(__file__).parent / "tests"

# External obect for VUnit options
vu = VUnit.from_argv()

vu.add_library("tests").add_source_files(TEST_PATH / "*.vhd")
src_lib = vu.add_library("src").add_source_files(SRC_PATH / "*.vhd")

# Run vunit function
vu.main()