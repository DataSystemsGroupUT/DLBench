from keras.datasets import imdb
from chainer.datasets import get_ptb_words, get_ptb_words_vocabulary


def load_imdb(train, vocabulary_size, seq_len):
    (x_train, y_train), (x_test, y_test) = imdb.load_data(num_words=vocabulary_size, maxlen=seq_len)
    return (x_train, y_train) if train else (x_test, y_test)
    
    

def load_ptb(train=True):
    train_data, _, test_data = get_ptb_words()
    return train_data if train else test_data


def load_ptb_vocab():
    return get_ptb_words_vocabulary()