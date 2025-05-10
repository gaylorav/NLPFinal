# NLPFinal

## Code

All code for the models can be found in .ipynb files. To run the models,
open them in Google CoLab and select "Run All." This will download all
prerequistite files and download all of the libraries. Original files in
`./three_class_models` use three classes (positive, neutral, negative),
while files in `./binary_models` use a modified dataset with only two
classes (positive and negative). In `./visualizations`,
`data_visualizations.R` utilizes word counts stored in .csv files to
create graphs, tables, and word clouds that are stored in the same
directory. The word counts are retrieved by running
`metrics_and_viz_data.ipynb`In the top-level directory, `get_data.py`
runs python code to fetch the appropriate csv files, trim them down to
the necessary components, then downloads them as `bg_descriptions.csv`
(three classes) and `bg_descriptions_v2.csv` (binary). `baseline.py`
calculates baselines for this data.
## Data

Our main data can be found in `bg_descriptions.csv` and `bg_descriptions_v2.csv`.
This is data that has been modified from this 
[Kaggle Dataset](https://www.kaggle.com/datasets/jvanelteren/boardgamegeek-reviews).

## Outside Resources

We did not use any resources not provided to us in this class, nor any specialized libraries.
