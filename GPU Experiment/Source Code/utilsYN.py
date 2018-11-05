"""
Common tools
"""

import numpy as np
import matplotlib.pyplot as plt
import json
import os


def get_datapath(fname=''):
    """Get data path.

    Args:
        fname (str, optional): data filename
    """
    cdir = os.path.dirname(__file__)
    with open(os.path.join(cdir, '.env')) as handle:
        ddir = json.load(handle)['DATA_PATH']
        return os.path.join(ddir, fname)


class Dataset():
    """Simple dataset container
    """

    def __init__(self, **kwds):
        """Summary

        Args:
            **kwds:
        """
        self.__dict__.update(kwds)

    def plot_examples(self, num_examples=5, fname=None):
        """Plot examples from the dataset

        Args:
            num_examples (int, optional): number of examples to
            fname (str, optional): filename for saving the plot
        """
        plot_examples(self, num_examples, fname)


def to_onehot(y, num_classes=None):
    """Convert integer class labels to one-hot encodings, e.g. 2 --> (0,0,1...)

    Args:
        y (1D array): class labels
        num_classes (None, optional): number of classes

    Returns:
        2D array: one-hot encodings / class vectors
    """
    y = np.array(y, dtype='int').ravel()
    if num_classes is None:
        num_classes = np.max(y) + 1
    n = y.shape[0]
    onehot = np.zeros((n, num_classes))
    onehot[np.arange(n), y] = 1
    return onehot


def to_label(Y):
    """Converts class vectors to integer class labels, e.g. (0,0,1...) --> 2

    Args:
        Y (2D array): class vectors

    Returns:
        1D array: integer class labels
    """
    return np.argmax(Y, axis=-1)


def plot_image(X, ax=None):
    """Plot an image X.

    Args:
        X (2D array): image, grayscale or RGB
        ax (None, optional): Description
    """
    if ax is None:
        ax = plt.gca()

    if (X.ndim == 2) or (X.shape[-1] == 1):
        ax.imshow(X.astype('uint8'), origin='upper', cmap=plt.cm.Greys)
    else:
        ax.imshow(X.astype('uint8'), origin='upper')

    ax.set(xticks=[], yticks=[])


def plot_examples(data, num_examples=5, fname=None):
    """Plot the first examples for each class in given Dataset.

    Args:
        data (Dataset): a dataset
        num_examples (int, optional): number of examples to plot for each class
        fname (str, optional): filename for saving the plot
    """
    n = len(data.classes)
    fig, axes = plt.subplots(num_examples, n, figsize=(n, num_examples))

    for l in range(n):
        axes[0, l].set_title(data.classes[l], fontsize='smaller')
        images = data.train_images[data.train_labels == l]
        for i in range(num_examples):
            plot_image(images[i], axes[i, l])

    maybe_savefig(fig, fname)


def plot_prediction(Yp, X, y, classes=None, top_n=False, fname=None):
    """Plot an image along with all or the top_n predictions.

    Args:
        Yp (1D array): predicted probabilities for each class
        X (2D array): image
        y (integer): true class label
        classes (1D array, optional): class names
        top_n (int, optional): number of top predictions to show
        fname (str, optional): filename for saving the plot
    """
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(6, 3.2))
    plt.subplots_adjust(left=0.02, right=0.98, bottom=0.15, top=0.98, wspace=0.02)
    plot_image(X, ax1)

    if top_n:
        n = top_n
        s = np.argsort(Yp)[-top_n:]
    else:
        n = len(Yp)
        s = np.arange(n)[::-1]

    patches = ax2.barh(np.arange(n), Yp[s], align='center')
    ax2.set(xlim=(0, 1), xlabel='Probability', yticks=[])

    for iy, patch in zip(s, patches):
        if iy == y:
            patch.set_facecolor('C1')  # color correct patch

    if classes is None:
        classes = np.arange(0, np.size(Yp))

    for i in range(n):
        ax2.text(0.05, i, classes[s][i], ha='left', va='center')

    maybe_savefig(fig, fname)


def plot_confusion(yp, y, classes=None, fname=None):
    """Plot confusion matrix for given true and predicted class labels

    Args:
        yp (1D array): predicted class labels
        y (1D array): true class labels
        classes (1D array): class names
        fname (str, optional): filename for saving the plot
    """
    if classes is None:
        n = max(max(yp), max(y)) + 1
        classes = np.arange(n)
    else:
        n = len(classes)

    bins = np.linspace(-0.5, n - 0.5, n + 1)
    C = np.histogram2d(y, yp, bins=bins)[0]
    C = C / np.sum(C, axis=0) * 100

    fig = plt.figure(figsize=(8, 8))
    plt.imshow(C, interpolation='nearest', vmin=0, vmax=100, cmap=plt.cm.YlGnBu)
    plt.gca().set_aspect('equal')
    cbar = plt.colorbar(shrink=0.8)
    cbar.set_label('Frequency %')
    plt.xlabel('Prediction')
    plt.ylabel('Truth')
    plt.xticks(range(n), classes, rotation='vertical')
    plt.yticks(range(n), classes)
    for x in range(n):
        for y in range(n):
            if np.isnan(C[x, y]):
                continue
            color = 'white' if x == y else 'black'
            plt.annotate('%.1f' % (C[x, y]), xy=(y, x), color=color, ha='center', va='center')

    maybe_savefig(fig, fname)


def maybe_savefig(fig, fname):
    """Save figure if filename is given."""
    if fname is not None:
        fig.savefig(fname, bbox_inches='tight')
        plt.close()
