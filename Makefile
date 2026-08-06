.PHONY: all data train serve test

all: data train test

data:
	Rscript scripts/01_generate_data.R

train:
	Rscript scripts/02_train.R

serve:
	Rscript scripts/04_serve_api.R

test:
	Rscript -e 'testthat::test_dir("tests/testthat")'
