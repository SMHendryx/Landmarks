# Landmarks

## Visualization

To save images with plotted landmarks run `Python/visualizeLandmarks.py`. The coordinate type will be inferred from the length of the first non-empty txt file in each directory of coordinates (third argument onwards). Plotted landmark images will be saved in a new directory of the name of the inferred coordinate type. See `Bash/visualizeLandmarks.sh` for example usage. `visualizeLandmarks.py` arguments are: 

- First argument: path to directory containing base images
- Second argument: path to write output (plotted landmarks)
- Third argument: path to directory containing coordinate annotations in .txt.
- Fourth argument onwards: path(s) to additional directories containing coordinate files to be plotted, such as from landmark-finding software

### Dependencies

- [numpy](http://www.numpy.org/)
- [Pillow](https://github.com/python-pillow/Pillow)
